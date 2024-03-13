//
//  FireDBHelper.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-11.
//

import Foundation
import FirebaseFirestore

class FireDBHelper : ObservableObject {
//    @Published var eventsList = [Event]()
    @Published var userList = [User]()
    @Published var friendList = [User]()
    
    private let db : Firestore
    private static var shared : FireDBHelper?
    private let COLLECTION_USER : String = "User"
    private let COLLECTION_Events : String = "Events"
    private let FIELD_FULLNAME : String = "fullName"
    private let FIELD_EMAIL : String = "email"
    private let FIELD_PASSWORD : String = "password"
    private let FIELD_PHONE_NUMBER : String = "phoneNumber"
    private let FIELD_ADDRESS : String = "address"
    private let FIELD_PROFILE_PIC : String = "profilePic"
    
    init(db : Firestore) {
        self.db = db
    }
    
    static func getInstance() -> FireDBHelper {
        if (shared == nil) {
            shared = FireDBHelper(db: Firestore.firestore())
        }
        return shared!
    }
    
    func addUserToDB(newUser : User) {
        do {
            try self.db
                .collection(COLLECTION_USER)
//                    .document(loggedInUserEmail)
//                    .collection(COLLECTION_Events)
                .addDocument(from: newUser)
        } catch let err as NSError {
            print(#function, "Unable to add document to firestore : \(err)")
        } // do-catch
    } // func
    
    func getAllUsersFromDB() {
        
//        let loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""
//        
//        if (loggedInUserEmail.isEmpty) {
//            print(#function, "Logged in user information not available. Can't add the book")
//        } else {
            
            self.db.collection(COLLECTION_USER)
//                .document(loggedInUserEmail)
//                .collection(COLLECTION_Events)
                .addSnapshotListener({ (querySnapshot, error) in
                    
                    guard let snapshot = querySnapshot else {
                        print(#function, "Unable to retrieve data from firestore : \(error)")
                        return
                    }
                    
                    snapshot.documentChanges.forEach{ (docChange) in
                        
                        do {
                            
                            var user : User = try docChange.document.data(as: User.self)
                            user.id = docChange.document.documentID
                            
                            let matchedIndex = self.userList.firstIndex(where: {($0.id?.elementsEqual(docChange.document.documentID))!})
                            
                            switch(docChange.type) {
                            case .added:
                                print(#function, "Document added : \(docChange.document.documentID)")
                                self.userList.append(user)
                            case .modified:
                                // replace existing object with updated one
                                print(#function, "Document updated : \(docChange.document.documentID)")
                                if (matchedIndex != nil) {
                                    self.userList[matchedIndex!] = user
                                }
                                
                            case .removed:
                                // remove object from index in bookList
                                print(#function, "Document removed : \(docChange.document.documentID)")
                                if (matchedIndex != nil) {
                                    self.userList.remove(at: matchedIndex!)
                                }
                            }
                            
                        } catch let err as NSError {
                            print(#function, "Unable to convert document into swift object : \(err)")
                        }
                        
                    } // ForEach
                }) // addSnapshotListener
//        } // if-else

        
    } // func
    
}
