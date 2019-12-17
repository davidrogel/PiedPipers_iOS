//
//  NotificationRequests.swift
//  PiedPipers
//
//  Created by david rogel pernas on 16/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

struct DeleteNotificationRequest: APIRequest
{
    typealias Response = Int
    
    var method: Methods { return .DELETE }
    
    var baseUrl: String { return urlToServer }
    
    var path: Self.Endpoint { return (notiDelete + notiCuidToDelete) }
    
    var headers: [String : String] {
        let authToken = StoreManager.shared.getString(withKey: currentUserCuid)
        return ["Authorization":authToken]
    }
    
    let currentUserCuid: String
    let notiCuidToDelete: String
}

struct ListNotificationsRequest: APIRequest
{
    typealias Response = NotiList
    
    var method: Methods { return .GET }
    
    var baseUrl: String { return urlToServer }
    
    var path: Self.Endpoint { return notiList }
    
    var headers: [String : String] {
        let authToken = StoreManager.shared.getString(withKey: currentUserCuid)
        return ["Authorization":authToken]
    }
    
    var parameters: [String : String] {
        return generateParams()
    }
    
    let currentUserCuid: String
    
    let limit:Int
    let offset:Int
}

extension ListNotificationsRequest
{
    private func generateParams() -> [String:String]
    {
        var params = [String:String]()
        
        params["limit"] = limit.description
        params["offset"] = offset.description
        
        return params
    }
}

struct RedeemNotificationRequest: APIRequest
{
    typealias Response = Noti
    
    var method: Methods { return .GET }
    
    var baseUrl: String { return urlToServer }
    
    var path: Self.Endpoint { return (notiRedeem + notificationCuid) }
    
    var headers: [String : String] {
        let authToken = StoreManager.shared.getString(withKey: currentUserCuid)
        return ["Authorization":authToken]
    }
    
    let currentUserCuid: String
    let notificationCuid: String
}
