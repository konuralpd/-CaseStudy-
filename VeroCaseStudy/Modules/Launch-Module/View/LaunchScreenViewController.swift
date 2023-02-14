//
//  LaunchScreenViewController.swift
//  VeroCaseStudy
//
//  Created by Mac on 7.02.2023.
//

import UIKit
import Foundation

class LaunchScreenViewController: UIViewController {

    private let launchScreenLogoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "appLogo")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        stopLaunchScreenGoLogin()
    }
    
    private func makeUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(launchScreenLogoImageView)
        
        NSLayoutConstraint.activate([
            launchScreenLogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            launchScreenLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            launchScreenLogoImageView.heightAnchor.constraint(equalToConstant: 168),
            launchScreenLogoImageView.widthAnchor.constraint(equalToConstant: 256)
        ])
        animateLaunchLogo()
    }
    
    private func animateLaunchLogo() { //Smooth animation 
        UIView.animate(withDuration: 2, delay: 1, options: [.curveEaseInOut], animations: {
            self.launchScreenLogoImageView.transform = CGAffineTransform(translationX: 0, y: -(UIScreen.main.bounds.height / 2))
        }) { _ in
            self.launchScreenLogoImageView.transform = .identity
        }
    
    }
    
    private func stopLaunchScreenGoLogin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7){
            let vc = LoginViewController()
            let transition:CATransition = CATransition()
            transition.duration = 1
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.fade
            transition.subtype = CATransitionSubtype.fromTop
            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }

}


