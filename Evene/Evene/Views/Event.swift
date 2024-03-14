//
//  Event.swift
//  Evene
//
//  Created by Alfie on 2024/3/10.
//

import Foundation

struct Event: Codable{
    var id:Int
    var eventName:String
    let date: String
    let venue: Venue
    let performers: [Performers]
    
    enum CodingKeys:String, CodingKey {
        case id
        case eventName = "title"
        case venue
        case performers
        case date = "datetime_utc"
    }
}

struct Venue: Codable {
    let address: String
    let city: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case address
        case city
        case name
    }
}

struct Performers: Codable {
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case image
    }
}

struct EventsResponseObject:Decodable {
    var events:[Event]
}

extension Event {
    func toDictionary() throws -> [String: Any] {
        var dictionary: [String: Any] = [:]

        dictionary["id"] = self.id
        dictionary["eventName"] = self.eventName
        dictionary["date"] = self.date
        dictionary["venue"] = try self.venue.toDictionary()
        dictionary["performers"] = try self.performers.map { try $0.toDictionary() }

        return dictionary
    }
}

extension Venue {
    func toDictionary() -> [String: Any] {
        return [
            "address": self.address,
            "city": self.city,
            "name": self.name
        ]
    }
}

extension Performers {
    func toDictionary() -> [String: Any] {
        return [
            "image": self.image
        ]
    }
}
