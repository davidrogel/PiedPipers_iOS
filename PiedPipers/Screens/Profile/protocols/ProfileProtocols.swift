//
//  ProfileProtocols.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 17/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

protocol ProfileViewProtocol: AnyObject {
    func setEditProfileView() //model: ProfilePresentable)
    func setCurrentUserProfileViewWith(model: ProfilePresentable)
    func setOtherUserProfileWith(model: ProfilePresentable)
    func setAvailableInstruments(with instruments: [String])
    func showUpdateAlert(successfully: Bool)
    
}

protocol ProfilePresenterProtocol: AnyObject {
    var isEditing: Bool { get set }
    func loadCurrentUserProfile()
    func prepareEditView()
    func getAvailableInstruments()
    func updateProfile(with profilePresentable: ProfilePresentable)
    func updateProfileAvatar(with data: Data)
    func updateProfile(with profilePresentable: ProfilePresentable, image: Data)
}
