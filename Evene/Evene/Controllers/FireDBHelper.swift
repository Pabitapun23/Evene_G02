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
    @Published var searchedUserList = [User]()
//    @Published var user : User
    
    private let db : Firestore
    private static var shared : FireDBHelper?
    private let COLLECTION_USER : String = "users"
    private let COLLECTION_Events : String = "Events"
    private let FIELD_FIRSTNAME: String = "firstName"
    private let FIELD_LASTNAME : String = "lastName"
    private let FIELD_FULLNAME : String = "fullName"
    private let FIELD_EMAIL : String = "email"
    private let FIELD_PASSWORD : String = "password"
    private let FIELD_PHONE_NUMBER : String = "phoneNumber"
    private let FIELD_ADDRESS : String = "address"
    private let FIELD_PROFILE_PIC : String = "profilePic"
    private let FIELD_FRIENDLIST : String = "friendList"
    private let FIELD_EVENTLIST : String = "eventList"
    
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
                .addDocument(from: newUser)
        } catch let err as NSError {
            print(#function, "Unable to add document to firestore : \(err)")
        } // do-catch
    } // func
    
    func getUserFromDB(email: String, completion: @escaping (User?) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection(self.COLLECTION_USER).whereField("email", isEqualTo: email)
        print("User reference \(userRef), \(email)")
        
        // Execute the query
        userRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                    return
                }
                print("Document documents: \(documents)")
                for document in documents {
                    // Access the document data
                    let data = document.data()
                    // Handle the data as needed
//                    let id = data.DocumentID as! String
                    var friendList: [User] = []
                    if let friendListData = data["friendList"] as? [[String: Any]] {
                        for friendData in friendListData {
                            do {
                                // Convert friendData dictionary to JSON data
                                let jsonData = try JSONSerialization.data(withJSONObject: friendData, options: [])
                                // Decode JSON data into User object
                                let friendUser = try JSONDecoder().decode(User.self, from: jsonData)
                                friendList.append(friendUser)
                            } catch {
                                print("Error decoding friend user: \(error)")
                            }
                        }
                    }
                    
                    // Parse eventList from Firestore data
                    var eventList: [Event] = []
                    if let eventListData = data["eventList"] as? [[String: Any]] {
                        for eventData in eventListData {
                            do {
                                // Convert eventData dictionary to JSON data
                                let jsonData = try JSONSerialization.data(withJSONObject: eventData, options: [])
                                // Decode JSON data into Event object
                                let event = try JSONDecoder().decode(Event.self, from: jsonData)
                                eventList.append(event)
                            } catch {
                                print("Error decoding event: \(error)")
                            }
                        }
                    }
                    let firstName = data["firstName"] as! String
                    let lastName = data["lastName"] as! String
                    let fullName = data["fullName"] as! String
                    let email = data["email"] as! String
                    let password = data["password"] as! String
                    let phoneNumber = data["phoneNumber"] as! String
                    let address = data["address"] as! String
                    let profilePicString = data["profilePic"] as? String
                    let profilePic: URL?
                    if let profilePicString = profilePicString, let url = URL(string: profilePicString) {
                        profilePic = url
                    } else {
                        profilePic = nil
                    }
                    
                    var user = User(firstName: firstName, lastName: lastName, fullName: fullName, email: email,password: password,phoneNumber: phoneNumber,address: address,profilePic:profilePic, friendList: [], eventList: [])
                    completion(user)
                    return
                }
            }
        }
        return
    } // func
    
    func getAllUsersFromDB() {
        self.db.collection(COLLECTION_USER)
            .addSnapshotListener({ (querySnapshot, error) in
                
                guard let snapshot = querySnapshot else {
                    print(#function, "Unable to retrieve data from firestore : \(String(describing: error))")
                    return
                }
                self.userList.removeAll()
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
    } // func

    
    // func to get all the users from db except the currently logged in user
    func getAllFriendsFromDB(exceptLoggedInUser userEmail: String) {
        self.db.collection(COLLECTION_USER)
            .addSnapshotListener { (querySnapshot, error) in
                guard let snapshot = querySnapshot else {
                    print(#function, "Unable to retrieve data from firestore : \(String(describing: error))")
                    return
                } // guard
                
                // Clear the userList before appending new users
                self.searchedUserList.removeAll()
                
                snapshot.documentChanges.forEach { (docChange) in
                    do {
                        var user: User = try docChange.document.data(as: User.self)
                        user.id = docChange.document.documentID

                        // Check if the user's email is not equal to the current logged-in user's email
                        print("===============")
                        print(user.email)
                        print(userEmail)
                        if user.email != userEmail {
                            let matchedIndex = self.searchedUserList.firstIndex(where: { $0.id == docChange.document.documentID })

                            switch docChange.type {
                            case .added:
                                print(#function, "Document added : \(docChange.document.documentID)")
                                self.searchedUserList.append(user)
                            case .modified:
                                // replace existing object with updated one
                                print(#function, "Document updated : \(docChange.document.documentID)")
                                if let index = matchedIndex {
                                    self.searchedUserList[index] = user
                                }

                            case .removed:
                                // remove object from index in userList
                                print(#function, "Document removed : \(docChange.document.documentID)")
                                if let index = matchedIndex {
                                    self.searchedUserList.remove(at: index)
                                }
                            }
                        }
                    } catch let err as NSError {
                        print(#function, "Unable to convert document into swift object : \(err)")
                    } // do-catch
                } // snapshot
            } // .addSnapshotListener
    } // func

    func getStringFromURL(url: URL, completion: @escaping (String?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            if let string = String(data: data, encoding: .utf8) {
                completion(string)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func updateUserInDB(userDictToUpdate: [String: Any], completion: @escaping (Error?) -> Void) {
        guard let loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") else {
            completion(nil) // Handle error if user is not logged in
            return
        }

        // Query the Firestore collection to find the document with the matching email
        self.db.collection(COLLECTION_USER)
            .whereField("email", isEqualTo: loggedInUserEmail)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    // Handle error
                    completion(error)
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    // Handle no documents found
                    let noDocumentError = NSError(domain: "Firestore", code: 1, userInfo: [NSLocalizedDescriptionKey: "No document found"])
                    completion(noDocumentError)
                    return
                }

                // There should be only one document for a given email
                guard let document = documents.first else {
                    // Handle no document found
                    let noDocumentError = NSError(domain: "Firestore", code: 1, userInfo: [NSLocalizedDescriptionKey: "No document found"])
                    completion(noDocumentError)
                    return
                }

                // Update the document with the provided data
                document.reference.updateData(userDictToUpdate) { error in
                    completion(error)
                }
            }
    }
    
}
