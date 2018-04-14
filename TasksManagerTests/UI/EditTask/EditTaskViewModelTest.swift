//
//  EditTaskViewModelTest.swift
//  TasksManagerTests
//
//  Created by Grzegorz Biegaj on 14.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import XCTest
@testable import TasksManager

class EditTaskViewModelTest: XCTestCase {

    func testInit() {
        let taskController = TaskController(coreDataStorage: CoreDataStorageMock())
        let taskListViewModel = EditTaskViewModel(keywords: ["test1", "test2", "xxx"], taskController: taskController)
        let addKeyword = EditTaskViewModel.KeywordItem(addButton: true, keyword: "")

        XCTAssertEqual(taskListViewModel.keywordsData.count, 4)
        XCTAssertEqual(taskListViewModel.keywordsData[0].addButton, false)
        XCTAssertEqual(taskListViewModel.keywordsData[0].keyword, "test1")
        XCTAssertEqual(taskListViewModel.keywordsData[1].addButton, false)
        XCTAssertEqual(taskListViewModel.keywordsData[1].keyword, "test2")
        XCTAssertEqual(taskListViewModel.keywordsData[2].addButton, false)
        XCTAssertEqual(taskListViewModel.keywordsData[2].keyword, "xxx")
        XCTAssertEqual(taskListViewModel.keywordsData[3].addButton, addKeyword.addButton)
        XCTAssertEqual(taskListViewModel.keywordsData[3].keyword, addKeyword.keyword)
    }

    func testAddKeyword() {
        let taskController = TaskController(coreDataStorage: CoreDataStorageMock())
        let taskListViewModel = EditTaskViewModel(keywords: [], taskController: taskController)
        taskListViewModel.addKeyword(keyword: "test")
        XCTAssertEqual(taskListViewModel.keywordsData.count, 2)
        XCTAssertEqual(taskListViewModel.keywordsData[0].addButton, false)
        XCTAssertEqual(taskListViewModel.keywordsData[0].keyword, "test")
    }

    func testUpdateKeyword() {
        let taskController = TaskController(coreDataStorage: CoreDataStorageMock())
        let taskListViewModel = EditTaskViewModel(keywords: ["test"], taskController: taskController)
        taskListViewModel.updateKeyword(index: 0, keyword: "abc")
        XCTAssertEqual(taskListViewModel.keywordsData.count, 2)
        XCTAssertEqual(taskListViewModel.keywordsData[0].addButton, false)
        XCTAssertEqual(taskListViewModel.keywordsData[0].keyword, "abc")
        taskListViewModel.updateKeyword(index: 1000, keyword: "abc")
    }

    func testDeleteKeyword() {
        let taskController = TaskController(coreDataStorage: CoreDataStorageMock())
        let taskListViewModel = EditTaskViewModel(keywords: ["test"], taskController: taskController)
        taskListViewModel.updateKeyword(index: 0, keyword: "abc")
        XCTAssertEqual(taskListViewModel.keywordsData.count, 2)
        XCTAssertEqual(taskListViewModel.keywordsData[0].addButton, false)
        XCTAssertEqual(taskListViewModel.keywordsData[0].keyword, "abc")
        taskListViewModel.deleteKeyword(index: 0)
        XCTAssertEqual(taskListViewModel.keywordsData.count, 1)
        XCTAssertEqual(taskListViewModel.keywordsData[0].addButton, true)
        XCTAssertEqual(taskListViewModel.keywordsData[0].keyword, "")
        taskListViewModel.deleteKeyword(index: 1000)
        XCTAssertEqual(taskListViewModel.keywordsData.count, 1)
    }

    func testSaveData() {
        let taskController = TaskController(coreDataStorage: CoreDataStorageMock())
        let testKeywords = ["test", "test X", "test Z"]
        let taskListViewModel = EditTaskViewModel(keywords: testKeywords, taskController: taskController)
        let task = Task(name: "task 1", file: File(path: URL(string: "temp/file1.jpg")!))
        taskListViewModel.saveData(task: task)
        XCTAssertEqual(taskController.tasks[0].keywords, testKeywords)
    }

}
