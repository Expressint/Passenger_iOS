//
//  ARCarMovement.swift
//  ARCarMovement
//
//  Created by Mac05 on 24/10/17.
//  Copyright © 2017 Antony Raphel. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

extension Int {
    var degreesToRadiansAR: Double { return Double(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadiansAR: Self { return self * .pi / 180 }
    var radiansToDegreesAR: Self { return self * 180 / .pi }
}

// MARK: - delegate protocol
@objc public protocol ARCarMovementDelegate {
    
    /**
     *  Tells the delegate that the specified marker will be move with animation.
     */
    func ARCarMovementMoved(_ Marker: GMSMarker)
}

public class ARCarMovement: NSObject {

    // MARK: Public properties
    public weak var delegate: ARCarMovementDelegate?
    public var duration: Float = 2.0
    
    public func ARCarMovement(marker: GMSMarker, oldCoordinate: CLLocationCoordinate2D, newCoordinate:CLLocationCoordinate2D, mapView: GMSMapView, bearing: Float) {
    
        //   let calBearing: Float = getHeadingForDirection(fromCoordinate: oldCoordinate, toCoordinate: newCoordinate)
           marker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
          // marker.rotation = CLLocationDegrees(calBearing); //found bearing value by calculation when marker add
           marker.position = newCoordinate
   //        CATransaction.setCompletionBlock({() -> Void in
   //            marker.rotation = (Int(bearing) != 0) ? CLLocationDegrees(bearing + 90) : CLLocationDegrees(calBearing)
   //        })
        
    }
    
    private func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {
        
        let fLat: Float = Float((fromLoc.latitude).degreesToRadiansAR)
        let fLng: Float = Float((fromLoc.longitude).degreesToRadiansAR)
        let tLat: Float = Float((toLoc.latitude).degreesToRadiansAR)
        let tLng: Float = Float((toLoc.longitude).degreesToRadiansAR)
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegreesAR
        return (degree >= 0) ? degree : (360 + degree)
    }
    
}
