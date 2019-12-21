//
//  Assembly.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 18/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

final class Assembler {
    
    static func provideView() -> UIViewController {
        let cuid = StoreManager.shared.getLoggedUser()
        
        let hasData = StoreManager.shared.getMinimumDataIsInserted(for: cuid)
        if hasData {
            let tabBarView = provideInitialTabBarController()
            tabBarView.modalPresentationStyle = .fullScreen
            return tabBarView
        } else {
            let profileView = provideUserProfile(with: cuid, status: .editing)
            profileView.presenter.profileStatus = .editing
            profileView.modalPresentationStyle = .fullScreen
            return profileView
        }
    }
    
    static func provideInitialTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        let cuid = StoreManager.shared.getLoggedUser()
        let profileViewController = provideUserProfile(with: cuid, status: .current)
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
    
    static func provideUserProfile(with cuid: String, status: ProfileState) -> ProfileViewController {
        let vc = ProfileViewController()
        let presenter = ProfilePresenter(with: vc, profileService: Repository.remote)
        vc.configure(with: presenter)
        vc.userCuid = cuid
        vc.presenter.profileStatus = status

        return vc
    }
    
    static func provideLoginScreen() -> LoginViewController {
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
