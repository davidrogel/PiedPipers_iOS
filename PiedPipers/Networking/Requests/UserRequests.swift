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
    typealias Response = String
    
    var method: Methods { return .PATCH }
    
    var baseUrl: String { return urlToServer }
    
    var path: Self.Endpoint { return userUpdate }
    
    var headers: [String : String] {
        return ["Content-Type":"application/json"]
    }
    
    var body: Any {
        return [
            "password":password
        ]
    }
    
    let password: String
}
