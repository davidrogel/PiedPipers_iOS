//
//  List.swift
//  PiedPipers
//
//  Created by david rogel pernas on 17/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

struct APIList<T:Codable>: Codable
{
    let total: Int
    let offset: Int
    let items: [T]
}

typealias ProfileList = APIList<Profile>
typealias LocalList = APIList<Local>
