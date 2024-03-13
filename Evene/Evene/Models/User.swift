//
//  User.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-11.
//

import Foundation
import FirebaseFirestore

struct User : Codable, Hashable {
    @DocumentID var id : String? = UUID().uuidString
    var firstName: String
    var lastName: String
    var fullName: String
    var email: String
    var password: String
    var phoneNumber: String
//    var address: UserAddress?
    var address: String
    var profilePic: URL?
    var friendList: [User]?
    
    init(firstName: String, lastName: String, fullName: String, email: String, password: String, phoneNumber: String, address: String, profilePic: URL? = nil, friendList: [User]?) {
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = fullName
        self.email = email
        self.password = password
        self.phoneNumber = phoneNumber
        self.address = address
        self.profilePic = profilePic
        self.friendList = friendList
    }
}
