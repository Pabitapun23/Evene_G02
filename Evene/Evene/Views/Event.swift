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

