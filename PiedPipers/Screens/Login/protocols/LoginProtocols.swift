//
//  LoginProtocols.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 01/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

protocol LoginViewProtocol: AnyObject {
    func setRegisterView()
    func setLoginView()
    func showEmptyFieldAlert(field: String)
    func showNotEmailAlert()
    func showNonExistentUserAlert()
    func showRegisterErrorAlert()
    func provideNextView()
}

protocol LoginPreseterProtocol: AnyObject {
    func prepareRegisterView()
    func prepareLoginView()
    var isLogging: Bool { get set }
    func logInRegisterUser(with email: String?, password: String?)
}
