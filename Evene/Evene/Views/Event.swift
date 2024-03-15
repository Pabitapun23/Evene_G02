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
    
    let description: String?
    let url: String?
    let type: String
    
    let stats: Stats
    
    enum CodingKeys:String, CodingKey {
        case id
        case type
        case eventName = "title"
        case venue
        case performers
        case date = "datetime_local"
        
        case description
        case url
        
        case stats
    }
}

struct Venue: Codable {
    let address: String
    let city: String
    let name: String
        
    let country: String
    let externalPurchaseLink: String
    let location: Location

    
    enum CodingKeys: String, CodingKey {
        case address
        case city
        case name

        case country
        case externalPurchaseLink = "url"
        case location
    }
}

struct Location: Codable {
    let lat: Double
    let lon: Double
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
    }
}

struct Performers: Codable {
    let id: Int
    let name: String
    let image: String
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case url
    }
}

struct Stats: Codable {
    let listingCount: Int?
    let averagePrice: Int?
    let lowestPrice: Int?
    let highestPrice: Int?
    let visibleListingCount: Int?
    let ticketCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case listingCount = "listing_count"
        case averagePrice = "average_price"
        case lowestPrice = "lowest_price"
        case highestPrice = "highest_price"
        case visibleListingCount = "visible_listing_count"
        case ticketCount = "ticket_count"
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
        dictionary["venue"] = self.venue.toDictionary()
        dictionary["stats"] = self.stats.toDictionary()
        dictionary["performers"] = self.performers.map { $0.toDictionary() }

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

extension Stats {
    func toDictionary() -> [String: Any] {
        return [
            "listingCount": self.listingCount ?? 0,
            "averagePrice": self.averagePrice ?? 0,
            "lowestPrice": self.lowestPrice ?? 0,
            "highestPrice": self.highestPrice ?? 0,
            "visibleListingCount": self.visibleListingCount ?? 0,
            "ticketCount": self.ticketCount ?? 0
        ]
    }
}
