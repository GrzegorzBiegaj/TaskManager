//
//  TaskListViewModelTests.swift
//  TasksManagerTests
//
//  Created by Grzegorz Biegaj on 14.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import XCTest
@testable import TasksManager

class TaskListViewModelTests: XCTestCase {

    let notificationsController = NotificationsControllerMock()

    func testTasks() {
        let taskController = TaskController(coreDataStorage: CoreDataStorageMock())
        let task1 = Task(name: "task 1", file: File(path: URL(string: "temp/file1.jpg")!))
        var task2 = Task(name: "task 2", file: File(path: URL(string: "temp/file2.pdf")!))
        task2.status = .completed
        taskController.createOrUpdate(task: task1)
        taskController.createOrUpdate(task: task2)
        let taskListViewModel = TaskListViewModel(taskController: taskController, notificationsController: notificationsController)

        XCTAssertEqual(taskListViewModel.tasks.count, 2)
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.name == "task 1"} ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.file.name == "file1.jpg"} ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.name == "task 2"} ))
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.file.name == "file2.pdf"} ))
    }

    func testGetTasks() {
        let taskController = TaskController(coreDataStorage: CoreDataStorageMock())
        let task1 = Task(name: "task 1", file: File(path: URL(string: "temp/file1.jpg")!))
        let task2 = Task(name: "task 2", file: File(path: URL(string: "temp/file2.pdf")!))
        let task3 = Task(name: "task 3", file: File(path: URL(string: "temp/file3.jpg")!), status: .completed)
        let task4 = Task(name: "task 4", file: File(path: URL(string: "temp/file4.pdf")!), status: .completed)
        let task5 = Task(name: "task 5", file: File(path: URL(string: "temp/file5.jpg")!), status: .completed)
        taskController.createOrUpdate(task: task1)
        taskController.createOrUpdate(task: task2)
        taskController.createOrUpdate(task: task3)
        taskController.createOrUpdate(task: task4)
        taskController.createOrUpdate(task: task5)
        let taskListViewModel = TaskListViewModel(taskController: taskController, notificationsController: notificationsController)

        let tasksPending = taskListViewModel.getTasks(showMode: .pending)
        XCTAssertEqual(tasksPending.count, 2)
        XCTAssertTrue(tasksPending.contains(where: { $0.name == "task 1"} ))
        XCTAssertTrue(tasksPending.contains(where: { $0.file.name == "file1.jpg"} ))
        XCTAssertTrue(tasksPending.contains(where: { $0.name == "task 2"} ))
        XCTAssertTrue(tasksPending.contains(where: { $0.file.name == "file2.pdf"} ))
        let tasksCompleted = taskListViewModel.getTasks(showMode: .completed)
        XCTAssertEqual(tasksCompleted.count, 3)
        XCTAssertTrue(tasksCompleted.contains(where: { $0.name == "task 3"} ))
        XCTAssertTrue(tasksCompleted.contains(where: { $0.file.name == "file3.jpg"} ))
        XCTAssertTrue(tasksCompleted.contains(where: { $0.name == "task 4"} ))
        XCTAssertTrue(tasksCompleted.contains(where: { $0.file.name == "file4.pdf"} ))
        XCTAssertTrue(tasksCompleted.contains(where: { $0.name == "task 5"} ))
        XCTAssertTrue(tasksCompleted.contains(where: { $0.file.name == "file5.jpg"} ))
    }

    func testDeleteTask() {
        let taskController = TaskController(coreDataStorage: CoreDataStorageMock())
        let task = Task(name: "task 1", file: File(path: URL(string: "temp/file1.jpg")!))
        taskController.createOrUpdate(task: task)
        let taskListViewModel = TaskListViewModel(taskController: taskController, notificationsController: notificationsController)

        XCTAssertEqual(taskListViewModel.tasks.count, 1)
        XCTAssertEqual(taskListViewModel.tasks[0].name, "task 1")
        XCTAssertEqual(taskListViewModel.tasks[0].file.name, "file1.jpg")
        taskListViewModel.deleteTask(task: taskListViewModel.tasks[0])
        XCTAssertEqual(taskListViewModel.tasks.count, 0)
    }

    func testChangeTaskStatus() {
        let taskController = TaskController(coreDataStorage: CoreDataStorageMock())
        let task = Task(name: "task 1", file: File(path: URL(string: "temp/file1.jpg")!))
        taskController.createOrUpdate(task: task)
        let taskListViewModel = TaskListViewModel(taskController: taskController, notificationsController: notificationsController)

        XCTAssertEqual(taskListViewModel.tasks.count, 1)
        XCTAssertEqual(taskListViewModel.tasks[0].name, "task 1")
        XCTAssertEqual(taskListViewModel.tasks[0].file.name, "file1.jpg")
        XCTAssertEqual(taskListViewModel.tasks[0].status, .pending)
        taskListViewModel.changeTaskStatus(task: taskListViewModel.tasks[0], status: .postponed)
        XCTAssertEqual(taskListViewModel.tasks[0].status, .postponed)
    }

    func testGetTaskName() {
        let taskController = TaskController(coreDataStorage: CoreDataStorageMock())
        var task1 = Task(name: "task 1", file: File(path: URL(string: "temp/file1.jpg")!))
        let taskListViewModel = TaskListViewModel(taskController: taskController, notificationsController: notificationsController)

        XCTAssertEqual(taskListViewModel.getTaskName(task: task1, showMode: .pending), task1.name)
        task1.status = .postponed
        XCTAssertEqual(taskListViewModel.getTaskName(task: task1, showMode: .pending), "\(task1.name) (postponed)")
        task1.status = .processing
        XCTAssertEqual(taskListViewModel.getTaskName(task: task1, showMode: .pending), "\(task1.name) (processing)")
        task1.status = .fileError
        XCTAssertEqual(taskListViewModel.getTaskName(task: task1, showMode: .pending), "\(task1.name) (file doesn't exist)")
        XCTAssertEqual(taskListViewModel.getTaskName(task: task1, showMode: .completed), "\(task1.name) (time: 0.0s)")
    }

}
