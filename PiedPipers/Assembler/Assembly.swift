//
//  Assembly.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 18/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

final class Assembler {
    
    static func provideInitialTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        let profileViewController = provideCurrentUserProfile()
        let homeViewController = HomeViewController()
        
        let homeTabBarItem: UITabBarItem = UITabBarItem(title: "", image: UIImage(named: "Home"), selectedImage: UIImage(named: "HomeSelected"))
        let profileTabBarItem = UITabBarItem(title: "", image: UIImage(named: "Profile"), selectedImage: UIImage(named: "ProfileSelected"))
        
        profileViewController.tabBarItem = profileTabBarItem
        homeViewController.tabBarItem = homeTabBarItem
        
        tabBarController.viewControllers = [homeViewController, profileViewController]
        
        return tabBarController
    }
    
    static func provideCurrentUserProfile() -> UIViewController {
        let currentUserViewController = ProfileViewController()
        let presenter = ProfilePresenter(with: currentUserViewController, profileService: Repository.remote)
        currentUserViewController.configure(with: presenter)

        return currentUserViewController
    }
    
    static func provideLoginScreen() -> UIViewController {
        let loginViewController = LoginViewController()
        let presenter = LoginPresenter(with: loginViewController, loginService: Repository.remote)
        loginViewController.configure(with: presenter)
        return loginViewController
    }
    
    static func provideLocalDetailView(withCuid local: String) -> UIViewController {
        let localViewController = LocalViewController()
        let presenter = LocalPresenter(with: localViewController, localService: Repository.fake)
        localViewController.configure(with: presenter, local: local)
        return localViewController
    }
}
