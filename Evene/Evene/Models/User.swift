//
//  User.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-11.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User : Codable {
    @DocumentID var id : String? = UUID().uuidString
    var firstName: String
    var lastName: String
    var fullName: String
    var email: String
    var password: String
    var phoneNumber: String
    var address: String
    var profilePic: URL?
    var friendList: [User]?
    var eventList: [Event]?
    
    
    
    init(firstName: String, lastName: String, fullName: String, email: String, password: String, phoneNumber: String, address: String, profilePic: URL? = URL(string: "https://static.vecteezy.com/system/resources/previews/009/007/039/original/funny-cartoon-woman-face-cute-avatar-or-portrait-girl-with-orange-curly-hair-young-character-for-web-in-flat-style-print-for-sticker-emoji-icon-minimalistic-face-illustration-vector.jpg"), friendList: [User]?, eventList: [Event]?) {
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = fullName
        self.email = email
        self.password = password
        self.phoneNumber = phoneNumber
        self.address = address
        self.profilePic = profilePic
        self.friendList = friendList
        self.eventList = eventList
    }
    
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

extension User: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension User {
    func toDictionary() throws -> [String: Any] {
        var dictionary: [String: Any] = [:]

//        dictionary["id"] = self.id
        dictionary["firstName"] = self.firstName
        dictionary["lastName"] = self.lastName
        dictionary["fullName"] = self.fullName
        dictionary["email"] = self.email
        dictionary["password"] = self.password
        dictionary["phoneNumber"] = self.phoneNumber
        dictionary["address"] = self.address
        dictionary["profilePic"] = self.profilePic?.absoluteString
        // Convert friendList to array of dictionaries
        if let friendList = self.friendList {
            let friendListDict = try friendList.map { try $0.toDictionary() }
            dictionary["friendList"] = friendListDict
        }
        // Convert eventList to array of dictionaries
        if let eventList = self.eventList {
            // You need to implement a similar toDictionary() method for the Event struct
            let eventListDict = try eventList.map { try $0.toDictionary() }
            dictionary["eventList"] = eventListDict
        }

        return dictionary
    }
}
