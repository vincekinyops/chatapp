//
//  SignupCoordinator.swift
//  Chat App
//
//  Created by Lanex-Mark on 3/3/21.
//

import Foundation
import UIKit

class SignupCoordinator: Coordinator {
    weak var parentCoordinator: MainCoordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    var screenType: ScreenType = .signup
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func eventOccurred(with type: Event, data: Any?) {
        switch type {
        case .signupProceed:
            if let data = data as? (username: String, password: String) {
                print("OH YEAH \(data)")
            }
        case .loginProceed:
            self.screenType = .chat
        default:
            parentCoordinator?.eventOccurred(with: type, data: data)
        }
    }
    
    func start() {
        let vc = SignupViewController.instantiate()
        vc.coordinator = self
        vc.didSubmitCredentials = { [unowned self] (username, password) in
            vc.signupBtn.isEnabled = false
            if screenType == .signup {
                self.parentCoordinator?.dbController.signup(username: username, password: password) { [unowned self] (success, error) in
                    vc.signupBtn.isEnabled = true
                    if let err = error {
                        print("Error signing up: \(err)")
                        vc.showError = true
                        return
                    } else {
                        parentCoordinator?.screenType = .chat
                        parentCoordinator?.openChatVC()
                    }
                }
            } else if screenType == .login {
                self.parentCoordinator?.dbController.signin(username: username, password: password, completion: { (success, error) in
                    vc.signupBtn.isEnabled = true
                    if let err = error {
                        print("Error signing in: \(err)")
                        vc.showError = true
                        return
                    } else {
                        vc.showError = false
                        parentCoordinator?.screenType = .chat
                        parentCoordinator?.openChatVC()
                    }
                })
            }
        }
        navigationController.pushViewController(vc, animated: true)
    }
}
