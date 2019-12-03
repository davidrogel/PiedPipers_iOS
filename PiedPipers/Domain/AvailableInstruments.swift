//
//  AvailableInstruments.swift
//  PiedPipers
//
//  Created by david rogel pernas on 03/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

/**
 
 Retorno =>
 {
     "total": 8,
     "offset": 0,
     "items": [
         "guitarra",
         "bateria",
         "bajo",
         "contrabajo",
         "violín",
         "pandero",
         "castañuelas",
         "zambomba"
     ]
 }
*/

struct AvailableInstruments
{
    let total:Int
    let offset:Int
    let items:[String]
    
    init(total: Int, offset: Int, items: [String])
    {
        self.total = total
        self.offset = offset
        self.items = items
    }
}

extension AvailableInstruments : Codable
{
    fileprivate enum CodingKeys: String, CodingKey
    {
        case total
        case offset
        case items
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        total = try container.decode(Int.self, forKey: .total)
        offset = try container.decode(Int.self, forKey: .offset)
        items = try container.decode([String].self, forKey: .items)
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(total, forKey: .total)
        try container.encode(offset, forKey: .offset)
        try container.encode(items, forKey: .items)
    }
}
