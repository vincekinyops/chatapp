//
//  MainViewController.swift
//  Chat App
//
//  Created by Lanex-Mark on 3/3/21.
//

import UIKit

class MainViewController: UIViewController, Storyboarded {
    var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearNavbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavbarShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavbarShadow()
    }

    @IBAction func handleOpenSignup(_ sender: CustomButtonShape) {
        coordinator?.eventOccurred(with: .signup, data: nil)
    }
    
    @IBAction func handleOpenLogin(_ sender: CustomButtonShape) {
        coordinator?.eventOccurred(with: .login, data: nil)
    }
}

