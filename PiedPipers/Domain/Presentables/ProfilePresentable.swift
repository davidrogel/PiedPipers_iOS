//
//  ProfilePresentable.swift
//  PiedPipers
//
//  Created by david rogel pernas on 06/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

struct CurrentUserProfilePresentable
{
    let name: String?
    let city: String?
    let avatar: URL?
    let contact: String?
    let instruments: [String]?
    
    init(name: String? = nil, city: String? = nil, avatar: URL? = nil,
         contact: String? = nil, instruments: [String]? = nil)
    {
        self.name = name
        self.city = city
        self.avatar = avatar
        self.contact = contact
        self.instruments = instruments
    }
}

