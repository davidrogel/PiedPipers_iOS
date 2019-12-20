//
//  Notification.swift
//  PiedPipers
//
//  Created by david rogel pernas on 16/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation



enum NotiState: String, Codable
{
    case pending
    case redeemed
}

enum NotiType: String, Codable
{
    case follow
}

/*
 
 CUID -> id de la notificación para poder redimirla
 
 ORIGEN -> Persona que envía la peticion
 DESTINATION -> Persona a la que le llega
 {
     "cuid": "ck406fpu200003epcdszo3iil",
     "notificationType": "follow",
     "data": {
         "image": "",
         "origin": "ck2w7u2el00010cpc5d0i1lnm",
         "originName": "Eric Sans",
         "destination": "ck40dve7l00013epcdiq9gmju",
         "destinationName": "Alberto García"
     },
     "destination": "ck40dve7l00013epcdiq9gmju",
     "dateAdded": "2019-12-10T22:10:56.109Z",
     "state": "pending"
 }
 */

struct Piper_Notification
{
    typealias `Type` = NotiType
    typealias State = NotiState
    
    let cuid: String // CUID de la notificación, para luego poder redimirla
    let dateAdded: String // yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
    let notificationType: Type
    let destination: String
    let state: State
    let data: FollowNotification
}

typealias Noti = Piper_Notification

extension Piper_Notification: Codable
{
    fileprivate enum CodingKeys: String, CodingKey
    {
        case cuid
        case dateAdded
        case notificationType
        case destination
        case state
        case data
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        cuid = try container.decode(String.self, forKey: .cuid)
        dateAdded = try container.decode(String.self, forKey: .dateAdded)
        notificationType = try container.decode(Type.self, forKey: .notificationType)
        destination = try container.decode(String.self, forKey: .destination)
        state = try container.decode(State.self, forKey: .state)
        data = try container.decode(FollowNotification.self, forKey: .data)
        
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(cuid, forKey: .cuid)
        try container.encode(dateAdded, forKey: .dateAdded)
        try container.encode(notificationType, forKey: .notificationType)
        try container.encode(destination, forKey: .destination)
        try container.encode(state, forKey: .state)
        try container.encode(data, forKey: .data)
    }
}
