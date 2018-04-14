//
//  FileListViewModel.swift
//  TasksManager
//
//  Created by Grzegorz Biegaj on 13.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import Foundation

class FileListViewModel {

    fileprivate(set) var files: [File] = []
    private let fileManager: FileManager

    // MARK: public interface

    init(fileManager: FileManager = FileManager()) {
        self.fileManager = fileManager
        self.files = documentFiles
    }

    func getFileByIndex(_ index: Int) -> File? {
        return index < files.count ? files[index] : nil
    }

    // MARK: private methods

    fileprivate var documentFiles: [File] {
        do {
            if let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let paths = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [])
                return paths.map { File(path: $0) }.sorted { $0.name < $1.name }
            }
        } catch { return [] }
        return []
    }
}
