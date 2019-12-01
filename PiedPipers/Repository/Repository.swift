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
    // USER REQUESTS
    /// Crea un usuario
    func createUser(withEmail email: String, withPassword pass: String, success: @escaping (User?) -> Void, failure: @escaping (Error?) -> Void)
    /// Loggin con un usuario creado
    func loginUser(withEmail email: String, withPassword pass: String, success: @escaping (User?) -> Void, failure: @escaping (Error?) -> Void)
    /// Actualizar usuario
    func updateUser(currentUserCUID cuid: String, newPassword pass: String, success: @escaping (User?) -> Void, failure: @escaping (Error?) -> Void)
    /// Borra un usuario
    func deleteUser(currentUserCUID cuid: String, success: @escaping (Int) -> Void, failure: @escaping (Error?) -> Void)
    
    // PROFILE REQUESTS
    /// Obtener tú perfil
    func getProfile(currenUserCUID cuid: String, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    /// Obtener el perfil de otro usuario
    func getProfile(currentUserCUID cuid: String, userPickedCUID otherCuid: String, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    /// Actualizar tú perfil
    func updateProfile(currentUserCUID cuid: String, newProfile profile: Profile, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    /// Obtener los instrumentos que se pueden usar
    func getAvaliableInstruments(currentUserCUID cuid: String, success: @escaping ([String]?) -> Void, failure: @escaping (Error?) -> Void)
    
        // FALTA EL AVATAR DEL PROFILE REQUEST
    
    // SEARCH REQUESTS
    
    func searchProfiles(currentUserCUID cuid: String, withParameters parameters: SearchProfileParameters, limit: Int, offset: Int, success: @escaping (ProfileList?) -> Void, failure: @escaping (Error?) -> Void)
    
    func searchLocals(currentUserCUID cuid: String, withParameters parameters: SearchLocalParameters, limit: Int, offset: Int, success: @escaping (LocalList?) -> Void, failure: @escaping (Error?) -> Void)
}

final class FakeRepository: RepositoryFactory
{
    // Falta añadir videos a los FAKE perfiles
    private let userProfile = Profile(cuid: "", name: "name", location: Location(lat: 20.0, long: 20.0), contact: Contact(type: .email, data: "Correo.a.encodear@correo.com"), instruments: ["bateria", "guitarra", "voz", "Bandurria", "Contrabajo", "Bajo", "Flauta", "Xilofono", "Trompeta", "Triangulo", "Trombon"], videos: nil, description: "una descripción rexulona", photo: "una foto")

    private let otherProfile = Profile(cuid: "", name: "name", location: Location(lat: 20.0, long: 20.0), contact: Contact(type: .email, data: "Correo.a.encodear@correo.com"), instruments: ["bateria", "guitarra", "voz"], videos: nil, description: "una descripción rexulona", photo: "una foto")
    
    private let local = Local(cuid: "", name: "un local", dateAdded: "", location: Location(lat: 10.0, long: 10.0), price: 40.0, contact: Contact(type: .email, data: "arroba@correo.ru"), photos: ["una foto", "dos fotos", "tres... fotos?"], description: "una descripción de un local molón")

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
    
    func searchProfiles(currentUserCUID cuid: String, withParameters parameters: SearchProfileParameters, limit: Int, offset: Int, success: @escaping (ProfileList?) -> Void, failure: @escaping (Error?) -> Void)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            success(ProfileList(total: 3, offset: 3, items: [self.userProfile, self.userProfile, self.userProfile]))
        }
    }
    
    func searchLocals(currentUserCUID cuid: String, withParameters parameters: SearchLocalParameters, limit: Int, offset: Int, success: @escaping (LocalList?) -> Void, failure: @escaping (Error?) -> Void)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            success(LocalList(total: 3, offset: 3, items: [self.local, self.local, self.local]))
            success(LocalList(total: 0, offset: 0, items: []))
        }
    }
    
    func getAvaliableInstruments(currentUserCUID cuid: String, success: @escaping ([String]?) -> Void, failure: @escaping (Error?) -> Void)
    {
        success(["batería", "guitarra", "bajo", "voz"])
    }
    
    // USER
    func createUser(withEmail email: String, withPassword pass: String, success: @escaping (User?) -> Void, failure: @escaping (Error?) -> Void)
    {
        // TODO
    }
    
    func loginUser(withEmail email: String, withPassword pass: String, success: @escaping (User?) -> Void, failure: @escaping (Error?) -> Void)
    {
        // TODO
    }
    
    func updateUser(currentUserCUID cuid: String, newPassword pass: String, success: @escaping (User?) -> Void, failure: @escaping (Error?) -> Void)
    {
        // TODO
    }
    
    func deleteUser(currentUserCUID cuid: String, success: @escaping (Int) -> Void, failure: @escaping (Error?) -> Void)
    {
        // TODO
    }
}

