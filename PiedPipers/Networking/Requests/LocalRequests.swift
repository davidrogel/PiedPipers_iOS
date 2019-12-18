//
//  LocalRequests.swift
//  PiedPipers
//
//  Created by david rogel pernas on 18/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

struct GetLocalByIdRequest: APIRequest
{
    typealias Response = Local
    
    var method: Methods { return .GET }
    
    var baseUrl: String { return urlToServer }
    
    var path: Self._Endpoint { return (.getLocal + localCuid) }
    
    let localCuid: String
}
