//
//  Repository.swift
//  PiedPipers
//
//  Created by david rogel pernas on 06/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation


final class Repository
{
    static let fake: RepositoryFactory = FakeRepository()
    static let remote: RepositoryFactory = RemoteRepository()
}

protocol RepositoryFactory: class
{
    func getProfile(currenUserCUID cuid: String, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    func getProfile(currentUserCUID cuid: String, userPickedCUID otherCuid: String, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    func updateProfile(currentUserCUID cuid: String, newProfile profile: Profile, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
}

final class FakeRepository: RepositoryFactory
{
    private let userProfile = Profile(cuid: "", name: "name", location: Location(lat: 20.0, long: 20.0), contact: Contact(type: .email, data: "Correo.a.encodear@correo.com"), instruments: ["bateria", "guitarra", "voz"], videos: ["video1", "video2"], description: "una descripción rexulona", photo: "una foto")

    private let otherProfile = Profile(cuid: "", name: "name", location: Location(lat: 20.0, long: 20.0), contact: Contact(type: .email, data: "Correo.a.encodear@correo.com"), instruments: ["bateria", "guitarra", "voz"], videos: ["video1", "video2"], description: "una descripción rexulona", photo: "una foto")

    func getProfile(currenUserCUID cuid: String, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    {
        success(userProfile)
    }

    func getProfile(currentUserCUID cuid: String, userPickedCUID otherCuid: String, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    {
        success(otherProfile)
    }

    func updateProfile(currentUserCUID cuid: String, newProfile profile: Profile, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    {
        success(userProfile)
    }
}

final class RemoteRepository: RepositoryFactory
{
    public static let shared: RemoteRepository = RemoteRepository()

    func getProfile(currenUserCUID cuid: String, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    {
        let getUserProfileRequest = GetProfileRequest(currentUserCuid: cuid)

        getUserProfileRequest.makeRequest { (result) in
            switch result
            {
            case .success(let data):
                success(data)
            case .failure(let err):
                failure(err)
                assertionFailure("Se han cometido errores")
            }
        }
    }

    func getProfile(currentUserCUID cuid: String, userPickedCUID otherCuid: String, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    {
        let getOtherUserProfile = GetProfileByIdRequest(currentUserCuid: cuid, findUserCuid: otherCuid)

        getOtherUserProfile.makeRequest { (result) in
            switch result
            {
            case .success(let data):
                success(data)
            case .failure(let err):
                failure(err)
                assertionFailure("Se han cometido errores")
            }
        }
    }

    func updateProfile(currentUserCUID cuid: String, newProfile profile: Profile, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    {
        let updateCurrentUserProfile = UpdateProfileRequest(currentUserCuid: cuid, profile: profile)

        updateCurrentUserProfile.makeRequest { (result) in
            switch result
            {
            case .success(let data):
                success(data)
            case .failure(let err):
                failure(err)
                assertionFailure("Se han cometido errores")
            }
        }
    }
}
