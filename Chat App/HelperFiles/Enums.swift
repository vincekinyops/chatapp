//
//  Enums.swift
//  Chat App
//
//  Created by Lanex-Mark on 3/4/21.
//

enum ScreenType: String {
    case signup = "Sign up"
    case login = "Login"
    case chat = "Chat"
    
    var oppositeScreentype: ScreenType {
        return self == .signup ? .login : .signup
    }
}

enum Event {
    case none
    case signup
    case login
    case signupProceed
    case loginProceed
    case logout
}


