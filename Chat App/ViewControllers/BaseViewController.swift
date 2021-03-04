//
//  BaseViewController.swift
//  Chat App
//
//  Created by Lanex-Mark on 3/3/21.
//

import UIKit

class BaseViewController: UIViewController {
    var shadowImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideBackButton()
        //hideKeyboardOnTap() // dismiss keyboard on tap outside textfields
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavbarShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideNavbarShadow()
    }

}
