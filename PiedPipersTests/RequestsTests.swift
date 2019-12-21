//
//  RequestsTests.swift
//  PiedPipersTests
//
//  Created by david rogel pernas on 01/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import XCTest
import UIKit
import Alamofire
@testable import PiedPipers

class RequestsTests: XCTestCase
{
    let timeout: TimeInterval = 150000000.0
    
    let email = "otroCorreo2@correo.com"
    let pass = "vouteEsnaquizar"
    let cuid = "ck2g3ps39000c93pcfox7e8jn"
    
    let notisEmail = "alb.garciam@gmail.com"
    let notisPass = "1234567"
    let notisUserCUID = "ck40dve7l00013epcdiq9gmju"
    
    let localCUID = "ck3yxb4qp0009xapc2nypd6xo"
    
    let profileToEncode = Profile(cuid: "CUID", name: "name", location: Location(lat: 20.0, long: 20.0), contact: Contact(type: .email, data: "Correo.a.encodear@correo.com"), instruments: ["bateria", "guitarra", "voz"], videos: nil, description: "una descripción rexulona", photo: "una foto")
    
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
            { "id": "idLocoDeYT" }
        ],
        "description": "Lorem ipsum dolor ...",
        "photo": "/Users/albertogarcia-munoz/Documents/Repositories/ProyectoFinal/PiedPipers/public/img/ck2g2765h0000q64g4y8tfk0a.png"
    }
    """
    
    let localData = """
    {
        "cuid": "ck2rib3ih0000jl4g67j1c675",
        "dateAdded": "2019-11-09T11:49:44.222Z",
        "name": "Sala mandra!",
        "location": {
            "lat": 40.33,
            "long": 0.5
        },
        "price": 20,
        "contact": {
            "type": "phone",
            "data": "+34671646356"
        },
        "photos": [],
        "description": "Lorem ipsum dolor ..."
    }
    """
    
    let localList = """
        {
            "total": 2,
            "offset": 10,
            "items": [
                {
                    "cuid": "ck2rib3ih0000jl4g67j1c675",
                    "dateAdded": "2019-11-09T11:49:44.222Z",
                    "name": "Sala mandra!",
                    "location": {
                        "lat": 40.33,
                        "long": 0.5
                    },
                    "price": 20,
                    "contact": {
                        "type": "phone",
                        "data": "+34671646356"
                    },
                    "photos": [],
                    "description": "Lorem ipsum dolor ..."
                },
                {
                    "cuid": "ck2rib3ih0000jl4g67j1c675",
                    "dateAdded": "2019-11-09T11:49:44.222Z",
                    "name": "Sala mandra!",
                    "location": {
                        "lat": 40.33,
                        "long": 0.5
                    },
                    "price": 20,
                    "contact": {
                        "type": "phone",
                        "data": "+34671646356"
                    },
                    "photos": [],
                    "description": "Lorem ipsum dolor ..."
                }
            ]
        }
    """
    
    let profileList = """
        {
            "total": 2,
            "offset": 1,
            "items": [
                {
                    "cuid": "ck2kpq6490000e24g49j90wuq",
                    "name": "Test user 123",
                    "location": {
                        "lat": 40.34,
                        "long": 0.5
                    },
                    "friendlyLocation": "Vienna",
                    "contact": {
                        "type": "email",
                        "data": "test_user@gmail.com"
                    },
                    "instruments": [
                        "bateria"
                    ],
                    "videos": [
                        {
                            "id": "idrarodeYT",
                            "video": "https://www.youtube.com/watch?v=41DH065Lfeo&list=RD41DH065Lfeo&start_radio=1",
                            "embedVideo": "",
                            "thumbnail": "thumb.jpg"
                        }
                    ],
                    "description": "Lorem ipsum dolor ..."
                },
                {
                    "cuid": "ck2kpq6490000e24g49j90wuq",
                    "name": "Test user 123",
                    "location": {
                        "lat": 40.34,
                        "long": 0.5
                    },
                    "friendlyLocation": "Vienna",
                    "contact": {
                        "type": "email",
                        "data": "test_user@gmail.com"
                    },
                    "instruments": [
                        "bateria"
                    ],
                    "videos": [
                        { "id":"idloco" },
                        { "id":"idloco" }
                    ],
                    "description": "Lorem ipsum dolor ..."
                }
            ]
        }
    """
    
    let instruments = """
        {
            "total": 8,
            "offset": 0,
            "items": [
                "guitarra",
                "bateria",
                "bajo",
                "contrabajo",
                "violín",
                "pandero",
                "castañuelas",
                "zambomba"
            ]
        }
    """
    
    let notificationData = """
        {
            "cuid": "ck406fpu200003epcdszo3iil",
            "notificationType": "follow",
            "data": {
                "image": "",
                "origin": "ck2w7u2el00010cpc5d0i1lnm",
                "originName": "Eric Sans",
                "destination": "ck40dve7l00013epcdiq9gmju",
                "destinationName": "Alberto García"
            },
            "destination": "ck40dve7l00013epcdiq9gmju",
            "dateAdded": "2019-12-10T22:10:56.109Z",
            "state": "pending"
        }
    """
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
        
        let loginUserRequest = LoginUserRequest(email: notisEmail, password: notisPass)
        
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
    
    // MARK: GET CURRENT USER PROFILE
    func testGetCurrentUserProfileOnServer()
    {
        let e = expectation(description: "GetUser")
        
        let getUserProfileRequest = GetProfileRequest(currentUserCuid: notisUserCUID)
        
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
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // MARK: GET USER BY ID
    
    func testGetUserByIdOnServer()
    {
        let e = expectation(description: "GetUserById")
        
        let getUserProfileByIdRequest = GetProfileByIdRequest(currentUserCuid: cuid, findUserCuid: cuid)
        
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
        
        let updateUserProfileRequest = UpdateProfileRequest(currentUserCuid: cuid, profile: Profile(cuid: cuid, name: "Not tiene gracia",location: Location(lat: 20.19, long: 20.20), videos: [Video(id: "idLocoDeYoutube"), Video(id: "idLocoDeYoutube123")], description: "Chistes para todos!!!"))
        
        updateUserProfileRequest.makeRequest { (result) in
            switch result
            {
            case .success(let data):
                print("Updated Profile:", data)
            case .failure(let err):
                print("Error:", CodeError(rawValue: err.statusCode).debugDescription)
                XCTFail()
            }
            e.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // MARK: GET INSTRUMENTS
    
    func testGetInstrumentsList()
    {
        let e = expectation(description: "GetInstrumentsList")
        
        let getInstrumentsRequest = GetInstrumentsRequest(currentUserCuid: cuid)
        
        getInstrumentsRequest.makeRequest { (result) in
            switch result
            {
            case .success(let data):
                print("Instruments:", data)
            case .failure(let err):
                print("Error:", CodeError(rawValue: err.statusCode).debugDescription)
                XCTFail()
            }
            e.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // MARK: SEARCHING PROFILE & LOCAL
    
    func testSearchLocals()
    {
        let e = expectation(description: "SearchLocals")
        
        let getLocalsBySearchingRequest = GetLocalBySearchingRequest(cuid: cuid, limit: 10, offset: 0)
        
        getLocalsBySearchingRequest.makeRequest { (result) in
            switch result
            {
            case .success(let data):
                print("Locals?:", data)
            case .failure(let err):
                print("Error:", CodeError(rawValue: err.statusCode).debugDescription)
                XCTFail()
            }
            e.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testSearchProfiles()
    {
        let e = expectation(description: "SearchProfiles")

        let parameters: SearchProfileParameters = SearchProfileParameters(name: "Gabi"/*, instruments: ["zambomba"]*/, friendlyLocation: "Kabul")
        
        let getProfilesBySearchingRequest = GetProfileBySearchingRequest(cuid: cuid, profileParameters: parameters, limit: 10, offset: 0)

        getProfilesBySearchingRequest.makeRequest { (result) in
           switch result
           {
           case .success(let data):
               print("Profiles?:", data)
           case .failure(let err):
               print("Error:", CodeError(rawValue: err.statusCode).debugDescription)
               XCTFail()
           }
           e.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // MARK: UPDATE AVATAR
    
    func testUpdateProfileAvatar()
    {
        let e = expectation(description: "UpdateAvatar")

        let img = UIImage(named: "mads")
        
        let resizedImage = img?.resize(size: CGSize(width: 300, height: 300))
        let data = resizedImage?.jpegData(compressionQuality: 1)
        
        guard let imgData = data else
        {
            XCTFail()
            return
        }
        
        let updateCurrentUserAvatar = UpdateProfileAvatarRequest(currentUserCuid: cuid, imgData: imgData)

        updateCurrentUserAvatar.makeUpload { (result) in
            switch result
            {
            case .success(let data):
                print("Profile with updated profile:", data)
            case .failure(let err):
                print("Error:", err)
//                print("Error:", CodeError(rawValue: err.statusCode).debugDescription)
                XCTFail()
            }
            e.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // MARK: FOLLOW
    
    // Falla si ya sigues a la persona, habrá que controlarlo
    func testFollowOtherUser()
    {
        let e = expectation(description: "FollowProfile")
               
        let getProfilesBySearchingRequest = GetProfileBySearchingRequest(cuid: cuid, limit: 10, offset: 0)

        getProfilesBySearchingRequest.makeRequest { (result) in
           switch result
           {
           case .success(let data):
               print("Profiles?:", data)
           case .failure(let err):
               print("Error:", CodeError(rawValue: err.statusCode).debugDescription)
               XCTFail()
           }
           e.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // MARK: UNFOLLOW
    
    // Falla si NO sigues a la persona, habrá que controlarlo
    func testUnfollowOtherUser()
    {
        let e = expectation(description: "UnfollowProfile")
               
        let unfollowOtherUserRequest = UnfollowOtherUserRequest(currentUserCuid: cuid,unfollowUserCuid: "ck2avtjvi0000ajpcb5q44wg")

        unfollowOtherUserRequest.makeRequest { (result) in
           switch result
           {
           case .success(let data):
                print("User to follow?:", data)
           case .failure(let err):
                print("Error:", err.message)
                print("Puede que aun no te hayan aceptado...")
                XCTFail()
           }
           e.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // MARK: GET MY BAND
    
    func testGetProfileBand()
    {
        let e = expectation(description: "GetBand")
               
        let getCurrentProfileBand = GetCurrentProfileBand(currentUserCuid: notisUserCUID)
            
        getCurrentProfileBand.makeRequest { (result) in
           switch result
           {
           case .success(let data):
                print("Band:", data)
           case .failure(let err):
                print("Error:", err.message)
                XCTFail()
           }
           e.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // MARK: NOTIFICATIONS
    
    func testListNotifications()
    {
        let e = expectation(description: "ListNotifications")
               
        let getListNotificationsRequest = ListNotificationsRequest(currentUserCuid: cuid, limit: 10, offset: 0)

        getListNotificationsRequest.makeRequest { (result) in
           switch result
           {
           case .success(let data):
                print("Notis:", data)
           case .failure(let err):
                print("Error:", err.message)
                XCTFail()
           }
           e.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // MARK: LOCALS
    // Estas Requests en un principio no requieren de Token de Autorización
    
    func testGetLocalById()
    {
        let e = expectation(description: "GetLocalById")
               
        let getLocalByIdRequest = GetLocalByIdRequest(localCuid: localCUID)
        
        getLocalByIdRequest.makeRequest { (result) in
           switch result
           {
           case .success(let data):
                print("Local:", data)
           case .failure(let err):
                print("Error:", err.message)
                XCTFail()
           }
           e.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // MARK: - ENCODE DECODE
    
    // MARK: PROFILE
    func testProfileToJsonAndViceversa()
    {
        let data = try? JSONSerialization.data(withJSONObject: Profile(cuid: cuid, name: "Not tiene gracia", location: Location(lat: 10.00, long: 20.00), description: "Chistes para todos!!!").toBody(), options: [])
        // Este test falla ya que el toBody() no guarda el CUID y en el Profile es obligatorio, por ahora no se usa esta logica pero es un PROBLEMA a tener en cuenta cuando se dé
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
    
    // MARK: INSTRUMENTS
    
    func testDecodeInstruments()
    {
        do
        {
            let jsonData = instruments.data(using: .utf8)
            let decoder = JSONDecoder()
            let instruments = try decoder.decode(AvailableInstruments.self, from: jsonData!)
            XCTAssertNotNil(instruments)
        }
        catch
        {
            XCTFail()
        }
    }
    
    func testEncodeInstruments()
    {
        do
        {
            let encoder = JSONEncoder()
            let _instruments = try encoder.encode(instruments)
            XCTAssertNotNil(_instruments)
        }
        catch
        {
            XCTFail()
        }
    }
    
    // MARK: LOCAL
    
    func testDecodeLocal()
    {
        do
        {
            let jsonData = localData.data(using: .utf8)
            let decoder = JSONDecoder()
            let local = try decoder.decode(Local.self, from: jsonData!)
            XCTAssertNotNil(local)
        }
        catch
        {
            XCTFail()
        }
    }
    
    func testEncodeLocal()
    {
        do
        {
            let encoder = JSONEncoder()
            let local = try encoder.encode(localData)
            XCTAssertNotNil(local)
        }
        catch
        {
            XCTFail()
        }
    }
    
    // MARK: LISTS
    
    func testDecodeLocalList()
    {
        do
        {
            let jsonData = localList.data(using: .utf8)
            let decoder = JSONDecoder()
            let localList = try decoder.decode(LocalList.self, from: jsonData!)
            XCTAssertNotNil(localList)
        }
        catch
        {
            XCTFail()
        }
    }
    
    func testEncodeLocalList()
    {
        do
        {
            let encoder = JSONEncoder()
            let _localList = try encoder.encode(localList)
            XCTAssertNotNil(_localList)
        }
        catch
        {
            XCTFail()
        }
    }
    
    func testDecodeProfileList()
    {
        do
        {
            let jsonData = profileList.data(using: .utf8)
            let decoder = JSONDecoder()
            let profileList = try decoder.decode(ProfileList.self, from: jsonData!)
            XCTAssertNotNil(profileList)
        }
        catch
        {
            XCTFail()
        }
    }
    
    func testEncodeProfileList()
    {
        do
        {
            let encoder = JSONEncoder()
            let _profileList = try encoder.encode(profileList)
            XCTAssertNotNil(_profileList)
        }
        catch
        {
            XCTFail()
        }
    }
    
    // MARK: NOTIFICATIONS
    
    func testDecodeNotification()
    {
        do
        {
            let jsonData = notificationData.data(using: .utf8)
            let decoder = JSONDecoder()
            let notification = try decoder.decode(Noti.self, from: jsonData!)
            XCTAssertNotNil(notification)
        }
        catch
        {
            XCTFail()
        }
    }
    
    func testEncodeNotification()
    {
        do
        {
            let encoder = JSONEncoder()
            let noti = try encoder.encode(notificationData)
            XCTAssertNotNil(noti)
        }
        catch
        {
            XCTFail()
        }
    }
    
    // MARK: - DATES FORMATTEX
    
    func testServerStringToDate()
    {
        // "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let _date = Date.date(from: "2019-02-11T10:11:40.000Z")
        guard let date = _date else { XCTFail(); return }
        print("FECHA:", date)
    }
}
