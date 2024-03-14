//
//  FireAuthHelper.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-11.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

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
                let userInfo = User(firstName: "", lastName: "", fullName: "", email: user.email ?? "", password: "", phoneNumber: "" , address: "", profilePic: URL(string:"https://static.vecteezy.com/system/resources/previews/009/007/039/original/funny-cartoon-woman-face-cute-avatar-or-portrait-girl-with-orange-curly-hair-young-character-for-web-in-flat-style-print-for-sticker-emoji-icon-minimalistic-face-illustration-vector.jpg"), friendList: [], eventList: [])
                self.user = userInfo
            } else {
                self.user = nil
            }
        }
            
    } // func
    
    
    func signUp(user: User, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: user.email, password: user.password) { authResult, error in
            if let error = error {
                completion(error)
            } else if let authResult = authResult {
                // Save user details to Firestore
                let db = Firestore.firestore()
                do {
                    let userDict = try user.toDictionary()
                    try db.collection("users").document(authResult.user.uid).setData(userDict)
                    
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
        
        
    } // signUp
        
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
                
                UserDefaults.standard.set(self.user?.email, forKey: "KEY_EMAIL")
                UserDefaults.standard.set(password, forKey: "KEY_PASSWORD")
            }
        }
        
        

    } // signIn
    
    
    
    func signOut(){
        do {
            try Auth.auth().signOut()
        } catch let err as NSError {
            print(#function, "Unable to sign out the user: \(err)")
        }
    }
}
