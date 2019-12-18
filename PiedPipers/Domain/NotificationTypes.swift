//
//  NotificationTypes.swift
//  PiedPipers
//
//  Created by david rogel pernas on 17/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

struct FollowNotification
{
    typealias Photo = String
    
    /// imagen del perfil
    let image: Photo?
    /// cuid del perfil del que sale la notificación
    let origin: String
    /// nombre del perfil del que sale la notificación
    let originName: String
    /// cuid del perfil del usuario al que le llega la notificación
    let destination: String
    /// nombre del perfil del usuario al que le llega la notificación
    let destinationName: String
    
    init(image: Photo, origin: String, originName: String,
         destination: String, destinationName: String)
    {
        self.image = image
        self.origin = origin
        self.originName = originName
        self.destination = destination
        self.destinationName = destinationName
    }
}

extension FollowNotification: Codable
{
    fileprivate enum CodingKeys: String, CodingKey
    {
        case image
        case origin
        case originName
        case destination
        case destinationName
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        image = try container.decodeIfPresent(String.self, forKey: .image)
        origin = try container.decode(String.self, forKey: .origin)
        originName = try container.decode(String.self, forKey: .originName)
        destination = try container.decode(String.self, forKey: .destination)
        destinationName = try container.decode(String.self, forKey: .destinationName)
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(image, forKey: .image)
        try container.encode(origin, forKey: .origin)
        try container.encode(originName, forKey: .originName)
        try container.encode(destination, forKey: .destination)
        try container.encode(destinationName, forKey: .destinationName)
    }
}
