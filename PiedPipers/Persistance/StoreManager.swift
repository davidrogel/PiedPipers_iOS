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
    /// Singleton pattern
    public static let shared = StoreManager()
    
    private let userDefaults = UserDefaults.standard
    
    private let keychain = KeychainSwift()
    
    public func save(dataOnKeyChain data: String, withKey key: String)
    {
        keychain.set(data, forKey: key)
    }
    
    public func save(dataOnKeyChain data: Bool, withKey key: String)
    {
        keychain.set(data, forKey: key)
    }
    
    public func save(dataOnKeyChain data: Data, withKey key: String)
    {
        keychain.set(data, forKey: key)
    }
    
    public func getString(withKey key: String) -> String
    {
        return keychain.get(key) ?? ""
    }
    
    public func getBoolean(withKey key: String) -> Bool?
    {
        return keychain.getBool(key)
    }
    
    public func getData(withKey key: String) -> Data?
    {
        return keychain.getData(key)
    }
    
    func getLoggedUser() -> String {
        guard let currentUserCuid = userDefaults.string(forKey: "currentCuid") else {
            return ""
        }
        return currentUserCuid
    }
    
    func setLoggedUser(userCuid: String) {
        userDefaults.set(userCuid, forKey: "currentCuid")
    }
    
    func removeStoreCuid() {
        userDefaults.removeObject(forKey: "currentCuid")
    }
}
