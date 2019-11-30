//
//  Profile.swift
//  PiedPipers
//
//  Created by david rogel pernas on 01/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

struct Profile
{
    typealias Photo = String
    typealias _Video = Video
    
    let cuid: String
    let name: String?
    let location: Location?
    let contact: Contact?
    let instruments: [String]?
    let videos: [_Video]?
    let description: String?
    let photo: Photo?
    let friendlyLocation: String?

    init(cuid: String, name: String? = nil,
         location: Location? = nil, contact: Contact? = nil,
         instruments: [String]? = nil, videos: [_Video]? = nil,
         description: String? = nil, photo: Photo? = nil,
         friendlyLocation: String? = nil)
    {
        self.cuid = cuid
        self.name = name
        self.location = location
        self.contact = contact
        self.instruments = instruments
        self.videos = videos
        self.description = description
        self.photo = photo
        self.friendlyLocation = friendlyLocation
    }
}

extension Profile: Codable
{
    fileprivate enum CodingKeys: String, CodingKey
    {
        case cuid
        case name
        case location
        case contact
        case instruments
        case videos
        case description
        case photo
        case friendlyLocation
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        cuid = try container.decode(String.self, forKey: .cuid)
        
        name = try container.decodeIfPresent(String.self, forKey: .name)
        location = try container.decodeIfPresent(Location.self, forKey: .location)
        contact = try container.decodeIfPresent(Contact.self, forKey: .contact)
        instruments = try container.decodeIfPresent([String].self, forKey: .instruments)
        videos = try container.decodeIfPresent([_Video].self, forKey: .videos)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        photo = try container.decodeIfPresent(Photo.self, forKey: .photo)
        friendlyLocation = try container.decodeIfPresent(String.self, forKey: .friendlyLocation)
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(cuid, forKey: .cuid)
        
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(contact, forKey: .contact)
        try container.encodeIfPresent(instruments, forKey: .instruments)
        try container.encodeIfPresent(videos, forKey: .videos)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(photo, forKey: .photo)
        try container.encodeIfPresent(friendlyLocation, forKey: .friendlyLocation)
    }
}

extension Profile
{
    func toBody() -> [String:Any]
    {
        var body = [String:Any]()
        // No es necesario en CUID en el body
//        var body:[String:Any] = [
//            "cuid":cuid
//        ]
        
        if let name = name
        {
            body["name"] = name
        }
        
        if let location = location
        {
            let locat:[String:Any] = ["lat":NSNumber(value: location.lat), "long":NSNumber(value: location.long)]
            body["location"] = locat
        }
        
        if let contact = contact
        {
            body["contact"] = ["type":contact.type.rawValue, "data":contact.data]
        }
        
        if let instruments = instruments
        {
            body["instruments"] = instruments
        }
        
        if let videos = videos
        {
            body["videos"] = videos.map({ (video) -> [String:Any] in
                video.toBody()
            })
        }
        
        if let description = description
        {
            body["description"] = description
        }
        
        // La foto nunca se envía al servidor desde aquí, tiene una Request especial
//        if let photo = photo
//        {
//            body["photo"] = photo
//        }
        
        if let friendlyLocation = friendlyLocation
        {
            body["friendlyLocation"] = friendlyLocation
        }
        
        return body
    }
}
