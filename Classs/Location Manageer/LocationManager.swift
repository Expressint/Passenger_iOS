//
//  LocationManager.swift
//  FairRide
//
//  Created by Gaurang on 06/10/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import SocketIO

protocol LocationManagerDelegate {
    func locationManager(_ manager: LocationManager, didUpdateLocation mostRecentLocation: CLLocation)
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager()
    private lazy var locationManager = CLLocationManager()
    var delegate: LocationManagerDelegate?

    var mostRecentLocation: CLLocation?
    
    var coordinate: CLLocationCoordinate2D? {
        mostRecentLocation?.coordinate
    }
    
    var latitude: Double? {
        coordinate?.latitude
    }
    
    var longitude: Double? {
        coordinate?.longitude
    }
    
    var speed: CLLocationSpeed? {
        locationManager.location?.speed
    }
    
    var bearing: CLLocationDirection {
        mostRecentLocation?.course ?? 0
    }

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType = .automotiveNavigation
        locationManager.startMonitoringSignificantLocationChanges()
    }

    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.locationManager.requestAlwaysAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        self.mostRecentLocation = mostRecentLocation
        delegate?.locationManager(self, didUpdateLocation: mostRecentLocation)
        
       // MeterManager.shared.locationUpdate(location: mostRecentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self.locationManager.requestAlwaysAuthorization()
        case .restricted, .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.openSettingsDialog()
            }
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }
    
    func openSettingsDialog() {
        let message = "Please allow app to access location for track the location."
        let alertVC = UIAlertController(title: "Essential!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsAppURL = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        AppDelegate.current?.window?.rootViewController?.present(alertVC, animated: true)
    }
}
