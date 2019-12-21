//
//  LoginPresenter.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 01/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

class LoginPresenter {
    public private(set) var loginService: RepositoryFactory
    public private(set) weak var ui: LoginViewProtocol?
    public private(set) var logging: Bool
    
    init(with ui: LoginViewProtocol, loginService: RepositoryFactory, logging: Bool = true) {
        self.ui = ui
        self.loginService = loginService
        self.logging = logging
    }
}

extension LoginPresenter: LoginPreseterProtocol {
    
    var isLogging: Bool {
        get {
            return logging
        }
        set {
            self.logging = newValue
        }
    }    
    
    func prepareLoginView() {
        ui?.setLoginView()
    }
    
    func prepareRegisterView() {
        ui?.setRegisterView()
    }
    
    func logInRegisterUser(with email: String?, password: String?) {
        guard let emailUnwrapped = email else {
            fatalError()
        }
        guard let passUnwrapped = password else {
            fatalError()
        }
        if emailUnwrapped == "" {
            ui?.showEmptyFieldAlert(field: "email")
            return
        }
        if (emailUnwrapped.isValidEmail() == false) {
            ui?.showNotEmailAlert()
            return
        }
        if passUnwrapped == "" {
            ui?.showEmptyFieldAlert(field: "password")
            return
        }
        if logging {
            loginService.loginUser(withEmail: emailUnwrapped, withPassword: passUnwrapped, success: { [weak self] (user) in
                guard let userLogged = user else {
                    fatalError()
                }
                StoreManager.shared.setLoggedUser(userCuid: userLogged.id)
                self?.ui?.provideNextView()
                
            }, failure: { [weak self] (error) in
                //TODO: Mostrar error de usuario no existe o contraseña incorrecta
                // Todavía no lo tiene implementado David (ECHAR UN VISTAZO EN CUANTO PUEDA)
                self?.ui?.showNonExistentUserAlert()
                
            })
        } else {
            loginService.createUser(withEmail: emailUnwrapped, withPassword: passUnwrapped, success: { [weak self] (user) in
                guard let _ = user else {
                    fatalError()
                }
                self?.ui?.setLoginView()
                
            }, failure: { [weak self] (error) in
                //TODO: Poner los errores necesarios
                self?.ui?.showRegisterErrorAlert()
            })
        }
        
    }
}
