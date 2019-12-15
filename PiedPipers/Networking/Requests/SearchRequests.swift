//
//  SearchRequests.swift
//  PiedPipers
//
//  Created by david rogel pernas on 16/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

/**
    Parametros que se envían en la request de Perfiles

    - name:String?
    - instruments:[String]?
    - friendlyLocation:String?
    - lat:Double?
    - long:Double?
 
*/
struct SearchProfileParameters: Codable
{
    var name: String?
    var instruments: [String]?
    var friendlyLocation: String?
    var lat: Double?
    var long: Double?
//    
//    init(name: String? = nil, instruments: [String]? = nil,
//         friendlyLocation: String? = nil,
//         lat: Double? = nil, long: Double? = nil)
//    {
//        self.name = name
//        self.instruments = instruments
//        self.friendlyLocation = friendlyLocation
//        self.lat = lat
//        self.long = long
//    }
}

// TODO - Lipiar comentarios y llevarse de aqui las estructs de los parámetros

struct GetProfileBySearchingRequest: APIRequest
{
    typealias Response = ProfileList
    
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
    
//    let name: String?
//    let instruments: [String]?
//    let friendlyLocation: String?
//    let lat: Double?
//    let long: Double?
    let limit: Int
    let offset: Int
    
    let profileParameters: SearchProfileParameters?
    
    init(cuid:String, profileParameters: SearchProfileParameters? = nil/*name: String? = nil, instruments: [String]? = nil,
         friendlyLocation: String? = nil, lat: Double? = nil,
         long: Double? = nil*/, limit: Int, offset: Int)
    {
        self.currentUserCuid = cuid
        self.profileParameters = profileParameters
//        self.name = name
//        self.instruments = instruments
//        self.friendlyLocation = friendlyLocation
//        self.lat = lat
//        self.long = long
        self.limit = limit
        self.offset = offset
    }
}

extension GetProfileBySearchingRequest
{
    private func generateParams() -> [String:String]
    {
        var params = [String:String]()
        
        if let profileParameters = profileParameters
        {
            if let name = profileParameters.name
            {
                params["name"] = name
            }
            
            if let instruments = profileParameters.instruments
            {
                params["instruments"] = instruments.joined(separator: ",")
            }
            
            if let friendlyLocation = profileParameters.friendlyLocation
            {
                params["friendlyLocation"] = friendlyLocation
            }
            
            if let lat = profileParameters.lat,
                let long = profileParameters.long
            {
                params["lat"] = lat.description
                params["long"] = long.description
            }
        }
        
        params["limit"] = limit.description
        params["offset"] = offset.description
        
        return params
    }
}

/**
    Parametros que se envían en la request de Locales

    - name:String?
    - price:Double?
    - lat:Double?
    - long:Double?
 */
struct SearchLocalParameters: Codable
{
    var name: String?
    var price: Double?
    var lat: Double?
    var long: Double?
    
//    init(name: String? = nil, price: Double? = nil,
//         lat: Double? = nil, long: Double? = nil)
//    {
//        self.name = name
//        self.price = price
//        self.lat = lat
//        self.long = long
//    }
}

struct GetLocalBySearchingRequest: APIRequest
{
    typealias Response = LocalList
    
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
    
//    let name: String?
//    let price: Double?
//    let lat: Double?
//    let long: Double?
    let limit: Int
    let offset: Int
    
    let localParameters: SearchLocalParameters?
    
    init(cuid:String, localParameters: SearchLocalParameters? = nil /*name: String? = nil, price: Double? = nil, lat: Double? = nil,
         long: Double? = nil*/, limit: Int, offset: Int)
    {
        self.currentUserCuid = cuid
//        self.name = name
//        self.price = price
//        self.lat = lat
//        self.long = long
        self.limit = limit
        self.offset = offset
        
        self.localParameters = localParameters
    }
}

extension GetLocalBySearchingRequest
{
    private func generateParams() -> [String:String]
    {
        var params = [String:String]()
        
        if let localParameters = localParameters
        {
            if let name = localParameters.name
            {
                params["name"] = name
            }
            
            if let price = localParameters.price
            {
                params["price"] = price.description
            }
            
            if let lat = localParameters.lat,
                let long = localParameters.long
            {
                params["lat"] = lat.description
                params["long"] = long.description
            }
        }
        
        params["limit"] = limit.description
        params["offset"] = offset.description
        
        return params
    }
}

