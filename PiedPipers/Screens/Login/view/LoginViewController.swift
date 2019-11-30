//
//  LoginViewController.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 23/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var emailBox: UITextField!
    @IBOutlet weak var passwordBox: UITextField!
    
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
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
