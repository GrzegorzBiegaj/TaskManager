//
//  TaskControllerTests.swift
//  TasksManagerTests
//
//  Created by Grzegorz Biegaj on 14.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import XCTest
@testable import TasksManager

class TaskControllerTests: XCTestCase {

    let notificationsController = NotificationsControllerMock()

    func testCreateOrUpdate() {
        let taskController = TaskController(coreDataStorage: CoreDataStorageMock())
        let taskListViewModel = TaskListViewModel(taskController: taskController, notificationsController: notificationsController)
        let task = Task(name: "task 1", file: File(path: URL(string: "temp/file1.jpg")!))

        XCTAssertEqual(taskListViewModel.tasks.count, 0)

        taskController.createOrUpdate(task: task)
        XCTAssertEqual(taskListViewModel.tasks.count, 1)
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.name == "task 1" } ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.description == nil } ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.file.name == "file1.jpg" } ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.keywords == [] } ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.status == .pending } ))

        var taskUpdated = taskListViewModel.tasks.last!
        taskUpdated.name = "task XXX"
        taskUpdated.description = "desc XXX"
        taskUpdated.file = File(path: URL(string: "temp/temp/one.abc")!)
        taskUpdated.keywords = ["wwww"]
        taskUpdated.status = .fileError
        taskController.createOrUpdate(task: taskUpdated)
        XCTAssertEqual(taskListViewModel.tasks.count, 1)
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.name == "task XXX" } ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.description == "desc XXX" } ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.file.name == "one.abc" } ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.keywords == ["wwww"] } ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.status == .fileError } ))

        let task2 = Task(name: "task 1", file: File(path: URL(string: "temp/file1.jpg")!))
        taskController.createOrUpdate(task: task2)
        XCTAssertEqual(taskListViewModel.tasks.count, 2)
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.name == "task XXX" } ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.description == "desc XXX" } ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.file.name == "one.abc" } ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.keywords == ["wwww"] } ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.status == .fileError } ))

        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.name == "task 1" } ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.description == nil } ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.file.name == "file1.jpg" } ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.keywords == [] } ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.status == .pending } ))
    }

    func testDeleteTask() {
        let taskController = TaskController(coreDataStorage: CoreDataStorageMock())
        let task = Task(name: "task 1", file: File(path: URL(string: "temp/file1.jpg")!))
        taskController.createOrUpdate(task: task)
        taskController.createOrUpdate(task: task)
        let taskListViewModel = TaskListViewModel(taskController: taskController, notificationsController: notificationsController)

        XCTAssertEqual(taskListViewModel.tasks.count, 2)
        XCTAssertEqual(taskListViewModel.tasks[0].name, "task 1")
        XCTAssertEqual(taskListViewModel.tasks[0].file.name, "file1.jpg")
        XCTAssertEqual(taskListViewModel.tasks[1].name, "task 1")
        XCTAssertEqual(taskListViewModel.tasks[1].file.name, "file1.jpg")
        taskListViewModel.deleteTask(task: taskListViewModel.tasks[0])
        XCTAssertEqual(taskListViewModel.tasks.count, 1)
        XCTAssertEqual(taskListViewModel.tasks[0].name, "task 1")
        XCTAssertEqual(taskListViewModel.tasks[0].file.name, "file1.jpg")
    }

}
