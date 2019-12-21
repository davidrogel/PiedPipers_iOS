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

private func convert2NotificationCellPresentable(noti: Piper_Notification) -> NotificationCellPresentable {
    let cuid = noti.cuid
    var image = ""
    if let imageUnwrapped = noti.data.image {
        image = imageUnwrapped
    }
    let originUserCuid = noti.data.origin
    let originUserName = noti.data.originName
    let notiState = noti.state
    let notiPresentable = NotificationCellPresentable(cuid: cuid, image: image, userCuid: originUserCuid, userName: originUserName, notiState: notiState)
    return notiPresentable
}

extension NotificationsPresenter: NotificationsPresenterProtocol {
    func getNotificationsList() {
        let cuid = StoreManager.shared.getLoggedUser()
        notificationsService.getListOfNotifications(currentUserCUID: cuid, limit: 10, offset: 0, success: { [weak self] (notiList) in
            if notiList.total == 0 {
                //TODO: No hay notificaciones
            } else {
                let notiListPresentable = notiList.items.map { (noti) in
                    convert2NotificationCellPresentable(noti: noti)
                }
                self?.ui?.setNotifications(with: notiListPresentable)
            }
        }, failure: { (error) in
            
        })
    }
    
    
}
