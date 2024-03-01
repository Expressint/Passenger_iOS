//
//  NetworkEnvironment.swift
//  Book A Ride
//
//  Created by Gaurang on 06/12/23.
//  Copyright © 2023 Excellent Webworld. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case development
    case live
}

extension NetworkEnvironment {
    static var current: NetworkEnvironment = .development
    
    var baseURL: String {
        switch self {
        case .development:
            return "http://52.23.45.119"
        case .live:
            return "https://www.bookaridegy.com"
        }
    }
    
    var apiBaseURL: String {
        switch self {
        case .development:
            return "\(baseURL)/v3/Passenger_Api/"
        case .live:
            return "\(baseURL)/v3/Passenger_Api/"
        }
    }
    
    var socketURL: String {
        "\(baseURL):8080"
    }
    
    var imageBaseURL: String {
        "\(baseURL)/"
    }
    
    var paymentBaseURL: String {
        "\(baseURL)/"
    }
}
