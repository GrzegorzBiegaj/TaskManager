//
//  DropboxController.swift
//  TasksManager
//
//  Created by Grzegorz Biegaj on 13.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import UIKit
import SwiftyDropbox

class DropboxController {

    static let postponeTime = 60

    fileprivate let taskController: TaskController

    // MARK: public interface methods

    init(taskController: TaskController = TaskController()) {
        self.taskController = taskController
    }

    func authorize(completion: (() -> Void)? = nil) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let rootVC = appDelegate.window?.rootViewController else { return }

        appDelegate.dropboxAuthorizationClosure = completion
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: rootVC,
                                                      openURL: { (url: URL) -> Void in
                                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
    }

    func taskProcessing(task: Task, closure: ((Task) -> Void)? = nil) {

        var task = task
        guard let data = FileManager.default.fileContent(path: task.file.path) else {
            task.status = .fileError
            taskController.createOrUpdate(task: task)
            closure?(task)
            return
        }
        if let authorizedClient = DropboxClientsManager.authorizedClient {

            let timeStamp = Date()
            _ = authorizedClient.files.upload(path: "/\(task.file.path.lastPathComponent)", mode: .overwrite, input: data)
                .response { [unowned self] response, error in
                    if let _ = response {
                        task.completionTime = abs(timeStamp.timeIntervalSinceNow)
                        task.status = .completed
                    } else if let _ = error {
                        task.status = .pending
                    }
                    self.taskController.createOrUpdate(task: task)
                    closure?(task)
                }.progress { progress in
                    task.status = .processing
                    self.taskController.createOrUpdate(task: task)
                    closure?(task)
            }
        } else {
            authorize(completion: { [unowned self] in
                self.taskProcessing(task: task)
            })
        }
    }

    func postponeTaskProcessing(task: Task, closure: ((Task) -> Void)? = nil) {

        var task = task
        task.status = .postponed
        self.taskController.createOrUpdate(task: task)
        closure?(task)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(DropboxController.postponeTime)) {
            self.taskProcessing(task: task, closure: closure)
        }
    }

}
