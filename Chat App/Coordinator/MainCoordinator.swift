//
//  MainCoordinator.swift
//  Coordinator
//
//  Created by Lanex-Mark on 3/3/21.
//

import Foundation
import UIKit
import Firebase

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var screenType: ScreenType = .signup
    var dbController: DBController!
    
    init(navController: UINavigationController) {
        self.navigationController = navController
        dbController = DBController()
    }
    
    func start() {
        navigationController.delegate = self
        let vc = MainViewController.instantiate()
        vc.coordinator = self
        
        if dbController.user != nil {
            // user is signed in, proceed to chat
            self.screenType = .chat
            openChatVC()
        } else {
            navigationController.pushViewController(vc, animated: false)
        }
    }
    
    func openSignupVC() {
        let child = SignupCoordinator(navigationController: navigationController)
        child.screenType = self.screenType
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    func openChatVC() {
        let child = ChatCoordinator(navigationController: navigationController)
        child.screenType = self.screenType
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.onLogout = {
            print("Log out, proceed to signup screen")
            self.screenType = ScreenType.signup
            self.openSignupVC()
        }
        child.start()
    }
    
    // remove from array to avoid memory leak
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    // remove VCs from, special case due to reusing of SignupVC for login
    func removeDuplicateVC(_ viewController: UIViewController) {
        for (index, vc) in navigationController.viewControllers.enumerated() {
            if vc === viewController {
                navigationController.viewControllers.remove(at: index)
                break
            }
        }
    }
    
    // Handle child coordinator events here
    func eventOccurred(with type: Event, data: Any?) {
        switch type {
        case .signup:
            self.screenType = ScreenType.signup
        case .login:
            self.screenType = ScreenType.login
        case .logout:
            self.screenType = ScreenType.signup
        default:
            return
        }
        
        // assumption due to screen flows, that signup vc is the final screen
        openSignupVC()
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        fromViewController.view.endEditing(true)
        
        if navigationController.viewControllers.contains(fromViewController) {
            
            // NOTE: special case for reusing of SignupVC, must remove previous instances to avoid memory loop bug
//            if let signupVC = fromViewController as? SignupViewController {
//                removeDuplicateVC(signupVC)
//                childDidFinish(signupVC.coordinator)
//            }
            return
        }
        
        if let signupVC = fromViewController as? SignupViewController {
            childDidFinish(signupVC.coordinator)
        }
    }
}
