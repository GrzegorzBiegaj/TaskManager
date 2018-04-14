//
//  TaskListViewModel.swift
//  TasksManager
//
//  Created by Grzegorz Biegaj on 13.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import Foundation
import UIKit

enum ShowMode {
    case pending
    case completed
}

class TaskListViewModel {

    fileprivate let taskController: TaskControllerProtocol
    fileprivate let notificationsController: NotificationsControllerProtocol

    // MARK: public interface

    init(taskController: TaskControllerProtocol = TaskController(), notificationsController: NotificationsControllerProtocol = NotificationsController.shared) {
        self.taskController = taskController
        self.notificationsController = notificationsController
    }

    var tasks: [Task] {
        return taskController.tasks
    }

    func getTasks(showMode: ShowMode) -> [Task] {
        switch showMode {
        case .pending: return tasks.filter { $0.status != .completed }
        case .completed: return tasks.filter { $0.status == .completed }
        }
    }

    func deleteTask(task: Task) {
        taskController.delete(task: task)
    }

    func changeTaskStatus(task: Task, status: TaskStatus) {
        var task = task
        task.status = status
        if task.status == .pending {
            task.completionTime = 0.0
        }
        taskController.createOrUpdate(task: task)
    }

    func getTaskColor(task: Task) -> UIColor {
        if task.status == .postponed {
            return .yellow
        }
        return .white
    }

    func getTaskName(task: Task, showMode: ShowMode) -> String {

        if case .pending = showMode {
            switch task.status {
            case .postponed: return ("\(task.name) (postponed)")
            case .processing: return ("\(task.name) (processing)")
            case .fileError: return ("\(task.name) (file doesn't exist)")
            default: return task.name
            }
        } else {
            return "\(task.name) (time: \(String(format: "%.001f", task.completionTime))s)"
        }
    }

    func sendLocalNotification(task: Task) {
        switch task.status {
        case .postponed:
            self.notificationsController.sendLocalNotification(title: task.name, body: "Task is no longer postponed and will be processed", delay: TimeInterval(DropboxController.postponeTime))
        case .completed:
            self.notificationsController.sendLocalNotification(title: task.name, body: "Task completed", delay: 1)
        case .fileError:
            self.notificationsController.sendLocalNotification(title: task.name, body: "Task error", delay: 1)
        default: break
        }
    }

}
