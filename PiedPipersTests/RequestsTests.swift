//
//  RequestsTests.swift
//  PiedPipersTests
//
//  Created by david rogel pernas on 01/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import XCTest
@testable import PiedPipers

class RequestsTests: XCTestCase
{
    let timeout: TimeInterval = 15000.0
    
    let email = "otroCorreo2@correo.com"
    let pass = "vouteEsnaquizar"
    
    let profileToEncode = Profile(cuid: "CUID", name: "name", location: Location(lat: 20.0, long: 20.0), contact: Contact(type: .email, data: "Correo.a.encodear@correo.com"), instruments: ["bateria", "guitarra", "voz"], videos: ["video1", "video2"], description: "una descripción rexulona", photo: "una foto")
    
    let profileData = """
    {
        "cuid": "ck2g2765h0000q64g4y8tfk0a",
        "name": "Test user 123",
        "location": {
            "lat": 40.34,
            "long": 0.5
        },
        "contact": {
            "type": "phone",
            "data": "test_user@gmail.com"
        },
        "instruments": [
            "bateria"
        ],
        "videos": [
            "https://www.youtube.com/watch?v=41DH065Lfeo&list=RD41DH065Lfeo&start_radio=1"
        ],
        "description": "Lorem ipsum dolor ...",
        "photo": "/Users/albertogarcia-munoz/Documents/Repositories/ProyectoFinal/PiedPipers/public/img/ck2g2765h0000q64g4y8tfk0a.png"
    }
    """
    
    var user: User?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - REMOTE REPOSITORY TESTING
    
    func testGetRemoteUser()
    {
        let e = expectation(description: "GetUserRemote")
        
        Repository.remote.getProfile(currenUserCUID: "ck2g3ps39000c93pcfox7e8jn", success: { (profile) in
            print("Se ha obtenido un user")
            e.fulfill()
        }) { (error) in
            print("ha habido un error")
            XCTFail()
            e.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // MARK: - NETWORK TESTING
    
    // MARK: CREATE USER
    func testCreateUserOnServer()
    {
        let e = expectation(description: "CreateUser")

        let createUserRequest = CreateUserRequest(email: email, password: pass)
            
        createUserRequest.makeRequest { (result) in
            
            switch result
            {
            case .success(let userData):
                print("User Data: email -> \(userData.email), cuid: \(userData.id)")
            case .failure(let err):
                print("Error:", CodeError(rawValue: err.statusCode).debugDescription)
                XCTFail()
            }
            e.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // MARK: LOGIN WITH USER
    func testUserLoginOnServer()
    {
        let e = expectation(description: "LoginUser")
        
        let loginUserRequest = LoginUserRequest(email: email, password: pass)
        
        loginUserRequest.makeRequest { [weak self](result) in
            switch result
            {
            case .success(let data):
                print("Data:", data)
                self?.user = data
            case .failure(let err):
                print("Error:", CodeError(rawValue: err.statusCode).debugDescription)
                XCTFail()
            }
            e.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // MARK: GET CURRENT USER PROFILE
    func testGetCurrentUserProfileOnServer()
    {
        let e = expectation(description: "GetUser")
        
//        if let id = user?.id
//        {
            let getUserProfileRequest = GetProfileRequest(currentUserCuid: "ck2g3ps39000c93pcfox7e8jn")
            
            getUserProfileRequest.makeRequest { (result) in
                switch result
                {
                case .success(let data):
                    print("CurrentUserProfile:", data)
                case .failure(let err):
                    print("Error:", CodeError(rawValue: err.statusCode).debugDescription)
                    XCTFail()
                }
                e.fulfill()
            }
//        }
//        else
//        {
//            e.fulfill()
//            XCTFail()
//        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // MARK: GET USER BY ID
    
    func testGetUserByIdOnServer()
    {
        let e = expectation(description: "GetUserById")
        
        let getUserProfileByIdRequest = GetProfileByIdRequest(currentUserCuid: "ck2g3ps39000c93pcfox7e8jn", findUserCuid: "ck2g3ps39000c93pcfox7e8jn")
        
        getUserProfileByIdRequest.makeRequest { (result) in
            switch result
            {
            case .success(let data):
                print("UserProfileById:", data)
            case .failure(let err):
                print("Error:", CodeError(rawValue: err.statusCode).debugDescription)
                XCTFail()
            }
            e.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // MARK: UPDATE CURRENT USER PROFILE
    
    func testUpdateCurrentUserProfile()
    {
        let e = expectation(description: "UpdateUserProfile")
        
        let cuid = "ck2g3ps39000c93pcfox7e8jn"
        
        let updateUserProfileRequest = UpdateProfileRequest(currentUserCuid: cuid, profile: Profile(cuid: cuid, name: "Not tiene gracia", location: Location(lat: 20.19, long: 20.20), description: "Chistes para todos!!!"))
        
        updateUserProfileRequest.makeRequest { (result) in
            switch result
            {
            case .success(let data):
                print("UserProfileById:", data)
            case .failure(let err):
                print("Error:", CodeError(rawValue: err.statusCode).debugDescription)
                XCTFail()
            }
            e.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // MARK: - DECODE ENCODE PROFILE
    
    func testProfileToJsonAndViceversa()
    {
        let data = try? JSONSerialization.data(withJSONObject: Profile(cuid: "ck2g3ps39000c93pcfox7e8jn", name: "Not tiene gracia", location: Location(lat: 666.000, long: 999.000), description: "Chistes para todos!!!").toBody(), options: [])
//        if JSONSerialization.isValidJSONObject(data)
        let decoder = JSONDecoder()
        let n_profile = try? decoder.decode(Profile.self, from: data!)
        XCTAssertNotNil(n_profile)
    }
    
    func testDecodeProfile()
    {
        do
        {
            let jsonData = profileData.data(using: .utf8)
            let decoder = JSONDecoder()
            let profile = try decoder.decode(Profile.self, from: jsonData!)
            XCTAssertNotNil(profile)
        }
        catch
        {
            XCTFail()
        }
    }
    
    func testEncodeProfile()
    {
        do
        {
            let encoder = JSONEncoder()
            let profile = try encoder.encode(profileToEncode)
            XCTAssertNotNil(profile)
        }
        catch
        {
            XCTFail()
        }
    }
}
