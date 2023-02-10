//
//  NetworkService.swift
//  VeroCaseStudy
//
//  Created by Mac on 9.02.2023.
//

import Foundation

protocol NetworkService {
    func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (Result<ResponseType, NetworkServiceError>) -> Void)
}

final class URLSessionNetworkService: NetworkService {
    func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (Result<ResponseType, NetworkServiceError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let token = UserDefaults.standard.string(forKey: "access_token") else { return }
        request.setValue("Bearer " + token, forHTTPHeaderField: "authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkServiceError.noData))
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                
                let responseObject = try decoder.decode(ResponseType.self, from: data)
               
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
            } catch {
                print(error.localizedDescription)
                completion(.failure(NetworkServiceError.dataParseError))
            }
        }
        task.resume()
    }
}
