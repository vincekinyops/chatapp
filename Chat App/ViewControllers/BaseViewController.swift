//
//  BaseViewController.swift
//  Chat App
//
//  Created by Lanex-Mark on 3/3/21.
//

import UIKit

class BaseViewController: UIViewController {
    var shadowImage: UIImage!
    var spinner: SpinnerViewController!
    
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
        hideSpinner()
    }
    
    func showSpinner() {
        spinner = SpinnerViewController()

        // add the spinner view controller
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }

    func hideSpinner() {
        guard spinner != nil else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            // then remove the spinner view controller
            self.spinner.willMove(toParent: nil)
            self.spinner.view.removeFromSuperview()
            self.spinner.removeFromParent()
        }
    }
}
