//
//  ApiSession.swift
//  AppRequestTest
//
//  Created by david rogel pernas on 21/06/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Alamofire
import KeychainSwift

struct APISession
{
    static func upload<Request: APIRequest>(_ request: Request, _ completion: Request.APIRequestCompletion?)
    {
        let urlString = request.baseUrl + request.path

        if let networkManager = NetworkReachabilityManager(), !networkManager.isReachable
        {
            return completion?(.failure(.network(urlString))) ?? ()
        }
        
        let req = request.getRequest()
        
        AF.upload(multipartFormData: {
            (multipartFormData) in
                request.data.forEach {
                    multipartFormData.append($0.value, withName: $0.key, fileName: "filename.jpeg", mimeType: "image/jpeg")
                }
        }, with: req).responseData { (response) in
            DispatchQueue.main.async {
                // ALERTA: CODIGO DUPLICADO
                guard let statusCode = response.response?.statusCode else
                {
                    return completion?(.failure(.unknown(urlString))) ?? ()
                }
                
                guard let headers = response.response?.allHeaderFields else
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
                    
                    if Request.Response.self == Data.self, let data = data as? Request.Response
                    {
                        return completion?(.success(data)) ?? ()
                    }
                    
                    guard let model = try? JSONDecoder().decode(Request.Response.self, from: data) else
                    {
                        return completion?(.failure(.parseData(urlString))) ?? ()
                    }
                    
                    if Request.Response.self == User.self, let userModel = model as? User
                    {
                        let header = headers.filter { $0.key == "Authorization" }
                        
                        if header.capacity > 0, let value = header.first?.value as? String
                        {
                            StoreManager.shared.save(dataOnKeyChain: value, withKey: userModel.id)
                            
                            // TODO: Guardar en el StoreManager la info
                            print("save authorization: \(value) with user cuid\(userModel.id)")
                        }
                    }
                    
                    return completion?(.success(model)) ?? ()
                case 403:
                    let error = APIErrorResponse(statusCode, " ", urlString, data: response.data)
                    return completion?(.failure(error)) ?? ()
                case 413:
                    let error = APIErrorResponse(statusCode, "Imagen demasiado grande", urlString, data: response.data)
                    return completion?(.failure(error)) ?? ()
                default:
                    let error = APIErrorResponse(statusCode, "Service Error", urlString, data: response.data)
                    return completion?(.failure(error)) ?? ()
                }
            }
        }
    }
    
    static func request<Request: APIRequest>(_ request: Request, _ completion: Request.APIRequestCompletion?)
    {
        let urlString = request.baseUrl + request.path
        
        if let networkManager = NetworkReachabilityManager(), !networkManager.isReachable
        {
            return completion?(.failure(.network(urlString))) ?? ()
        }
        
        let req = request.getRequest()
        
        AF.request(req).responseData { (response) in
            DispatchQueue.main.async {
                // ALERTA: CODIGO DUPLICADO
                guard let statusCode = response.response?.statusCode else
                {
                    return completion?(.failure(.unknown(urlString))) ?? ()
                }
                
                guard let headers = response.response?.allHeaderFields else
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
                    
                    if Request.Response.self == Data.self, let data = data as? Request.Response
                    {
                        return completion?(.success(data)) ?? ()
                    }
                    
                    guard let model = try? JSONDecoder().decode(Request.Response.self, from: data) else
                    {
                        return completion?(.failure(.parseData(urlString))) ?? ()
                    }
                    
                    if Request.Response.self == User.self, let userModel = model as? User
                    {
                        let header = headers.filter { $0.key == "Authorization" }
                        
                        if header.capacity > 0, let value = header.first?.value as? String
                        {
                            StoreManager.shared.save(dataOnKeyChain: value, withKey: userModel.id)
                            
                            // TODO: Guardar en el StoreManager la info
                            print("save authorization: \(value) with user cuid\(userModel.id)")
                        }
                    }
                    
                    return completion?(.success(model)) ?? ()
                case 403:
                    let error = APIErrorResponse(statusCode, " ", urlString, data: response.data)
                    return completion?(.failure(error)) ?? ()
                default:
                    let error = APIErrorResponse(statusCode, "Service Error", urlString, data: response.data)
                    return completion?(.failure(error)) ?? ()
                }
            }
        }
    }
}
