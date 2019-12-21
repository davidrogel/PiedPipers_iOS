//
//  ProfilePresenter.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 17/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

enum ProfileState {
    case current
    case editing
    case other
}

class ProfilePresenter {
    
    public private(set) var profileService: RepositoryFactory
    public private(set) weak var ui: ProfileViewProtocol?
    public private(set) var state: ProfileState
    
    init(with ui: ProfileViewProtocol, profileService: RepositoryFactory, state: ProfileState = .current) {
        self.ui = ui
        self.profileService = profileService
        self.state = state
    }
    
    private func convert2ProfilePresentable(profile: Profile) -> ProfilePresentable {
        
        var namePresentable: String?
        var cityPresentable: String?
        var avatarPresentable: String?
        var locationPresentable: LocationPresentable?
        var contactPresentable: ContactPresentable?
        var instrumentPresentable: [String]?
        var videoPresentable: [VideoPresentable]?
        var aboutMePresentable: String?
        var invitationsPresentable: [String]
        
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
        
        if let location = profile.location {
            locationPresentable = LocationPresentable(lat: location.lat, long: location.long)
        } else {
            locationPresentable = nil
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
                VideoPresentable(id: video.id, videoURL: video.video, thumbnail: video.thumbnail)
            }
        } else {
            videoPresentable = nil
        }
        
        if let aboutMe = profile.description {
            aboutMePresentable = aboutMe
        } else {
            aboutMePresentable = nil
        }
        
        if let invitations = profile.invitations {
            invitationsPresentable = invitations
        } else {
            invitationsPresentable = []
        }
        
        let profilePresentable = ProfilePresentable(name: namePresentable, city: cityPresentable, avatar: avatarPresentable, location: locationPresentable, contact: contactPresentable, instruments: instrumentPresentable, videos: videoPresentable, aboutMe: aboutMePresentable, invitations: invitationsPresentable)
        
        return profilePresentable
    }
    
    private func convert2Profile(withCuid cuid: String, profilePresentable: ProfilePresentable) -> Profile {
        var nameProfile: String?
        var cityProfile: String?
        var avatarProfile: String?
        var locationProfile: Location?
        var contactProfile: Contact?
        var instrumentProfile: [String]?
        var videoProfile: [Video]?
        var aboutMeProfile: String?
        
        nameProfile = profilePresentable.name
        
        if let city = profilePresentable.city {
            cityProfile = city
        } else {
            cityProfile = nil
        }
        
        if let avatar = profilePresentable.avatar {
            avatarProfile = avatar
        } else {
            avatarProfile = nil
        }
        
         if let location = profilePresentable.location {
            locationProfile = Location(lat: location.lat, long: location.long)
        } else {
            locationProfile = nil
        }
        
        if let contact = profilePresentable.contact {
            contactProfile = Contact(type: contact.type, data: contact.data)
        } else {
            contactProfile = nil
        }
        
        instrumentProfile = profilePresentable.instruments
        
        if let videos = profilePresentable.videos {
            videoProfile = videos.map { (video) -> Video in
                Video(id: video.id!, video: video.videoURL, embedVideo: nil, thumbnail: video.thumbnail)
            }
        } else {
            videoProfile = nil
        }
        
        if let aboutMe = profilePresentable.aboutMe {
            aboutMeProfile = aboutMe
        } else {
            aboutMeProfile = nil
        }
        
        let profile = Profile(cuid: cuid, name: nameProfile, location: locationProfile, contact: contactProfile, instruments: instrumentProfile, videos: videoProfile, description: aboutMeProfile, photo: avatarProfile, friendlyLocation: cityProfile)
        
        return profile
    }
    
}

extension ProfilePresenter: ProfilePresenterProtocol {
    
    var profileStatus: ProfileState {
        get {
            return state
        }
        set {
            state = newValue
        }
    }
    
    func loadUserProfile() {
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
            //TODO: En caso de que falle, mostrar vista de problemas al cargar perfil (vista de error)
        })
    }
    
    func loadSelectedUserProfile(with cuid: String) {
        let currentCuid = StoreManager.shared.getLoggedUser()
        profileService.getProfile(currentUserCUID: currentCuid, userPickedCUID: cuid, success: { [weak self] (profile) in
            if let selectedProfile = profile {
                let model = self?.convert2ProfilePresentable(profile: selectedProfile)
                guard let modelUnwrapped = model else {
                    //TODO
                    return
                }
                self?.ui?.setOtherUserProfileWith(model: modelUnwrapped)
            }
        }, failure: { [weak self] (error) in
            //TODO: Error al cargar perfil de usuario (vista de error)
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
    
    func updateProfile(with profilePresentable: ProfilePresentable) {
        let cuid = StoreManager.shared.getLoggedUser()
        let profile = convert2Profile(withCuid: cuid, profilePresentable: profilePresentable)
        profileService.updateProfile(currentUserCUID: cuid, newProfile: profile, success: { [weak self] (updatedProfile) in
            self?.ui?.showUpdateAlert(successfully: true)
        }, failure: { [weak self] (error) in
            self?.ui?.showUpdateAlert(successfully: false)
        })
    }
    
    func updateProfileAvatar(with data: Data) {
        let cuid = StoreManager.shared.getLoggedUser()
        profileService.updateAvatar(currentUserCUID: cuid, image: data, success: { [weak self] (profile) in
            self?.ui?.showUpdateAlert(successfully: true)
        }, failure: { [weak self] (error) in
            self?.ui?.showUpdateAlert(successfully: false)
        })
    }
    
    func updateProfile(with profilePresentable: ProfilePresentable, image: Data) {
        let cuid = StoreManager.shared.getLoggedUser()
        let profile = convert2Profile(withCuid: cuid, profilePresentable: profilePresentable)
        profileService.updateAvatar(currentUserCUID: cuid, image: image, success: { [weak self] (updateProfile) in
            self?.profileService.updateProfile(currentUserCUID: cuid, newProfile: profile, success: { [weak self] (updatedProfile) in
                self?.ui?.showUpdateAlert(successfully: true)
                }, failure: { [weak self] (error) in
                    self?.ui?.showUpdateAlert(successfully: false)
            })
            }, failure: { [weak self] (error) in
                self?.ui?.showUpdateAlert(successfully: false)
        })
    }
    
    func followUser(with cuid: String) {
        let currentUserCuid = StoreManager.shared.getLoggedUser()
        profileService.followProfile(currentUserCUID: currentUserCuid, otherProfileCUID: cuid, success: { [weak self] (profile) in
            var invitations = StoreManager.shared.getUserInvitations()
            invitations.append(cuid)
            StoreManager.shared.setUserInvitations(with: invitations)
            self?.ui?.wantToFollow()
        }, failure: { (error) in
            //TODO: Lanzar alert con error al realizar la petición de seguir
        })
    }
    
    func getCurrentUserFollowInvitations() {
        let currentUserCuid = StoreManager.shared.getLoggedUser()
        profileService.getProfile(currenUserCUID: currentUserCuid, success: { [weak self] (profile) in
            if let profileUnwrapped = profile {
                
            }
        }, failure: { [weak self] (error) in
                
        })
    }
    
}
