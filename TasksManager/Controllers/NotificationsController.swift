//
//  NotificationsController.swift
//  TasksManager
//
//  Created by Grzegorz Biegaj on 13.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import Foundation
import UserNotifications

protocol NotificationsControllerFeedbackProtocol: class {

    func notificationDefault()
    func notificationNew()
}

protocol NotificationsControllerProtocol {

    func registerForLocalNotifications()
    func sendLocalNotification(title: String, body: String, delay: TimeInterval)
}

class NotificationsController: NSObject, NotificationsControllerProtocol {

    static let shared = NotificationsController()

    weak var delegate: NotificationsControllerFeedbackProtocol?

    fileprivate override init() {
        super.init()
    }

    // MARK: public interface methods

    func registerForLocalNotifications() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound]
        center.requestAuthorization(options: options) { permission, error in
            if let error = error, !permission {
                print("Unable to register for local notifications: \(error)")
            }
        }
    }

    func sendLocalNotification(title: String, body: String, delay: TimeInterval) {
        let newButton = UNNotificationAction(identifier: "NewIdentifier", title: "New", options: [.foreground])
        let category = UNNotificationCategory(identifier: "category", actions: [newButton], intentIdentifiers: [], options: [])
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = "category"
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: "TaskManager", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([category])
        center.add(request) { (error : Error?) in
            if let error = error {
                print ("Sending local notification error: \(error.localizedDescription)")
            }
        }
    }

}

extension NotificationsController: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        // Determine the user action
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            // Notification tap
            delegate?.notificationDefault()
        case "NewIdentifier":
            // Notification "New" button tap
            delegate?.notificationNew()
        default: break
        }
        completionHandler()
    }
}
