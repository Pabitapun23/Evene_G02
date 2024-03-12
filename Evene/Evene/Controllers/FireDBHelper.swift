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
    }
    
    
}
