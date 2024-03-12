//
//  User.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-11.
//

import Foundation

struct User : Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var email: String
    var password: String
    var phoneNumber: String
    var address: String
    var profilePic: URL?
    
    init(name: String, email: String, password: String, phoneNumber: String, address: String, profilePic: URL? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.phoneNumber = phoneNumber
        self.address = address
        self.profilePic = profilePic
    }
}
