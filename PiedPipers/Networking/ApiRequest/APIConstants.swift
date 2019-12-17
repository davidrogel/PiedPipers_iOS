//
//  APIConstants.swift
//  PiedPipers
//
//  Created by david rogel pernas on 01/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

// ("En videojuegos no se hacen copias se hacen tributos")
// Idea tomada de la estructura HTTPMethods de Alamofire
struct EndPoint: RawRepresentable, Equatable, Hashable
{
    //MARK: User
    /// /users/create
    static let userCreate = EndPoint(rawValue: "/users/create")
    /// /users/login
    static let userLogin = EndPoint(rawValue: "/users/login")
    /// /users/update
    static let userUpdate = EndPoint(rawValue: "/users/update")
    /// /users
    static let userDelete = EndPoint(rawValue: "/users")
    
    //MARK: Profile
    /// /profile
    static let profileGet = EndPoint(rawValue: "/profile")
    /// /profile/     /profile/:cuid
    static let profileByIdGet = EndPoint(rawValue: "/profile/")
    /// /profile/avatar
    static let avatarUpdate = EndPoint(rawValue: "/profile/avatar")
    /// /profile/tags
    static let tagsGet = EndPoint(rawValue: "/profile/tags")
    
    //MARK: Searching
    /// /search/profile
    static let searchProfile = EndPoint(rawValue: "/search/profile")
    /// /search/local
    static let searchLocals = EndPoint(rawValue: "/search/local")
    
    //MARK: Notifications
    /// /notification/      /notification/:cuid
    static let notiDelete = EndPoint(rawValue: "/notification/")
    /// /notification
    static let notiList = EndPoint(rawValue: "/notification")
    /// /notification/redeem/     /notification/redeem/:cuid
    static let notiRedeem = EndPoint(rawValue: "/notification/redeem/")
    /// /notification/register
    static let notiRegister = EndPoint(rawValue: "/notification/register")
    /// /notification/unregister
    static let notiUnregister = EndPoint(rawValue: "/notification/unregister")
    
    let rawValue: String
    
    /// El init también nos permite crear una nueva clave si no existe y somos muy vagos de venir aqui para añadirla
    init(rawValue: String)
    {
        self.rawValue = rawValue
    }
    
    public static func +<T:CustomStringConvertible> (lhs: EndPoint, rhs: T) -> EndPoint
    {
        return EndPoint(rawValue: lhs.rawValue + rhs.description)
    }
}
