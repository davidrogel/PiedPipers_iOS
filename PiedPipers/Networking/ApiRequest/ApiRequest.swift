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
    case GET, POST, PATCH, DELETE
}

let urlToServer = "http://ec2-52-87-34-66.compute-1.amazonaws.com"

protocol APIRequest
{
    associatedtype Response: Codable // The way to add a generic into a protocol
    
    typealias APIRequestResponse = Result<Response, APIErrorResponse>
    typealias APIRequestCompletion = (APIRequestResponse) -> ()
    typealias _Endpoint = EndPoint
    
    var method: Methods { get }
    var baseUrl: String { get }
    var path: _Endpoint { get }
    
    var body: Any { get }
    var headers: [String: String] { get }
    var parameters: [String: String] { get }
    // Información pesada a enviar
    var data: [String: Data] { get }
}

extension APIRequest
{
    var body: Any { return [:] }
    var headers: [String: String] { return [:] }
    var parameters: [String: String] { return [:] }
    // Información pesada a enviar
    var data: [String: Data] { return [:] }
}

extension APIRequest
{
    func makeUpload(_ completion: APIRequestCompletion?)
    {
        APISession.upload(self, completion)
    }
    
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
        
        url.appendPathComponent(path.rawValue)
        
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

        if method != Methods.GET && JSONSerialization.isValidJSONObject(body)
        {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        request.allHTTPHeaderFields = headers
        
        return request
    }
}
