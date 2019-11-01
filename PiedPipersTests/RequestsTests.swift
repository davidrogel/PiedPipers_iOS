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
    let timeout:TimeInterval = 10000.0
    
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
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateUserOnServer()
    {
        let e = expectation(description: "Alamofire")

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
    
    func testUserLoginOnServer()
    {
        let e = expectation(description: "Alamofire")
        
        let loginUserRequest = LoginUserRequest(email: email, password: pass)
        
        loginUserRequest.makeRequest { (result) in
            switch result
            {
            case .success(let data):
                print("Data:", data)
            case .failure(let err):
                print("Error:", CodeError(rawValue: err.statusCode).debugDescription)
                XCTFail()
            }
            e.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    
    // DECODE ENCODE PROFILE
    
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
