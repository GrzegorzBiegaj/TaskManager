//
//  FileManager+additions.swift
//  TasksManager
//
//  Created by Grzegorz Biegaj on 13.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import Foundation

extension FileManager {

    func fileContent(path: URL) -> Data? {
        return contents(atPath: path.path) ?? contents(atPath: updatedPath(path: path))
    }

    fileprivate func updatedPath(path: URL) -> String {
        if var url = urls(for: .documentDirectory, in: .userDomainMask).first {
            url.appendPathComponent(path.lastPathComponent)
            return url.path
        }
        return path.path
    }

}
