//
//  HomeViewModel.swift
//  VeroCaseStudy
//
//  Created by Mac on 9.02.2023.
//

import Foundation

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set}
    func fetchHomeData()
    func getHomeDataCount() -> Int
    func getTask(at index: Int) -> TaskResponseElement?
    func updateSearchResults(text: String?)
  
}

protocol HomeViewModelDelegate: AnyObject {
    func tasksLoaded()
}

final class HomeViewModel: HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate?
    private lazy var networkManager: NetworkManagerProtocol = NetworkManager()
    private var taskList: [TaskResponseElement]? {
        didSet {
            filteredTaskList = taskList!
        }
    }
    
    private var coreDataTasks: [TaskEntity]?
    
    private var filteredTaskList: [TaskResponseElement]? 
    
    func fetchHomeData() {
        
        if Reachability.isConnectedToNetwork(){
            networkManager.fetchHomeData { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let tasks):
                    self.taskList = tasks
                    tasks.forEach { task in
                    _ = CoreDataTaskClient.shared.saveTaks(obj: task)
                    }
                    self.delegate?.tasksLoaded()
                case .failure(let error):
                    print( error)
                    return
                }
            }
        }else {
            let tasks = CoreDataTaskClient.shared.getTasks()
            self.coreDataTasks = tasks
            self.delegate?.tasksLoaded()
        }
    }
    
    func getHomeDataCount() -> Int {
        filteredTaskList?.count ?? 0
    }
    
    func getTask(at index: Int) -> TaskResponseElement? {
        filteredTaskList?[index]
    }

    func updateSearchResults(text: String?) {
        if text.isNilOrEmpty {
            filteredTaskList = taskList
        } else {
            filteredTaskList = taskList?.filter({($0.title!.lowercased().contains(text!)) || $0.task!.lowercased().contains(text!) || $0.description!.lowercased().contains(text!) || $0.wageType!.lowercased().contains(text!) || $0.businessUnit!.rawValue.lowercased().contains(text!) || $0.parentTaskID!.rawValue.lowercased().contains(text!)})
        }
    }
    
    
}
