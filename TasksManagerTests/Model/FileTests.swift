//
//  FileTests.swift
//  TasksManagerTests
//
//  Created by Grzegorz Biegaj on 14.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import XCTest
@testable import TasksManager

class FileTests: XCTestCase {

    func testInit() {
        let file = File(path: URL(string: "test/test2/fileName.txt")!)
        XCTAssertEqual(file.path, URL(string: "test/test2/fileName.txt")!)
        XCTAssertEqual(file.name, "fileName.txt")
        XCTAssertEqual(file.type, .txt)
        XCTAssertEqual(file.type.icon, UIImage(named: "txt"))
    }

    func testFileType() {
        var file = File(path: URL(string: "test/test2/fileName.jpg")!)
        XCTAssertEqual(file.type, .jpg)
        XCTAssertEqual(file.type.icon, UIImage(named: "jpg"))
        file = File(path: URL(string: "test/test2/fileName.pdf")!)
        XCTAssertEqual(file.type, .pdf)
        XCTAssertEqual(file.type.icon, UIImage(named: "pdf"))
        file = File(path: URL(string: "test/test2/fileName.png")!)
        XCTAssertEqual(file.type, .png)
        XCTAssertEqual(file.type.icon, UIImage(named: "png"))
        file = File(path: URL(string: "test/test2/fileName.txt")!)
        XCTAssertEqual(file.type, .txt)
        XCTAssertEqual(file.type.icon, UIImage(named: "txt"))
        file = File(path: URL(string: "test/test2/fileName.any")!)
        XCTAssertEqual(file.type, .file)
        XCTAssertEqual(file.type.icon, UIImage(named: "file"))
    }

}
