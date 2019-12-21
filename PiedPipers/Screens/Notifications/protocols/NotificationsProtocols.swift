//
//  NotificationsProtocols.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 12/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

protocol NotificationsViewProtocol: AnyObject {
    func setNotifications(with notifications: [NotificationCellPresentable])
}

protocol NotificationsPresenterProtocol: AnyObject {
    func getNotificationsList()
    //func loadSelectedUserProfile(with cuid: String)
}
