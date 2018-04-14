//
//  EditTaskViewModel.swift
//  TasksManager
//
//  Created by Grzegorz Biegaj on 13.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

class EditTaskViewModel {

    class KeywordItem {
        let addButton: Bool
        var keyword: String

        init (addButton: Bool, keyword: String) {
            self.addButton = addButton
            self.keyword = keyword
        }
    }

    let taskController: TaskControllerProtocol

    // MARK: public interface

    init(keywords: [String]? = nil, taskController: TaskControllerProtocol = TaskController()) {
        self.taskController = taskController
        guard let keywords = keywords else { return }
        keywords.forEach { addKeyword(keyword: $0) }
    }

    func saveData(task: Task) {
        var task = task
        task.keywords = keywords
        taskController.createOrUpdate(task: task)
    }

    fileprivate(set) var keywordsData = [KeywordItem(addButton: true, keyword: "")]

    func addKeyword(keyword: String = "") {
        keywordsData.insert(KeywordItem(addButton: false, keyword: keyword), at: lastIndex)
    }

    func updateKeyword(index: Int, keyword: String?) {
        guard index < lastIndex else { return }
        keywordsData[index].keyword = keyword ?? ""
    }

    func deleteKeyword(index: Int) {
        guard index < lastIndex else { return }
        keywordsData.remove(at: index)
    }

    // MARK: Private methods

    fileprivate var lastIndex: Int {
        return keywordsData.count - 1
    }

    fileprivate var keywords: [String] {
        return keywordsData.filter { $0.addButton == false }.map { $0.keyword }
    }

}
