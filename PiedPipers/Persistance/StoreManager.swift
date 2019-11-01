//
//  StoreManager.swift
//  PiedPipers
//
//  Created by david rogel pernas on 01/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation
import KeychainSwift

final class StoreManager
{
    fileprivate static let keychain = KeychainSwift()
    
    public static func save(dataOnKeyChain data: String, withKey key: String)
    {
        keychain.set(data, forKey: key)
    }
    
    public static func save(dataOnKeyChain data: Bool, withKey key: String)
    {
        keychain.set(data, forKey: key)
    }
    
    public static func save(dataOnKeyChain data: Data, withKey key: String)
    {
        keychain.set(data, forKey: key)
    }
    
    public static func getString(withKey key: String) -> String
    {
        return keychain.get(key) ?? ""
    }
    
    public static func getBoolean(withKey key: String) -> Bool?
    {
        return keychain.getBool(key)
    }
    
    public static func getData(withKey key: String) -> Data?
    {
        return keychain.getData(key)
    }
}
