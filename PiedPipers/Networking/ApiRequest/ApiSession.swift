//
//  ApiSession.swift
//  AppRequestTest
//
//  Created by david rogel pernas on 21/06/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Alamofire

struct APISession
{
    static func request<Request: APIRequest>(_ request: Request, _ completion: Request.APIRequestCompletion?)
    {
        let urlString = request.baseUrl + request.path
        
        if let networkManager = NetworkReachabilityManager(), !networkManager.isReachable
        {
            return completion?(.failure(.network(urlString))) ?? ()
        }
        
        let req = request.getRequest()
        
        Alamofire.request(req).responseData { (response) in
            DispatchQueue.main.async {
                guard let statusCode = response.response?.statusCode else
                {
                    return completion?(.failure(.unknown(urlString))) ?? ()
                }
                
                switch statusCode
                {
                case 200..<300:
                    guard let data = response.data else
                    {
                        return completion?(.failure(.unknown(urlString))) ?? ()
                    }
                    
                    if Request.Response.self == Data.self,
                        let data = data as? Request.Response
                    {
                        return completion?(.success(data)) ?? ()
                    }
                    
                    guard let model = try? JSONDecoder().decode(Request.Response.self, from: data) else
                    {
                        return completion?(.failure(.parseData(urlString))) ?? ()
                    }
                    
                    return completion?(.success(model)) ?? ()
                    
                default:
                    let error = APIErrorResponse(statusCode, "Service Error", urlString, data: response.data)
                    return completion?(.failure(error)) ?? ()
                }
            }
        }
    }
}
