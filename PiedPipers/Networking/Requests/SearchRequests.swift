//
//  SearchRequests.swift
//  PiedPipers
//
//  Created by david rogel pernas on 16/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

struct GetProfileBySearching: APIRequest
{
    typealias Response = [ProfileList]
    
    var method: Methods { return .GET }
    
    var baseUrl: String { return urlToServer }
    
    var path: Self.Endpoint { return searchProfile }
    
    var headers: [String : String] {
        let authToken = StoreManager.shared.getString(withKey: currentUserCuid)
        return ["Authorization":authToken]
    }
    
    var parameters: [String : String] {
        return generateParams()
    }
    
    let currentUserCuid: String
    
    let name: String?
    let instruments: [String]?
    let friendlyLocation: String?
    let lat: Double?
    let long: Double?
    let limit: Int
    let offset: Int
    
    init(cuid:String, name: String? = nil, instruments: [String]? = nil,
         friendlyLocation: String? = nil, lat: Double? = nil,
         long: Double? = nil, limit: Int, offset: Int)
    {
        self.currentUserCuid = cuid
        self.name = name
        self.instruments = instruments
        self.friendlyLocation = friendlyLocation
        self.lat = lat
        self.long = long
        self.limit = limit
        self.offset = offset
    }
}

extension GetProfileBySearching
{
    private func generateParams() -> [String:String]
    {
        var params = [String:String]()
        
        if let name = name
        {
            params["name"] = name
        }
        
        if let instruments = instruments
        {
            params["instruments"] = instruments.joined(separator: ",")
        }
        
        if let friendlyLocation = friendlyLocation
        {
            params["friendlyLocation"] = friendlyLocation
        }
        
        if let lat = lat, let long = long
        {
            params["lat"] = lat.description
            params["long"] = long.description
        }
        
        params["limit"] = limit.description
        params["offset"] = offset.description
        
        return params
    }
}

struct GetLocalBySearching: APIRequest
{
    typealias Response = [LocalList]
    
    var method: Methods { return .GET }
    
    var baseUrl: String { return urlToServer }
    
    var path: Self.Endpoint { return searchLocals }
    
    var headers: [String : String] {
        let authToken = StoreManager.shared.getString(withKey: currentUserCuid)
        return ["Authorization":authToken]
    }
    
    var parameters: [String : String] {
        return generateParams()
    }
    
    let currentUserCuid: String
    
    let name: String?
    let price: Double?
    let lat: Double?
    let long: Double?
    let limit: Int
    let offset: Int
    
    init(cuid:String, name: String? = nil, price: Double? = nil, lat: Double? = nil,
         long: Double? = nil, limit: Int, offset: Int)
    {
        self.currentUserCuid = cuid
        self.name = name
        self.price = price
        self.lat = lat
        self.long = long
        self.limit = limit
        self.offset = offset
    }
}

extension GetLocalBySearching
{
    private func generateParams() -> [String:String]
    {
        var params = [String:String]()
        
        if let name = name
        {
            params["name"] = name
        }
        
        if let price = price
        {
            params["price"] = price.description
        }
        
        if let lat = lat, let long = long
        {
            params["lat"] = lat.description
            params["long"] = long.description
        }
        
        params["limit"] = limit.description
        params["offset"] = offset.description
        
        return params
    }
}

