//
//  UserAddress.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-13.
//

import Foundation

struct UserAddress : Codable{
    var address: String = ""
    var lat: Double = 0.0
    var lng: Double = 0.0
    
    init(address: String, lat: Double, lng: Double) {
        self.address = address
        self.lat = lat
        self.lng = lng
    }
}
