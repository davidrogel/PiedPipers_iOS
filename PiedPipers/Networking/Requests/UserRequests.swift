//
//  CreateUserRequest.swift
//  PiedPipers
//
//  Created by david rogel pernas on 31/10/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

// tener una manera de generar cabeceras facilmente
//enum Headers: String
//{
//    case ContentType = "Content-Type"
//    case ApplicationJSON = "application/json"
//}

struct CreateUserRequest: APIRequest
{
    typealias Response = User
    
    var method: Methods { return .POST }
    
    var baseUrl: String { return urlToServer }
    
    var path: Self.Endpoint { return userCreate }
    
    var headers: [String : String] {
        return ["Content-Type":"application/json"]
    }
    
    var body: Any {
        return [
            "email":email,
            "password":password
        ]}
    
    let email: String
    let password: String
}

struct LoginUserRequest: APIRequest
{
    typealias Response = User
    
    var method: Methods { return .POST }
    
    var baseUrl: String { return urlToServer }
    
    var path: Self.Endpoint { return userLogin }
    
    var headers: [String : String] {
        return ["Content-Type":"application/json"]
    }
    
    var body: Any {
        return [
            "email":email,
            "password":password
        ]
    }
    
    let email: String
    let password: String
}

struct UpdateUserRequest: APIRequest
{
    typealias Response = User
    
    var method: Methods { return .PATCH }
    
    var baseUrl: String { return urlToServer }
    
    var path: Self.Endpoint { return userUpdate }
    
    var headers: [String : String] {
        let authToken = StoreManager.shared.getString(withKey: currentUserCuid)
        return ["Content-Type":"application/json",
                "Authorization":authToken]
    }
    
    var body: Any {
        return [
            "password":password
        ]
    }
    
    let currentUserCuid: String
    let password: String
}

struct DeleteUserRequest: APIRequest
{
    // La respuesta es 200 si se ha borrado con exito
    typealias Response = Int
    
    var method: Methods { return .DELETE }
    
    var baseUrl: String { return urlToServer }
     
    var path: Self.Endpoint { return userDelete }
    
    var headers: [String : String] {
        let authToken = StoreManager.shared.getString(withKey: currentUserCuid)
        return ["Authorization":authToken]
    }
    
    let currentUserCuid: String
}
