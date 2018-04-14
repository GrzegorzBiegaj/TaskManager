//
//  TaskListViewModelTests.swift
//  TasksManagerTests
//
//  Created by Grzegorz Biegaj on 14.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import XCTest
@testable import TasksManager

class FileListTests: XCTestCase {

    func testInit() {
        let fileManager = FileManager()
        let viewModel = FileListViewModel(fileManager: fileManager)

        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.files)
        XCTAssertNil(viewModel.getFileByIndex(1000))
    }

}

