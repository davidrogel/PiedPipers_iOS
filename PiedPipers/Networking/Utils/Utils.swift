//
//  Utils.swift
//  PiedPipers
//
//  Created by david rogel pernas on 01/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

extension AnyHashable
{
    public static func == (lhs: AnyHashable, rhs: String) -> Bool
    {
        return lhs.description == rhs
    }
}
