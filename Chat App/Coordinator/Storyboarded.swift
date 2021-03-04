//
//  Storyboarded.swift
//  Coordinator
//
//  Created by Lanex-Mark on 3/3/21.
//

import Foundation
import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    
    /// Called by ViewController extending this protocol returning ViewController instance
    /// - Returns: ViewController
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
