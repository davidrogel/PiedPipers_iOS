//
//  APIError.swift
//  AppRequestTest
//
//  Created by david rogel pernas on 21/06/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

class APIErrorResponse: Error
{
    var url: String
    var statusCode: Int
    var data: Data?
    var message: String
    
    init(_ status: Int, _ message: String, _ url: String, data: Data? = nil)
    {
        self.statusCode = status
        self.message = message
        self.url = url
        self.data = data
    }
}

//struct APIError : Error
//{
//    let code: Int
//    let ecode: Int
//    let message: String
//    
//    init(_ code: Int, _ ecode: Int, _ message: String)
//    {
//        self.code = code
//        self.ecode = ecode
//        self.message = message
//    }
//}
//
//extension APIError
//{
//    
//}

// factory - TODO
extension APIErrorResponse
{
    static func network(_ url: String) -> APIErrorResponse
    {
        return APIErrorResponse(-1, "Network connection error", url)
    }
    
    static func parseData(_ url: String) -> APIErrorResponse
    {
        return APIErrorResponse(-2, "Parse data error", url)
    }
    
    static func unknown(_ url: String) -> APIErrorResponse
    {
        return APIErrorResponse(-3, "Unknown error", url)
    }
}

extension APIErrorResponse: Equatable
{
    static func == (lhs: APIErrorResponse, rhs: APIErrorResponse) -> Bool
    {
        return lhs.statusCode == rhs.statusCode
    }
}
