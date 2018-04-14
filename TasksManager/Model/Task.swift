//
//  Task.swift
//  TasksManager
//
//  Created by Grzegorz Biegaj on 13.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import Foundation

enum TaskStatus: Int {

    case pending
    case postponed
    case processing
    case completed
    case fileError
}

struct Task {

    var name: String
    var description: String?
    var file: File
    var keywords: [String]
    var status: TaskStatus
    var completionTime: Double
    var dataTask: DataTask?

    init(name: String, description: String? = nil, file: File, keywords: [String] = [], status: TaskStatus = .pending) {
        self.name = name
        self.description = description
        self.file = file
        self.keywords = keywords
        self.status = status
        self.completionTime = 0
        self.dataTask = nil
    }

    init?(dataTask: DataTask) {
        guard let name = dataTask.name,
            let status = TaskStatus(rawValue: Int(dataTask.status)),
            let path = dataTask.filePath,
            let keywords = dataTask.keywords as? [String],
            let filePath = URL(string: path) else { return nil }

        self.name = name
        self.status = status
        self.description = dataTask.taskDescription
        self.file = File(path: filePath)
        self.keywords = keywords
        self.completionTime = dataTask.completionTime
        self.dataTask = dataTask
    }
}
