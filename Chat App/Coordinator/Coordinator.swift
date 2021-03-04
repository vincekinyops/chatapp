//
//  Coordinator.swift
//  Coordinator
//
//  Created by Lanex-Mark on 3/3/21.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController {get set}
    var childCoordinators: [Coordinator] {get set}
    
    func start()
    
    func eventOccurred(with type: Event, data: Any?)
}

protocol Coordinating {
    var coordinator: Coordinator? {get set}
}
