//
//  UIViewController+Extensions.swift
//  Chat App
//
//  Created by Lanex-Mark on 3/3/21.
//

import UIKit
import NotificationCenter

extension UIViewController {
    
    
    
    /// Hide keyboard on tap of anywhere in the main screen's view
//    func hideKeyboardOnTap() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        
//        // NOTE: important to set to false so gestures wont overlap
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//    
//    @objc fileprivate func dismissKeyboard() {
//        view.endEditing(true)
//    }
    
    func clearNavbar() {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        hideBackButton()
    }
    
    func hideBackButton() {
        self.navigationItem.hidesBackButton = true
    }
    
    func hideNavbarShadow() {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func showNavbarShadow() {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
}
