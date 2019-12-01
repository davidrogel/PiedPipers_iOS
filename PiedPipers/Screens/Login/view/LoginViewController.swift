//
//  LoginViewController.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 23/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Presenter elements
    public private(set) var presenter: LoginPreseterProtocol!
    
    func configure(with presenter: LoginPreseterProtocol) {
        self.presenter = presenter
    }

    // MARK: Outlets
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var emailBox: UITextField!
    @IBOutlet weak var passwordBox: UITextField!
    @IBOutlet weak var signUpView: UIView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let _ = [cancelButton, logInButton].map {
            $0.putShadowsAndRadiusWith(shadowColor: UIColor.black.cgColor, shadowOffsetWidth: 0, shadowOffsetHeight: 1, shadowOpacity: 0.3, shadowRadius: 4, cornerRadius: 20)
        }
        
        let _ = [emailBox, passwordBox].map {
//            $0?.layer.cornerRadius = 10.0
//            $0?.layer.masksToBounds = true
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
            $0?.leftView = paddingView
            $0?.leftViewMode = UITextField.ViewMode.always
            $0?.borderStyle = .none
        }
    }
    
    // MARK: Actions
    @IBAction func registerButtonTapped(_ sender: Any) {
        presenter.prepareRegisterView()
    }
    
    @IBAction func closeCurrentView(_ sender: Any) {
        if presenter.isLogging {
            dismissView()
        } else {
            presenter.prepareLoginView()
        }
    }
    
    @IBAction func loginRegisterButtonTapped(_ sender: Any) {
        presenter.logInRegisterUser(with: emailBox.text, password: passwordBox.text)
    }
    
}

extension LoginViewController: LoginViewProtocol {
    
    func setLoginView() {
        presenter.isLogging = true
        signUpView.isHidden = false
        logInButton.setTitle("Login", for: .normal)
        cancelButton.setTitle("Not now", for: .normal)
    }
    
    func setRegisterView() {
        presenter.isLogging = false
        signUpView.isHidden = true
        logInButton.setTitle("Register", for: .normal)
        cancelButton.setTitle("I have account", for: .normal)
    }
    
    func showEmptyFieldAlert(field: String) {
        let alert = UIAlertController(title: "You haven't entered your \(field).", message: "Please enter your \(field).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showNotEmailAlert() {
        let alert = UIAlertController(title: "The email is not valid.", message: "Please enter a valid email.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showNonExistentUserAlert() {
        let alert = UIAlertController(title: "Error", message: "Usuario inexistente", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showRegisterErrorAlert() {
        let alert = UIAlertController(title: "Error creating user.", message: "Sorry, we had trouble creating your user, try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
