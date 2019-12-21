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
        let notificationsController = provideNotificationsScreen()
        
        let homeTabBarItem: UITabBarItem = UITabBarItem(title: "", image: UIImage(named: "Home"), tag: 0)
        let profileTabBarItem = UITabBarItem(title: "", image: UIImage(named: "Profile"), tag: 3)
        let notificationsTabBarItem = UITabBarItem(title: "", image: UIImage(named: "Notifications"), tag: 2)
        
        profileViewController.tabBarItem = profileTabBarItem
        homeViewController.tabBarItem = homeTabBarItem
        notificationsController.tabBarItem = notificationsTabBarItem
        
        tabBarController.viewControllers = [homeViewController, notificationsController, profileViewController]
        
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
    
    static func provideNotificationsScreen() -> UIViewController {
        let notificationsViewController = NotificationsViewController()
        let presenter = NotificationsPresenter(with: notificationsViewController, notificationsService: Repository.remote)
        notificationsViewController.configure(with: presenter)
        return notificationsViewController
    }
}
