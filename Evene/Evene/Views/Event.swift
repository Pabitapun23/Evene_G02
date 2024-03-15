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
//    let stats: Stats
    
    let description: String?
    let url: String?
    let type: String
    
    enum CodingKeys:String, CodingKey {
        case id
        case type
        case eventName = "title"
//        case stats
        case venue
        case performers
        case date = "datetime_local"
        
        case description
        case url
    }
}

struct Venue: Codable {
    let address: String
    let city: String
    let name: String
    
    let country: String
    let externalPurchaseLink: String?
    
    enum CodingKeys: String, CodingKey {
        case address
        case city
        case name

        case country
        case externalPurchaseLink = "url"
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
    let listingCount: Int
    let averagePrice: Int
    let lowestPrice: Int
    let highestPrice: Int
    let visibleListingCount: Int
    let ticketCount: Int

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
//        dictionary["stats"] = self.stats.toDictionary()
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
            "listingCount": self.listingCount,
            "averagePrice": self.averagePrice,
            "lowestPrice": self.lowestPrice,
            "highestPrice": self.highestPrice,
            "visibleListingCount": self.visibleListingCount,
            "ticketCount": self.ticketCount

        ]
    }
}
