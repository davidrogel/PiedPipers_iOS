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
    // MARK: - USER REQUESTS
    /// Crea un usuario
    func createUser(withEmail email: String, withPassword pass: String, success: @escaping (User?) -> Void, failure: @escaping (Error?) -> Void)
    /// Loggin con un usuario creado
    func loginUser(withEmail email: String, withPassword pass: String, success: @escaping (User?) -> Void, failure: @escaping (Error?) -> Void)
    /// Actualizar usuario
    func updateUser(currentUserCUID cuid: String, newPassword pass: String, success: @escaping (User?) -> Void, failure: @escaping (Error?) -> Void)
    /// Borra un usuario
    func deleteUser(currentUserCUID cuid: String, success: @escaping (Int) -> Void, failure: @escaping (Error?) -> Void)
    
    // MARK: - PROFILE REQUESTS
    /// Obtener tú perfil
    func getProfile(currenUserCUID cuid: String, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    /// Obtener el perfil de otro usuario
    func getProfile(currentUserCUID cuid: String, userPickedCUID otherCuid: String, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    /// Actualizar tú perfil
    func updateProfile(currentUserCUID cuid: String, newProfile profile: Profile, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    /// Actualizar el avatar del usuario
    func updateAvatar(currentUserCUID cuid: String, image data: Data, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    /// Obtener los instrumentos que se pueden usar
    func getAvaliableInstruments(currentUserCUID cuid: String, success: @escaping ([String]?) -> Void, failure: @escaping (Error?) -> Void)
    /// Seguir a un usuario
    func followProfile(currentUserCUID cuid: String, otherProfileCUID otherCUID: String, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    /// Dejar de seguir a otro usuario
    func unfollowProfile(currentUserCUID cuid: String, otherProfileCUID otherCUID: String, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    /// Obtener tu banda, obtienes un array de Perfiles ligados a ti
    func getProfileBand(currentUserCUID cuid: String, success: @escaping (ProfileList?) -> Void, failure: @escaping (Error?) -> Void)
    
    // MARK: - LOCAL REQUESTS
    /// Obtener un local por su CUID
    func getLocalById(localCuid cuid: String, success: @escaping (Local?) -> Void, failure: @escaping (Error?) -> Void)
    
    // MARK: - NOTIFICATIONS REQUESTS
    /// Borrar una notificación
    func deleteNotification(currentUserCUID cuid: String, notificationToDeleteCUID notiCuid: String, success: @escaping (Int) -> Void, failure: @escaping (Error?) -> Void)
    /// Obtener la lista de notificaciones que te han llegado
    func getListOfNotifications(currentUserCUID cuid: String, limit: Int, offset: Int, success: @escaping (NotiList) -> Void, failure: @escaping (Error?) -> Void)
    /// Redimir una notificación
    func redeemNotification(currentUserCUID cuid: String, notificationCUID notiCuid: String, success: @escaping (Noti) -> Void, failure: @escaping (Error?) -> Void)
    
    // MARK: - SEARCH REQUESTS
    func searchProfiles(currentUserCUID cuid: String, withParameters parameters: SearchProfileParameters, limit: Int, offset: Int, success: @escaping (ProfileList?) -> Void, failure: @escaping (Error?) -> Void)
    
    func searchLocals(currentUserCUID cuid: String, withParameters parameters: SearchLocalParameters, limit: Int, offset: Int, success: @escaping (LocalList?) -> Void, failure: @escaping (Error?) -> Void)
    
    // NOTIFICATIONS REQUESTS
    
    func getNotifications(currentUserCUID cuid: String, success: @escaping ([NotificationCellPresentable]?) -> Void, failure: @escaping (Error?) -> Void)
}

final class FakeRepository: RepositoryFactory
{
    func getLocalById(localCuid cuid: String, success: @escaping (Local?) -> Void, failure: @escaping (Error?) -> Void)
    {
        // TODO
    }
    
    func followProfile(currentUserCUID cuid: String, otherProfileCUID otherCUID: String, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    {
        // TODO
    }
    
    func unfollowProfile(currentUserCUID cuid: String, otherProfileCUID otherCUID: String, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    {
        // TODO
    }
    
    func getProfileBand(currentUserCUID cuid: String, success: @escaping (ProfileList?) -> Void, failure: @escaping (Error?) -> Void)
    {
        // TODO
    }
    
    func getListOfNotifications(currentUserCUID cuid: String, limit: Int, offset: Int, success: @escaping (NotiList) -> Void, failure: @escaping (Error?) -> Void)
    {
        // TODO
    }
    
    func redeemNotification(currentUserCUID cuid: String, notificationCUID notiCuid: String, success: @escaping (Noti) -> Void, failure: @escaping (Error?) -> Void)
    {
        // TODO
    }
    
    func deleteNotification(currentUserCUID cuid: String, notificationToDeleteCUID notiCuid: String, success: @escaping (Int) -> Void, failure: @escaping (Error?) -> Void) {
        // TODO
    }
    
    
    private let video1: Video = Video(id: "x52u8R2VNoE", video: "https://www.youtube.com/watch?v=x52u8R2VNoE", embedVideo: "https://www.youtube.com/embed/x52u8R2VNoE?ecver=1&amp;iv_load_policy=1&amp;yt:stretch=16:9&amp;autohide=1&amp;color=red&amp;", thumbnail: "https://img.youtube.com/vi/x52u8R2VNoE/hqdefault.jpg")
    
    private let video2 = Video(id: "VZzSBv6tXMw", video: "https://www.youtube.com/watch?v=VZzSBv6tXMw", embedVideo: "https://www.youtube.com/embed/VZzSBv6tXMw?ecver=1&amp;iv_load_policy=1&amp;yt:stretch=16:9&amp;autohide=1&amp;color=red&amp;", thumbnail: "https://img.youtube.com/vi/VZzSBv6tXMw/hqdefault.jpg")
    // Falta añadir videos a los FAKE perfiles
    private var userProfile_jon:Profile {
        let user = Profile(cuid: "", name: "name", location: Location(lat: 20.0, long: 20.0), contact: Contact(type: .email, data: "correo.a.encodear@correo.com"), instruments: ["bateria", "guitarra", "voz", "Bandurria", "Contrabajo", "Bajo", "Flauta", "Xilofono", "Trompeta", "Triangulo", "Trombon"], videos: [video1, video2], description: "", photo: "una foto")
        
        return user
    }
    
    private let userProfile = Profile(cuid: "", name: "Hideo Kojima", location: Location(lat: 20.0, long: 20.0), contact: Contact(type: .email, data: "Correo.a.encodear@correo.com"), instruments: ["guitarra", "voz", "productor"], videos: nil, description: "una descripción rexulona", photo: "kojima", friendlyLocation: "U.C.A.")
    
    private let userProfile2 = Profile(cuid: "", name: "Mads Mikkelsen", location: Location(lat: 20.0, long: 20.0), contact: Contact(type: .email, data: "Correo.a.encodear@correo.com"), instruments: ["bajo"], videos: nil, description: "una descripción rexulona", photo: "mads", friendlyLocation: "U.C.A.")
    
    private let userProfile3 = Profile(cuid: "", name: "Norman Reedus", location: Location(lat: 20.0, long: 20.0), contact: Contact(type: .email, data: "Correo.a.encodear@correo.com"), instruments: ["batería"], videos: nil, description: "una descripción rexulona", photo: "norman", friendlyLocation: "U.C.A.")

    private let otherProfile = Profile(cuid: "", name: "name", location: Location(lat: 20.0, long: 20.0), contact: Contact(type: .email, data: "Correo.a.encodear@correo.com"), instruments: ["bateria", "guitarra", "voz"], videos: nil, description: "una descripción rexulona", photo: "una foto")
    
    private let local = Local(cuid: "", name: "un local", dateAdded: "", location: Location(lat: 10.0, long: 10.0), price: 29.99, contact: Contact(type: .email, data: "arroba@correo.ru"), photos: ["kojima", "dos fotos", "tres... fotos?"], description: "una descripción de un local molón con una descripción tope larga que lo flipas chorbo", shortDescription: "Una descripción corta para que esto no quede horrible en la celda", address: "Calle Buenavista, 9ºB")
    
    private var notifications: [NotificationCellPresentable] {
        let noti1 = NotificationCellPresentable(image: "kojima", userCuid: "jlkdsahfo", userName: "Kojima", notificationAccepted: false)
        let noti2 = NotificationCellPresentable(image: "norman", userCuid: "jlkdsahfo", userName: "Norman", notificationAccepted: false)
        let noti3 = NotificationCellPresentable(image: "jongonzalez", userCuid: "jlkdsahfo", userName: "Jon", notificationAccepted: true)
        let noti4 = NotificationCellPresentable(image: "mads", userCuid: "jlkdsahfo", userName: "Mads", notificationAccepted: false)
        
        
        return [noti1, noti2, noti3, noti4]
    }

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
    // NOTIFICATIONS
    func getNotifications(currentUserCUID cuid: String, success: @escaping ([NotificationCellPresentable]?) -> Void, failure: @escaping (Error?) -> Void) {
        success(notifications)
    }
    
    func updateAvatar(currentUserCUID cuid: String, image data: Data, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    {
        
    }
    
    func searchProfiles(currentUserCUID cuid: String, withParameters parameters: SearchProfileParameters, limit: Int, offset: Int, success: @escaping (ProfileList?) -> Void, failure: @escaping (Error?) -> Void)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            success(ProfileList(total: 3, offset: 3, items: [self.userProfile, self.userProfile2, self.userProfile3,self.userProfile, self.userProfile2, self.userProfile3,self.userProfile, self.userProfile2, self.userProfile3]))
        }
    }
    
    func searchLocals(currentUserCUID cuid: String, withParameters parameters: SearchLocalParameters, limit: Int, offset: Int, success: @escaping (LocalList?) -> Void, failure: @escaping (Error?) -> Void)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            success(LocalList(total: 3, offset: 3, items: [self.local, self.local, self.local]))
//            success(LocalList(total: 0, offset: 0, items: []))
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
    // MARK: - USER
    
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
    
    // MARK: - PROFILE
    
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
            }
        }
    }
    
    func updateAvatar(currentUserCUID cuid: String, image data: Data, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    {
        let updateCurrentUserAvatar = UpdateProfileAvatarRequest(currentUserCuid: cuid, imgData: data)
        
        updateCurrentUserAvatar.makeUpload { (result) in
            switch result
            {
            case .success(let data):
                success(data)
            case .failure(let err):
                failure(err)
            }
        }
    }
    
    func getAvaliableInstruments(currentUserCUID cuid: String, success: @escaping ([String]?) -> Void, failure: @escaping (Error?) -> Void)
    {
        let getInstrumentsRequest = GetInstrumentsRequest(currentUserCuid: cuid)
        
        getInstrumentsRequest.makeRequest { (result) in
            
            switch result
            {
            case .success(let data):
                success(data.items)
            case .failure(let err):
                failure(err)
            }
        }
    }
    
    func followProfile(currentUserCUID cuid: String, otherProfileCUID otherCUID: String, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    {
        let followOtherUserRequest = FollowOtherUserRequest(currentUserCuid: cuid, followUserCuid: otherCUID)

        followOtherUserRequest.makeRequest { (result) in
           switch result
           {
           case .success(let data):
                success(data)
           case .failure(let err):
                failure(err)
           }
        }
    }
    
    func unfollowProfile(currentUserCUID cuid: String, otherProfileCUID otherCUID: String, success: @escaping (Profile?) -> Void, failure: @escaping (Error?) -> Void)
    {
        let unfollowOtherUserRequest = UnfollowOtherUserRequest(currentUserCuid: cuid, unfollowUserCuid: otherCUID)

        unfollowOtherUserRequest.makeRequest { (result) in
           switch result
           {
           case .success(let data):
                success(data)
           case .failure(let err):
                failure(err)
           }
        }
    }
    
    func getProfileBand(currentUserCUID cuid: String, success: @escaping (ProfileList?) -> Void, failure: @escaping (Error?) -> Void)
    {
        let getCurrentProfileBand = GetCurrentProfileBand(currentUserCuid: cuid)
            
        getCurrentProfileBand.makeRequest { (result) in
           switch result
           {
           case .success(let data):
                success(data)
           case .failure(let err):
                failure(err)
           }
        }
    }
    
    // MARK: - LOCAL
    
    func getLocalById(localCuid cuid: String, success: @escaping (Local?) -> Void, failure: @escaping (Error?) -> Void)
    {
        let getLocalByIdRequest = GetLocalByIdRequest(localCuid: cuid)
        
        getLocalByIdRequest.makeRequest { (result) in
           switch result
           {
           case .success(let data):
                success(data)
           case .failure(let err):
                failure(err)
           }
        }
    }
    
    // MARK: - NOTIFICATIONS
    
    func deleteNotification(currentUserCUID cuid: String, notificationToDeleteCUID notiCuid: String, success: @escaping (Int) -> Void, failure: @escaping (Error?) -> Void)
    {
        let deleteNotificationRequest = DeleteNotificationRequest(currentUserCuid: cuid, notiCuidToDelete: notiCuid)
        
        deleteNotificationRequest.makeRequest { (result) in
           switch result
           {
           case .success(let data):
                success(data)
           case .failure(let err):
                failure(err)
           }
        }
    }
    
    func getListOfNotifications(currentUserCUID cuid: String, limit: Int, offset: Int, success: @escaping (NotiList) -> Void, failure: @escaping (Error?) -> Void)
    {
        let getListNotificationsRequest = ListNotificationsRequest(currentUserCuid: cuid, limit: limit, offset: offset)

        getListNotificationsRequest.makeRequest { (result) in
           switch result
           {
           case .success(let data):
                success(data)
           case .failure(let err):
                failure(err)
           }
        }
    }
    
    func redeemNotification(currentUserCUID cuid: String, notificationCUID notiCuid: String, success: @escaping (Noti) -> Void, failure: @escaping (Error?) -> Void)
    {
        let redeemNotificationRequest = RedeemNotificationRequest(currentUserCuid: cuid, notificationCuid: notiCuid)
        
        redeemNotificationRequest.makeRequest { (result) in
           switch result
           {
           case .success(let data):
                success(data)
           case .failure(let err):
                failure(err)
           }
        }
    }
    
    // MARK: - SEARCHING
    
    func searchProfiles(currentUserCUID cuid: String, withParameters parameters: SearchProfileParameters, limit: Int, offset: Int, success: @escaping (ProfileList?) -> Void, failure: @escaping (Error?) -> Void)
    {
        let getProfilesBySearchingRequest = GetProfileBySearchingRequest(cuid: cuid,profileParameters: parameters, limit: limit, offset: offset)
        
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
    
    // NOTIFICATIONS
    
    
    func getNotifications(currentUserCUID cuid: String, success: @escaping ([NotificationCellPresentable]?) -> Void, failure: @escaping (Error?) -> Void) {
        //TODO
    }
    
}
