//
//  APIErrorCodes.swift
//  PiedPipers
//
//  Created by david rogel pernas on 31/10/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

// HTTP CODE ERROR
enum CodeError: Int
{
    case CODE_AUTHORIZATION_ERROR = 403
    case CODE_LOGIC_ERROR = 404
    case CODE_VALIDATION_ERROR = 422
    case CODE_SERVER_ERROR = 500
}

// ECODE ERRORS
enum ECodeError: Int
{
    case ECODE_DATABASE_ERROR = 1000
    case ECODE_ITEM_NOT_FOUND = 1001
    case ECODE_INVALID_PASSWORD = 1002
    case ECODE_INVALID_TOKEN = 1003
    case ECODE_UNKNOWN_ERROR = 1004
    case ECODE_DUPLICATED_ITEM = 1005
    case ECODE_LOGIN_REQUIRED = 1006
    case ECODE_VALIDATION_ERROR = 1007
}