final class RemoteRepository: RepositoryFactory
{
    // USER
    
    func createUser(withEmail email: String, withPassword pass: String, success: @escaping (User?) -> Void, failure: @escaping (Error?) -> Void)
    {
        let createUserRequest = CreateUserRequest(email: email, password: pass)
            
        createUserRequest.makeRequest { (result) in
            switch result
            {
            case .success(let data):
                success(data)
            case .failure(let err):
                failure(err)
            }
        }
    }
    
    func loginUser(withEmail email: String, withPassword pass: String, success: @escaping (User?) -> Void, failure: @escaping (Error?) -> Void)
    {
        let loginUserRequest = LoginUserRequest(email: email, password: pass)
        
        loginUserRequest.makeRequest { (result) in
            switch result
            {
            case .success(let data):
                success(data)
            case .failure(let err):
                failure(err)
            }
        }
    }
    
    func updateUser(currentUserCUID cuid: String, newPassword pass: String, success: @escaping (User?) -> Void, failure: @escaping (Error?) -> Void)
    {
        let updateUserRequest = UpdateUserRequest(currentUserCuid: cuid, password: pass)
        
        updateUserRequest.makeRequest { (result) in
            switch result
            {
            case .success(let data):
                success(data)
            case .failure(let err):
                failure(err)
            }
        }
    }
    
    func deleteUser(currentUserCUID cuid: String, success: @escaping (Int) -> Void, failure: @escaping (Error?) -> Void)
    {
        let deleteUserRequest = DeleteUserRequest(currentUserCuid: cuid)
        
        deleteUserRequest.makeRequest { (result) in
            switch result
            {
            case .success(let data):
                success(data)
            case .failure(let err):
                failure(err)
            }
        }
    }
    
    // PROFILE
    
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
    
    func getAvaliableInstruments(currentUserCUID cuid: String, success: @escaping ([String]?) -> Void, failure: @escaping (Error?) -> Void) {
        let getInstrumentsRequest = GetInstrumentsRequest(currentUserCuid: cuid)
        
        getInstrumentsRequest.makeRequest { (result) in
            switch result
            {
            case .success(let data):
                success(data.first?.value)
            case .failure(let err):
                failure(err)
            }
        }
    }
    
    // SEARCHING
    
    func searchProfiles(currentUserCUID cuid: String, withParameters parameters: SearchProfileParameters, limit: Int, offset: Int, success: @escaping (ProfileList?) -> Void, failure: @escaping (Error?) -> Void)
    {
        let getProfilesBySearchingRequest = GetProfileBySearchingRequest(cuid: cuid,profileParameters: parameters, limit: 10, offset: 10)
        
        getProfilesBySearchingRequest.makeRequest { (result) in
            switch result
            {
            case .success(let data):
                success(data)
            case .failure(let err):
                failure(err)
            }
        }
    }
    
    func searchLocals(currentUserCUID cuid: String, withParameters parameters: SearchLocalParameters, limit: Int, offset: Int, success: @escaping (LocalList?) -> Void, failure: @escaping (Error?) -> Void)
    {
        let getLocalsBySearchingRequest = GetLocalBySearchingRequest(cuid: cuid, localParameters: parameters, limit: limit, offset: offset)
        
        getLocalsBySearchingRequest.makeRequest { (result) in
            switch result
            {
            case .success(let data):
                success(data)
            case .failure(let err):
                failure(err)
            }
        }
    }
    
}
