//
//  LoginViewController.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 23/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    var loading: Bool! {
        didSet {
            if loading {
                loadingView.isHidden = false
            } else {
                loadingView.isHidden = true
            }
        }
    }
    
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
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var logInButtonBottomSpace: NSLayoutConstraint!
    
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
        emailBox.delegate = self
        passwordBox.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loading = true
        emailBox.text = ""
        passwordBox.text = ""
        setLoginView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let cuid = StoreManager.shared.getLoggedUser()
        if cuid != "" {
            self.present(Assembler.provideView(), animated: true)
        } else {
            loading = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loading = true
        emailBox.text = ""
        passwordBox.text = ""
        setLoginView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let cuid = StoreManager.shared.getLoggedUser()
        if cuid != "" {
            self.present(Assembler.provideView(), animated: true)
        } else {
            loading = false
        }
    }
    
    // MARK: Actions
    @IBAction func registerButtonTapped(_ sender: Any) {
        presenter.prepareRegisterView()
    }
    
    @IBAction func closeCurrentView(_ sender: Any) {
        presenter.prepareLoginView()
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
        cancelButton.isHidden = true
        logInButtonBottomSpace.constant = 16
    }
    
    func setRegisterView() {
        presenter.isLogging = false
        signUpView.isHidden = true
        logInButton.setTitle("Register", for: .normal)
        cancelButton.isHidden = false
        logInButtonBottomSpace.constant = 82
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
    
    func showNonExistentUserAlert() {
        let alert = UIAlertController(title: "Error", message: "Incorrect user or password.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showRegisterErrorAlert() {
        let alert = UIAlertController(title: "Error creating user.", message: "Sorry, we had trouble creating your user, try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func checkIfHasMinimumData() {
        presenter.getCurrentProfile()
    }
    
    func provideNextView() {
        self.present(Assembler.provideView(), animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
