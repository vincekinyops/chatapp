//
//  SignupViewController.swift
//  Chat App
//
//  Created by Lanex-Mark on 3/3/21.
//

import UIKit

class SignupViewController: BaseViewController, Storyboarded {
    weak var coordinator: SignupCoordinator?
    let placeholderColor = UIColor(named: "placeholderColor") ?? UIColor.systemGray4
    
    @IBOutlet weak var usernameField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    @IBOutlet weak var usernameErrorLbl: UILabel!
    @IBOutlet weak var passwordErrorLbl: UILabel!
    @IBOutlet weak var signupBtn: CustomButtonShape!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var termsLbl: UILabel!
    
    var screenType: ScreenType = .signup
    
    var errorMessage: String = "" {
        didSet {
            if errorMessage.isEmpty {
                
            }
        }
    }
    var showError: Bool = false {
        didSet {
            if showError {
                usernameErrorLbl.isHidden = !showError
                passwordErrorLbl.isHidden = !showError
            }
        }
    }
    
    var didSubmitCredentials: ((_ username: String, _ password: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // underline is set late to give way for border width to get correct width of button
        // button width changes from text width
        loginBtn.addBottomBorderWithColor(color: placeholderColor, width: 1.5)
    }
    
    @IBAction func handleSignup(_ sender: CustomButtonShape) {
        let data = (username: usernameField.text!, password: passwordField.text!)
        
        /// Limit to 8-16 characters only
        func isWithinRange(_ count: Int) -> Bool {
            return (8...16).contains(count)
        }
        
        /// data validation before pass to DB
        let hasNoUsernameError = !data.username.isEmpty && isWithinRange(data.username.count)
        let hasNoPasswordError = !data.password.isEmpty && isWithinRange(data.password.count)
        
        usernameErrorLbl.isHidden = hasNoUsernameError
        passwordErrorLbl.isHidden = hasNoPasswordError
        
        if hasNoUsernameError && hasNoPasswordError {
            
            self.didSubmitCredentials?(data.username, data.password)
            
            //coordinator?.eventOccurred(with: screenType == ScreenType.signup ? .signupProceed : .loginProceed, data: data)
        }
    }
    
    @IBAction func handleLogin(_ sender: UIButton) {
        coordinator?.eventOccurred(with: screenType == ScreenType.signup ? .login : .signup, data: nil)
    }
    
}

// MARK: - SignupVC Design
extension SignupViewController {
    private func initializeUI() {
        //debugPrint(coordinator?.screenType.rawValue as Any)
        
        title = "Chat app"
        screenType = coordinator?.screenType ?? .signup
        // -----
        
        usernameField.setPlaceholderColor("User name", placeholderColor)
        usernameField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        passwordField.setPlaceholderColor("password", placeholderColor)
        passwordField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        
        // -----
        termsLbl.text = AppStrings.terms
        
        // -----
        signupBtn.setTitle(screenType.rawValue , for: .normal)
        loginBtn.setTitle(screenType.oppositeScreentype.rawValue , for: .normal)
        
    }
}

// MARK: - UITextField
extension SignupViewController: UITextFieldDelegate {
    @objc func editingChanged(_ field: UITextField) {
        if field == usernameField && field.text!.isEmpty {
            usernameErrorLbl.isHidden = true
        }
        
        if field == passwordField && field.text!.isEmpty {
            passwordErrorLbl.isHidden = true
        }
    }
}
