//
//  NotificationsControllerMock.swift
//  TasksManagerTests
//
//  Created by Grzegorz Biegaj on 14.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import Foundation
@testable import TasksManager

class NotificationsControllerMock: NotificationsControllerProtocol {

    func registerForLocalNotifications() {

    }

    func sendLocalNotification(title: String, body: String, delay: TimeInterval) {

    }
}
