//
//  ProfileRequests.swift
//  PiedPipers
//
//  Created by david rogel pernas on 01/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

/// Obtiene el perfil del usuario loggeado
/// es necesario pasar un token de autorización
struct GetProfileRequest: APIRequest
{
    typealias Response = Profile
    
    var method: Methods { return .GET }
    
    var baseUrl: String { return urlToServer }
    
    var path: Self.Endpoint { return profileGet }
    
    var headers: [String : String] {
        let authToken = StoreManager.getString(withKey: currentUserCuid)
        return ["Authorization":authToken]
    }
    
    let currentUserCuid: String
}

struct GetProfileByIdRequest: APIRequest
{
    typealias Response = Profile
    
    var method: Methods { return .GET }
    
    var baseUrl: String { return urlToServer }
    
    var path: Self.Endpoint { return (profileGet + findUserCuid) }
    
    var headers: [String : String] {
        let authToken = StoreManager.getString(withKey: currentUserCuid)
        return ["Authorization":authToken]
    }
    
    let currentUserCuid: String
    let findUserCuid: String
}


