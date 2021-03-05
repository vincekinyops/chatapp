//
//  DBController.swift
//  Chat App
//
//  Created by Lanex-Mark on 3/4/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import UIKit

class DBController {
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    var user: User?
    var backGroundTaskID: UIBackgroundTaskIdentifier?
    
    init() {
        user = Auth.auth().currentUser
        
        // NOTE: force logout the user if it is deleted from firebase console
        if let user = user {
            user.getIDTokenResult(forcingRefresh: true) { (result, error) in
                // TODO: go to signup screen after forcing logout
            }
        }

        Auth.auth().addStateDidChangeListener { (auth, userFound) in
            self.user = userFound

            print("User changed: \(String(describing: userFound))")
        }
    }
    
    func sendMessage(_ message: String, completion: @escaping (_ success: Bool) -> ()) {
        let data = [
            "message": message,
            "username": user?.displayName ?? "this user is a mistake!",
            "date_sent": Date()
        ] as [String : Any]
        
        // send task to background to ensure it finishes
        DispatchQueue.global().async {
            self.backGroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "send message", expirationHandler: {
                UIApplication.shared.endBackgroundTask(self.backGroundTaskID!)
                self.backGroundTaskID = UIBackgroundTaskIdentifier.invalid
            })
            
            self.ref = self.db.collection("chat").addDocument(data: data)
            completion(true)
            UIApplication.shared.endBackgroundTask(self.backGroundTaskID!)
            self.backGroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
    }
    
    func isUserExist(with username: String, completion: @escaping (_ exists: Bool, _ error: Error?) -> ()) {
        
        // Assumption; we just check if query returned contains username
        db.collection("users").whereField("username", isEqualTo: username)
            .getDocuments(completion: { (querySnapshot, error) in
                if let err = error {
                    print("Error getting user: \(err)")
                    completion(false, err)
                } else {
                    completion(true, nil)
                }
            })
    }
    
    func signup(username: String, password: String, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        // NOTE: make dummy email from username just for the purpose of Auth
        let makeEmail = username + "@testchatapp.com"
        Auth.auth().createUser(withEmail: makeEmail, password: password) { [unowned self] (authResult, error) in
            
            if let err = error {
                print("Error adding user: \(err)")
                completion(false, err)
            } else {
                let changeRequest = user!.createProfileChangeRequest()
                changeRequest.displayName = username
                changeRequest.commitChanges { (error) in
                    if let err = error {
                        print("Error adding user: \(err)")
                        completion(false, err)
                        return
                    } else {
                        ref = self.db.collection("users").addDocument(data: [
                            "username": username
                        ]) { err in
                            if let err = err {
                                print("Error adding user: \(err)")
                                completion(false, err)
                            } else {
                                print("User added with ID: \(ref!.documentID)")
                                completion(true, nil)
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    func signin(username: String, password: String, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        let makeEmail = username + "@testchatapp.com"
        Auth.auth().signIn(withEmail: makeEmail, password: password) { authResult, error in
            if error == nil {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    func logout(completion: @escaping (_ success: Bool) -> ()) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch let error {
            print ("Error signing out: %@", error)
            completion(false)
        }
    }
}
