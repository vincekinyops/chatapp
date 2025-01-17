//
//  ChatCoordinator.swift
//  Chat App
//
//  Created by Lanex-Mark on 3/3/21.
//

import Foundation
import UIKit

struct Chat {
    var text: String = ""
    var user: String = ""
    var dateSent: Date = Date()
}

class ChatCoordinator: Coordinator {
    weak var parentCoordinator: MainCoordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    var screenType: ScreenType!
    
    var messages: [Chat] = []
    var dbController: DBController!
    
    var onLogout: (() -> ())?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ChatViewController.instantiate()
        vc.coordinator = self
        self.dbController = parentCoordinator?.dbController
        vc.onLogout = {
            self.parentCoordinator?.eventOccurred(with: .logout, data: nil)
            
            self.dbController?.logout(completion: { (success) in
                // logout regardless of success DB action to ensure screen goes back
                //self.onLogout?()
            })
        }
        vc.onSend = { [unowned self] message in
            self.dbController.sendMessage(message, completion: { (success) in
                if success {
                    
                } else {
                    
                }
            })
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func eventOccurred(with type: Event, data: Any?) {
        //
    }
    
    
}
