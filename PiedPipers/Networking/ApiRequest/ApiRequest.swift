//
//  ApiRequest.swift
//  AppRequestTest
//
//  Created by david rogel pernas on 21/06/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

enum Methods: String, Codable
{
    case GET, POST
}

protocol APIRequest
{
    associatedtype Response: Codable // The way to add a generic into a protocol
    
    typealias APIRequestResponse = Result<Response, APIErrorResponse>
    typealias APIRequestCompletion = (APIRequestResponse) -> ()
    
    var method: Methods { get }
    var body: Any { get }
    var baseUrl: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var parameters: [String: String] { get }
}

extension APIRequest
{
    var parameters: [String: String] { return [:] }
    var body: Any { return [:] }
    var headers: [String: String] { return [:] }
    
    func makeRequest(_ completion: APIRequestCompletion?)
    {
        APISession.request(self, completion)
    }
    
    func getRequest() -> URLRequest
    {
        guard var url = URL(string: baseUrl) else
        {
            fatalError("Imposible to form base URL \(baseUrl)")
        }
        
        url.appendPathComponent(path)
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else
        {
            fatalError("Imposible to create URLComponent from \(url)")
        }
        
        if !parameters.isEmpty
        {
            components.queryItems = parameters.map{ URLQueryItem(name: $0, value: $1)}
        }
        
        guard let finalUrl = components.url else
        {
            fatalError("Unable to retrieve final URL")
        }
        
        var request = URLRequest(url: finalUrl)
        request.httpMethod = method.rawValue
        
        if method != Methods.GET
        {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        request.allHTTPHeaderFields = headers
        
        return request
    }
}
