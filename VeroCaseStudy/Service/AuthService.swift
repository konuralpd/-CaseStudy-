//
//  AuthService.swift
//  VeroCaseStudy
//
//  Created by Mac on 8.02.2023.
//

import Foundation
import ProgressHUD

class AuthService {
    static let shared = AuthService()
    
    var userInfo : [String: Any] = [:]
    
    func login(username: String, password: String, completion: @escaping(Result<Bool, Error>) -> Void) {
        ProgressHUD.show()
        let headers = [
          "Authorization": "Basic QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz",
          "Content-Type": "application/json"
        ]
        let parameters = [
          "username": username,
          "password": password
        ] as [String : Any]

        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.baubuddy.de/index.php/login")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
              completion(.failure(error!))
          } else {
            let httpResponse = response as? HTTPURLResponse
              guard let responseData = data else {
                  print("nil data received from the server")
                  return
              }
              do {
                  if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {

                      self.userInfo = jsonResponse["oauth"] as! [String : Any]
                      UserDefaults.standard.set(self.userInfo["access_token"], forKey: "access_token")
//                      let userDefaults = UserDefaults.standard
//                      let dictionary = self.userInfo["access_token"]
//                      userDefaults.set(dictionary, forKey: "token")
                      completion(.success(true))
                  } else {
                      print("Data maybe corrupted or in wrong format")
                      throw URLError(.badServerResponse)
                  }
              } catch let error {
                  print(error.localizedDescription)
              }
          }
        })

        dataTask.resume()
    }
}
