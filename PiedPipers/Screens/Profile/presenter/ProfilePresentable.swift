//
//  ProfilePresentable.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 23/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

enum contactTypePresentable: String {
    case email
    case phone
}

typealias TypePresentable = ContactType // Uso el mismo enum que el Profile

struct ContactPresentable {
    let type: TypePresentable
    let data: String
}

struct LocationPresentable: Codable
{
    let lat: Double
    let long: Double
}

struct VideoPresentable {
    let id: String?
    let videoURL: String?
    let thumbnail: String?
}

struct ProfilePresentable
{
    let name: String?
    let city: String?
    let avatar: String?
    let location: LocationPresentable?
    let contact: ContactPresentable?
    let instruments: [String]?
    let videos: [VideoPresentable]?
    let aboutMe: String?
    let invitations: [String]
    
    init(name: String? = nil, city: String? = nil, avatar: String? = nil, location: LocationPresentable?,
         contact: ContactPresentable? = nil, instruments: [String]? = nil, videos: [VideoPresentable]? = nil, aboutMe: String? = nil, invitations: [String])
    {
        self.name = name
        self.city = city
        self.avatar = avatar
        self.location = location
        self.contact = contact
        self.instruments = instruments
        self.videos = videos
        self.aboutMe = aboutMe
        self.invitations = invitations
    }
}

extension ProfilePresentable {
    var proxyForEquality: String {
        return ""
    }
}

//extension ProfilePresentable: Equatable {
//    static func == (lhs: ProfilePresentable, rhs: ProfilePresentable) -> Bool {
//        return true
//    }
//
//
//}
