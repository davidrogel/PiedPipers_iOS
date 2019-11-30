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
    
}

protocol ProfilePresenterProtocol: AnyObject {
    var isEditing: Bool { get set }
    func loadCurrentUserProfile()
    //func isUserLogged() -> String
    func prepareEditView()
}
