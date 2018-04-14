//
//  TaskController.swift
//  TasksManager
//
//  Created by Grzegorz Biegaj on 13.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import Foundation
import CoreData

protocol TaskControllerProtocol {

    var tasks: [Task] { get }
    func createOrUpdate(task: Task)
    @discardableResult
    func delete(task: Task) -> Bool
}

class TaskController: TaskControllerProtocol {

    static fileprivate let entityName = "DataTask"

    fileprivate let coreDataStorage: CoreDataStorable

    fileprivate var managedObjectContext: NSManagedObjectContext { return coreDataStorage.managedObjectContext }

    fileprivate func saveContext() {
        coreDataStorage.saveContext()
    }

    fileprivate var taskEntity: NSEntityDescription {
        guard let entity = NSEntityDescription.entity(forEntityName: TaskController.entityName, in: managedObjectContext) else {
            fatalError("Unable to create NSEntityDescription for \(TaskController.entityName).")
        }
        return entity
    }

    init (coreDataStorage: CoreDataStorable = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    // MARK: public interface methods

    var tasks: [Task] {
        let request = NSFetchRequest<DataTask>(entityName: TaskController.entityName)
        do {
            return try managedObjectContext.fetch(request).compactMap { Task(dataTask: $0) }
        } catch let error as NSError {
            print ("Unable to get :\(TaskController.entityName): \(error)")
        }
        return []
    }

    func createOrUpdate(task: Task) {
        if let _ = tasks.first(where: { $0.dataTask?.objectID == task.dataTask?.objectID }) {
            updateDataTask(dataTask: task.dataTask, task: task)
        } else {
            saveDataTask(task: task)
        }
    }

    @discardableResult
    func delete(task: Task) -> Bool {
        guard let task = tasks.first(where: { $0.dataTask?.objectID == task.dataTask?.objectID }) else { return false }
        return deleteDataTask(dataTask: task.dataTask)
    }

    // MARK: private interface

    @discardableResult
    fileprivate func saveDataTask(task: Task) -> DataTask {

        let dataTask = DataTask(entity: taskEntity, insertInto: managedObjectContext)
        dataTask.name = task.name
        dataTask.taskDescription = task.description
        dataTask.filePath = task.file.path.absoluteString
        dataTask.keywords = task.keywords as NSArray
        dataTask.status = Int16(task.status.rawValue)
        dataTask.completionTime = task.completionTime
        saveContext()
        return dataTask
    }

    @discardableResult
    fileprivate func updateDataTask(dataTask: DataTask?, task: Task) -> DataTask? {

        dataTask?.name = task.name
        dataTask?.taskDescription = task.description
        dataTask?.filePath = task.file.path.absoluteString
        dataTask?.keywords = task.keywords as NSArray
        dataTask?.status = Int16(task.status.rawValue)
        dataTask?.completionTime = task.completionTime
        saveContext()
        return dataTask
    }

    @discardableResult
    fileprivate func deleteDataTask(dataTask: DataTask?) -> Bool {
        guard let dataTask = dataTask else { return false }
        managedObjectContext.delete(dataTask)
        saveContext()
        return true
    }

}
