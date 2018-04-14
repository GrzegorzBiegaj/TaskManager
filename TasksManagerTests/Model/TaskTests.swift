//
//  TaskTests.swift
//  TasksManagerTests
//
//  Created by Grzegorz Biegaj on 14.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import XCTest
@testable import TasksManager

class TaskTests: XCTestCase {

    func testBasicInit() {
        let file = File(path: URL(string: "temp/file1.jpg")!)
        let task = Task(name: "name", file: file)

        XCTAssertEqual(task.name, "name")
        XCTAssertNil(task.description)
        XCTAssertEqual(task.file.path, file.path)
        XCTAssertEqual(task.keywords, [])
        XCTAssertEqual(task.status, .pending)
        XCTAssertEqual(task.completionTime, 0.0)
    }

    func testInit() {
        let file = File(path: URL(string: "temp/file1.jpg")!)
        let keywords = ["test1", "testX", "testZ"]
        var task = Task(name: "name", description: "description", file: file, keywords: keywords, status: .fileError)
        task.completionTime = 12.3

        XCTAssertEqual(task.name, "name")
        XCTAssertEqual(task.description, "description")
        XCTAssertEqual(task.file.path, file.path)
        XCTAssertEqual(task.keywords, keywords)
        XCTAssertEqual(task.status, .fileError)
        XCTAssertEqual(task.completionTime, 12.3)
    }

    func testDataTaskInit() {
        let notificationsController = NotificationsControllerMock()
        let taskController = TaskController(coreDataStorage: CoreDataStorageMock())
        let file = File(path: URL(string: "temp/file1.jpg")!)
        let task = Task(name: "task 1", file: file)
        taskController.createOrUpdate(task: task)
        let taskListViewModel = TaskListViewModel(taskController: taskController, notificationsController: notificationsController)

        let dataTask = taskListViewModel.tasks[0].dataTask!
        let newTask = Task(dataTask: dataTask)
        XCTAssertEqual(newTask?.name, "task 1")
        XCTAssertEqual(newTask?.description, nil)
        XCTAssertEqual(newTask?.file.path, file.path)
        XCTAssertEqual(newTask?.keywords, [])
        XCTAssertEqual(newTask?.status, .pending)
        XCTAssertEqual(newTask?.completionTime, 0.0)
    }

}
