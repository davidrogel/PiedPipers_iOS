//
//  NotificationsPresenter.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 12/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

class NotificationsPresenter {
    
    public private(set) var notificationsService: RepositoryFactory
    public private(set) weak var ui: NotificationsViewProtocol?
    
    init(with ui: NotificationsViewProtocol, notificationsService: RepositoryFactory) {
        self.ui = ui
        self.notificationsService = notificationsService
    }
}

extension NotificationsPresenter: NotificationsPresenterProtocol {
    func getNotificationsList() {
        let cuid = StoreManager.shared.getLoggedUser()
        notificationsService.getNotifications(currentUserCUID: cuid, success: { [weak self] (notifications) in
            guard let notificationsUnwrapped = notifications else {
                fatalError()
            }
            self?.ui?.setNotifications(with: notificationsUnwrapped)
        }, failure: { [weak self] (error) in
            
        })
    }
    
    
}
