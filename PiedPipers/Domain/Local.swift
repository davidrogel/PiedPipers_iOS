//
//  Local.swift
//  PiedPipers
//
//  Created by david rogel pernas on 17/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

struct Local
{
    typealias Photo = String
    
    let cuid: String
    let name: String
    let dateAdded: String // yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
    let location: Location
    let price: Double
    let contact: Contact
    let photos: [Photo]
    let description: String
}

extension Local: Codable
{
    fileprivate enum CodingKeys: String, CodingKey
    {
        case cuid
        case name
        case dateAdded
        case location
        case price
        case contact
        case photos
        case description
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        cuid = try container.decode(String.self, forKey: .cuid)
        name = try container.decode(String.self, forKey: .name)
        dateAdded = try container.decode(String.self, forKey: .dateAdded)
        location = try container.decode(Location.self, forKey: .location)
        price = try container.decode(Double.self, forKey: .price)
        contact = try container.decode(Contact.self, forKey: .contact)
        photos = try container.decode([Photo].self, forKey: .photos)
        description = try container.decode(String.self, forKey: .description)
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(cuid, forKey: .cuid)
        try container.encode(name, forKey: .name)
        try container.encode(dateAdded, forKey: .dateAdded)
        try container.encode(location, forKey: .location)
        try container.encode(price, forKey: .price)
        try container.encode(contact, forKey: .contact)
        try container.encode(photos, forKey: .photos)
        try container.encode(description, forKey: .description)
    }
}


