//
//  Contact.swift
//  PiedPipers
//
//  Created by david rogel pernas on 17/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

enum ContactType: String, Codable
{
    case email
    case phone
}

struct Contact: Codable
{
    let type: ContactType
    let data: String
}
