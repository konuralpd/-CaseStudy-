//
//  LoginViewController.swift
//  VeroCaseStudy
//
//  Created by Mac on 8.02.2023.
//

import UIKit
import ProgressHUD

class LoginViewController: UIViewController {
    
    private var viewModel: AuthenticatinViewModelProtocol = AuthenticationViewModel()
    
    //Start of User Interface Element Declarations
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "appLogo")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let usernameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.text = "Username"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.text = "Password"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameTextField: ATextField = {
        let field = ATextField(
            placeholder: "Username",
            padding: 10,
            cornerRadius: 8,
            backgroundColor: .secondarySystemBackground,
            isSecureTextEntry: false)
        field.autocapitalizationType = .none
        field.textColor = .label
        field.autocorrectionType = .no
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let passwordTextField: ATextField = {
        let field = ATextField(
            placeholder: "Password",
            padding: 10,
            cornerRadius: 8,
            backgroundColor: .secondarySystemBackground,
            isSecureTextEntry: true)
        field.autocapitalizationType = .none
        field.textColor = .label
        field.autocorrectionType = .no
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let loginButton: UIButton = {
       let button = UIButton()
        button.setTitle("Authenticate", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        return button
    }()
    
    //End of User Interface Element Declarations
    
    
    //viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        makeUI()
    }
    
    //FUNCTIONS
    
    private func makeUI() {
        title = "Login"
        view.backgroundColor = .systemBackground
        view.addSubview(logoImageView)
        view.addSubview(usernameLabel)
        view.addSubview(passwordLabel)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 168),
            logoImageView.widthAnchor.constraint(equalToConstant: 256),
            
            usernameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 24),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 12),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            usernameTextField.heightAnchor.constraint(equalToConstant: 48),
            
            passwordLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 24),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 12),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            loginButton.heightAnchor.constraint(equalToConstant: 52)
            
        ])
    }

    //OBJ-C Functions
    
    @objc private func didTapLogin() {
        guard let username = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        viewModel.login(username: username, password: password)
    }

}

extension LoginViewController: AuthenticationViewModelDelegate {
    func cantLoggedIn() {
        ProgressHUD.showFailed("Username or password is wrong.")
    }
    
    func loggedInSuccesfully() {
        ProgressHUD.showSucceed()
        DispatchQueue.main.async  { [weak self] in
            guard let self = self else { return }
            let vc = UINavigationController(rootViewController: HomeViewController())
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
  
    }
}
