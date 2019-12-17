//
//  APIConstants.swift
//  PiedPipers
//
//  Created by david rogel pernas on 01/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

//enum APIEndpoint : String
//{
//    // User
//    case userCreate = "/users/create"
//    case userLogin = "/users/login"
//    case userUpdate = "/users/update"
//
//    // Profile
//    case profileGet = "/profile"
//}

// User
/// /users/create
let userCreate = "/users/create"
/// /users/login
let userLogin = "/users/login"
/// /users/update
let userUpdate = "/users/update"
/// /users
let userDelete = "/users"

// Profile
/// /profile
let profileGet = "/profile"
/// /profile/     /profile/:cuid
let profileByIdGet = "/profile/"
/// /profile/avatar
let avatarUpdate = "/profile/avatar"
/// /profile/tags
let tagsGet = "/profile/tags"

// Searching
/// /search/profile
let searchProfile = "/search/profile"
/// /search/local
let searchLocals = "/search/local"

// Notifications
/// /notification/      /notification/:cuid
let notiDelete = "/notification/"
/// /notification
let notiList = "/notification"
/// /notification/redeem/     /notification/redeem/:cuid
let notiRedeem = "/notification/redeem/"
/// /notification/register
let notiRegister = "/notification/register"
/// /notification/unregister
let notiUnregister = "/notification/unregister"

