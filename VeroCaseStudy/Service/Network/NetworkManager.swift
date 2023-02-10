//
//  NetworkManager.swift
//  VeroCaseStudy
//
//  Created by Mac on 9.02.2023.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchHomeData(completion: @escaping(Result<[TaskResponseElement], Error>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    
    private var networkService: NetworkService = URLSessionNetworkService()
    
    func fetchHomeData(completion: @escaping (Result<[TaskResponseElement], Error>) -> Void) {
        guard let url = URL(string: "https://api.baubuddy.de/dev/index.php/v1/tasks/select") else { return }
       
        
        networkService.taskForGETRequest(url: url, responseType: [TaskResponseElement].self) { result in
            switch result {
            case .success(let tasks):
                completion(.success(tasks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
