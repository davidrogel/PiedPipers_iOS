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
    func setOtherUserProfileWith(model: ProfilePresentable, invitations: [String], followers: [String])
    func setAvailableInstruments(with instruments: [String])
    func showUpdateAlert(successfully: Bool)
    func wantToFollow()
    
}

protocol ProfilePresenterProtocol: AnyObject {
    var profileStatus: ProfileState { get set }
    func loadUserProfile()
    func loadSelectedUserProfile(with cuid: String)
    func prepareEditView()
    func getAvailableInstruments()
    func updateProfile(with profilePresentable: ProfilePresentable)
    func updateProfileAvatar(with data: Data)
    func updateProfile(with profilePresentable: ProfilePresentable, image: Data)
    func followUser(with cuid: String)
}
