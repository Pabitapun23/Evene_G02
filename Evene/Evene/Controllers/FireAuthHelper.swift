//
//  FireAuthHelper.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-11.
//

import Foundation
import FirebaseAuth

class FireAuthHelper : ObservableObject {
    
    @Published var user : User? {
        // manually keep track if any object change
        didSet {
            objectWillChange.send()
        } // didSet
    } // user
    
    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            
            if let user = user {
//                let userInfo = User(name: "", email: user.email ?? "", password: "", phoneNumber: "" , address: UserAddress(address: "", lat: 0.0, lng: 0.0), profilePic: nil)
                let userInfo = User(name: "", email: user.email ?? "", password: "", phoneNumber: "" , address: "", profilePic: nil)
                self.user = userInfo
            } else {
                self.user = nil
            }
        }
            
    }
    
//    func signUp(fullName: String, email: String, password: String, phoneNumber: String, address: String) {
    func signUp(fullName: String, email: String, password: String, phoneNumber: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating user:", error.localizedDescription)
                // Handle error
                return
            }
            
            guard let user = authResult?.user else {
                print("User object is nil after sign up.")
                // Handle unexpected situation
                return
            }
            
            // Successful sign up
            print("User signed up successfully:", user.uid)
            
            // Update user info in database or perform other actions
            
            
        }
            
    }
        
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [self] authResult, error in
            guard let result = authResult else {
                print(#function, "ERROR while signing in: \(error)")
                return
            }
            
            print(#function, "AuthResult : \(result)")
            
            switch authResult {
            case .none:
                print(#function, "Unable to sign in")
            case .some:
                print(#function, "Login Successful")
//                    self.user = authResult?.user
                
//                let userInfo = User(name: "", email: user?.email ?? "", password: "", phoneNumber: "" , address: UserAddress(address: "", lat: 0.0, lng: 0.0), profilePic: nil)
                let userInfo = User(name: "", email: user?.email ?? "", password: "", phoneNumber: "" , address: "", profilePic: nil)
                self.user = userInfo
                print(#function, "Logged in user : \(self.user?.name ?? "NA" )")
                
                UserDefaults.standard.set(email, forKey: "KEY_EMAIL")
                UserDefaults.standard.set(password, forKey: "KEY_PASSWORD")
            }
            
        }
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
        } catch let err as NSError {
            print(#function, "Unable to sign out the user: \(err)")
        }
    }
}
