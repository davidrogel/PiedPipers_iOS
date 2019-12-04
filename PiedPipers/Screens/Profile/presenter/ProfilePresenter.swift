//
//  ProfilePresenter.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 17/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

class ProfilePresenter {
    
    public private(set) var profileService: RepositoryFactory
    public private(set) weak var ui: ProfileViewProtocol?
    public private(set) var editing: Bool
    
    init(with ui: ProfileViewProtocol, profileService: RepositoryFactory, editing: Bool = false) {
        self.ui = ui
        self.profileService = profileService
        self.editing = editing
    }
    
    private func convert2ProfilePresentable(profile: Profile) -> ProfilePresentable {
        
        var namePresentable: String?
        var cityPresentable: String?
        var avatarPresentable: String?
        var contactPresentable: ContactPresentable?
        var instrumentPresentable: [String]?
        var videoPresentable: [VideoPresentable]?
        var aboutMePresentable: String?
        
        if let name = profile.name {
            namePresentable = name
        } else {
            namePresentable = nil
        }
        
        if let city = profile.friendlyLocation {
            cityPresentable = city
        } else {
            cityPresentable = nil
        }
        
        if let avatar = profile.photo {
            avatarPresentable = avatar
        } else {
            avatarPresentable = nil
        }
        
        if let contact = profile.contact {
            contactPresentable = ContactPresentable(type: contact.type, data: contact.data)
        } else {
            contactPresentable = nil
        }
        
        if let instrument = profile.instruments {
            instrumentPresentable = instrument
        } else {
            instrumentPresentable = nil
        }
        
        if let videos = profile.videos {
            videoPresentable = videos.map { (video) -> VideoPresentable in
                VideoPresentable(videoURL: video.video, thumbnail: video.thumbnail)
            }
        } else {
            videoPresentable = nil
        }
        
        if let aboutMe = profile.description {
            aboutMePresentable = aboutMe
        } else {
            aboutMePresentable = nil
        }
        
        let profilePresentable = ProfilePresentable(name: namePresentable, city: cityPresentable, avatar: avatarPresentable, contact: contactPresentable, instruments: instrumentPresentable, videos: videoPresentable, aboutMe: aboutMePresentable)
        
        return profilePresentable
    }
    
}

extension ProfilePresenter: ProfilePresenterProtocol {
    
    var isEditing: Bool {
        get {
            return editing
        }
        set {
            self.editing = newValue
        }
    }
    
    func loadCurrentUserProfile() {
        let cuid = StoreManager.shared.getLoggedUser()
        profileService.getProfile(currenUserCUID: cuid, success: { [weak self] (profile) in
            guard let currentProfile = profile else {
                fatalError()
            }
            let model = self?.convert2ProfilePresentable(profile: currentProfile)
            
            guard let modelUnwrapped = model else {
                //TODO: En caso de que falle, mostrar vista de perfil no encontrado
                
                return
            }
            self?.ui?.setCurrentUserProfileViewWith(model: modelUnwrapped)
            
        }, failure: { (error) in
            //TODO: En caso de que falle, mostrar vista de perfil no encontrado
        })
    }
    
    func prepareEditView() {
        ui?.setEditProfileView()
    }
    
    func getAvailableInstruments() {
        let cuid = StoreManager.shared.getLoggedUser()
        profileService.getAvaliableInstruments(currentUserCUID: cuid, success: { [weak self] (instruments) in
            guard let unwrappedInstruments = instruments else {
                fatalError()
            }
            self?.ui?.setAvailableInstruments(with: unwrappedInstruments)
        }, failure: { [weak self] (error) in
            self?.ui?.setAvailableInstruments(with: ["Guitarra", "Bateria", "Contrabajo", "Trompeta"])
        })
    }
    
}
