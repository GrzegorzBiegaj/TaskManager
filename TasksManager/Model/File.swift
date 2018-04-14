//
//  File.swift
//  TasksManager
//
//  Created by Grzegorz Biegaj on 13.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import UIKit

enum FileType: String {
    case jpg = "jpg"
    case pdf = "pdf"
    case png = "png"
    case txt = "txt"
    case file = "file"

    var icon: UIImage? {
        return UIImage(named: self.rawValue)
    }
}

struct File {

    let name: String
    let type: FileType
    let path: URL

    init(path: URL) {
        self.name = path.lastPathComponent
        self.type = FileType.init(rawValue: path.pathExtension) ?? .file
        self.path = path
    }
}
