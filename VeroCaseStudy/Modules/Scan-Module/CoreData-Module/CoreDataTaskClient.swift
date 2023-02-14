//
//  CoreDataTaskClient.swift
//  VeroCaseStudy
//
//  Created by Mac on 11.02.2023.
//


import Foundation
import CoreData
import UIKit

//final class CoreDataTaskClient {
//    //MARK: - Property
//    static let shared: CoreDataTaskClient = CoreDataTaskClient()
//    private let coredata: CoreDataManager
//
//    //MARK: - init
//    private init(){
//        self.coredata = CoreDataManager(entityName: "TaskEntity")
//    }
//
//    //MARK: - METHODS
//    func saveTasks(coreTask: TaskResponseElement, completion: @escaping(Result<CoreDataCustomSuccesMessage,CoreDataError>) -> Void){
//        coredata.saveObject() { task in
//            task.setValue(coreTask.title, forKeyPath: "title")
//            task.setValue(coreTask.task, forKey: "task")
//            task.setValue(coreTask.description, forKey: "descriptionTask")
//            task.setValue(coreTask.colorCode, forKey: "colorCode")
//        } completion: { result in
//            completion(result)
//        }
//
//
//    }
//
//    func getAllTasks(completion: @escaping(Result<[TaskEntity],CoreDataError>) -> Void){
//        coredata.getAllObjects(responseType: TaskEntity.self) { result in
//            completion(result)
//        }
//    }
//}


final class CoreDataTaskClient {
    // MARK: - Shared
    static let shared = CoreDataTaskClient()
    private let managedContext: NSManagedObjectContext!
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Note
    func saveTaks(obj:TaskResponseElement) -> TaskEntity? {
        let entity = NSEntityDescription.entity(forEntityName: "TaskEntity", in: managedContext)!
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        task.setValue(obj.title, forKeyPath: "title")
        task.setValue(obj.task, forKey: "task")
        task.setValue(obj.description, forKey: "descriptionTask")
        task.setValue(obj.colorCode, forKey: "colorCode")
        
        do {
            try managedContext.save()
            return task as? TaskEntity
        } catch let error as NSError {
            NotificationCenter.default.post(name: NSNotification.Name("noteGamesErrorMessage"), object: error.localizedDescription)
        }
        
        return nil
    }
    
    func getTasks() -> [TaskEntity] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TaskEntity")
        do {
            let tasks = try managedContext.fetch(fetchRequest)
            return tasks as! [TaskEntity]
        } catch let error as NSError {
           print(error)
        }
        return []
    }
    

    
}
