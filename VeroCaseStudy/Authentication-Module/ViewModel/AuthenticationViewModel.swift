//
//  AuthenticationViewModel.swift
//  VeroCaseStudy
//
//  Created by Mac on 7.02.2023.
//

import Foundation
import ProgressHUD


protocol AuthenticatinViewModelProtocol {
    var delegate: AuthenticationViewModelDelegate? { get set }
    func login()
}

protocol AuthenticationViewModelDelegate: AnyObject {
    func loggedInSuccesfully()
    func cantLoggedIn()
}

final class AuthenticationViewModel: AuthenticatinViewModelProtocol {
    
    var delegate: AuthenticationViewModelDelegate?
    var userInfo : [String: Any] = [:]
    
    
    func login() {
        AuthService.shared.login(username: "365", password: "1") { result in
            switch result {
            case .success(true):
                self.delegate?.loggedInSuccesfully()
            case .failure(_):
                self.delegate?.cantLoggedIn()
            case .success(false):
                self.delegate?.cantLoggedIn()
            }
        }
    }

}
