//
//  Assembly.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 18/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

final class Assembler {
    
    static func provideView(callback: @escaping (UIViewController) -> Void)
    {
        let cuid = StoreManager.shared.getLoggedUser()
        
        let remote = Repository.remote
        
        let exists = StoreManager.shared.hasEverLogin(key: cuid)
        
        if exists
        {
            // si se ha loggeado
            let hasData = StoreManager.shared.getMinimumDataIsInserted(for: cuid)
            // miro si tiene algo de info en el perfil
            if hasData {
                let tabBarView = provideInitialTabBarController()
                tabBarView.modalPresentationStyle = .fullScreen
                callback(tabBarView)
            } else {
                let profileView = provideUserProfile(with: cuid, status: .editing)
                profileView.presenter.profileMode = .editing
                profileView.modalPresentationStyle = .fullScreen
                callback(profileView)
            }
        }
        else
        {
            remote.getProfile(currenUserCUID: cuid, success: { (profile) in
                guard let profile = profile else { return }
                
                if profile.name != nil, profile.name != ""
                {
                    // sabemos que el usuario tiene datos
                    let tabBarView = provideInitialTabBarController()
                    tabBarView.modalPresentationStyle = .fullScreen
                    StoreManager.shared.setMinimumDataIsInserted(for: cuid, with: true)
                    callback(tabBarView)
                }
                else
                {
                    let profileView = provideUserProfile(with: cuid, status: .editing)
                    profileView.presenter.profileMode = .editing
                    profileView.modalPresentationStyle = .fullScreen
                    callback(profileView)
                }
                
            }) { (error) in
                // manejar error
            }
        }
    }
    
    static func provideInitialTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        let cuid = StoreManager.shared.getLoggedUser()
        let profileViewController = provideUserProfile(with: cuid, status: .current)
        let homeViewController = HomeViewController()
        let searchViewController = SearchViewController()
        let notificationsController = provideNotificationsScreen()
        
        
        let homeTabBarItem: UITabBarItem = UITabBarItem(title: "", image: UIImage(named: "Home"), tag: 0)
        let profileTabBarItem = UITabBarItem(title: "", image: UIImage(named: "Profile"), tag: 3)
        let searchViewTabBarItem = UITabBarItem(title: "", image: UIImage(named: "SearchIcon"), tag: 1)
        let notificationsTabBarItem = UITabBarItem(title: "", image: UIImage(named: "Notifications"), tag: 2)
        
        profileViewController.tabBarItem = profileTabBarItem
        homeViewController.tabBarItem = homeTabBarItem
        notificationsController.tabBarItem = notificationsTabBarItem
        searchViewController.tabBarItem = searchViewTabBarItem
        
        tabBarController.viewControllers = [homeViewController, searchViewController, notificationsController, profileViewController]
        
        return tabBarController
    }
    
    static func provideUserProfile(with cuid: String, status: ProfileMode) -> ProfileViewController {
        let vc = ProfileViewController()
        let presenter = ProfilePresenter(with: vc, profileService: Repository.remote)
        vc.configure(with: presenter)
        vc.userCuid = cuid
        vc.presenter.profileMode = status

        return vc
    }
    
    static func provideLoginScreen() -> LoginViewController {
        let loginViewController = LoginViewController()
        let presenter = LoginPresenter(with: loginViewController, loginService: Repository.remote)
        loginViewController.configure(with: presenter)
        return loginViewController
    }
    
    static func provideLocalDetailView(withCuid local: String) -> UIViewController {
        let localViewController = LocalViewController()
        let presenter = LocalPresenter(with: localViewController, localService: Repository.remote)
        localViewController.configure(with: presenter, local: local)
        return localViewController
    }
    
    static func provideNotificationsScreen() -> UIViewController {
        let notificationsViewController = NotificationsViewController()
        let presenter = NotificationsPresenter(with: notificationsViewController, notificationsService: Repository.remote)
        notificationsViewController.configure(with: presenter)
        return notificationsViewController
    }
}
