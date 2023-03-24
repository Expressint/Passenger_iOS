//
//  LocationInfo.swift
//  DPS
//
//  Created by Gaurang on 06/10/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import Foundation
import CoreLocation
import GooglePlaces

struct LocationInfo {
    let title: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    
    var text: String {
        if address.contains(title) {
            return address
        } else {
            return [title, address].joined(separator: ", ")
        }
    }
    
    init(title: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.address = address
        self.coordinate = coordinate
    }
    
    init(address: String, coordinate: CLLocationCoordinate2D) {
        var array = address
            .split(separator: ",")
            .map({String($0).trimmed})
        self.title = array.first ?? ""
        if array.count > 1 {
            array.removeFirst()
        }
        self.address = array.joined(separator: ", ")
        self.coordinate = coordinate
    }
    
//    init?(recent: RecentAddress) {
//        title = recent.title
//        address = recent.address
//        if let location = CLLocationCoordinate2D(latString: recent.latitude, lngString: recent.longitude) {
//            coordinate = location
//        } else {
//            return nil
//        }
//    }
    
    init(place: GMSPlace) {
        self.title = place.name ?? ""
        self.address = place.formattedAddress ?? ""
        self.coordinate = place.coordinate
    }
    
//    init?(favourite: FavouriteAddressListModel) {
//        var array = favourite.pickupLocation.split(separator: ",").map({String($0).trimmed})
//        self.title = array.first ?? ""
//        if array.count > 1 {
//            array.removeFirst()
//        }
//        self.address = array.joined(separator: ", ")
//        if let location =  CLLocationCoordinate2D(latString: favourite.pickupLat, lngString: favourite.pickupLng) {
//            self.coordinate = location
//        } else {
//            return nil
//        }
//    }
}
