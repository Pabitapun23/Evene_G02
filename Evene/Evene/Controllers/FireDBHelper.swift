//
//  FireDBHelper.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-11.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class FireDBHelper : ObservableObject {
    @Published var eventsList = [Event]()
    @Published var userList = [User]()
//    @Published var friendList = [User]()
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
    
    func insertEvent(newEvent: Event) {
        let db = Firestore.firestore()
        let loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""
        let usersCollectionRef = db.collection(self.COLLECTION_USER)
        
        // Query the user based on email
        usersCollectionRef.whereField("email", isEqualTo: loggedInUserEmail).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting user documents: \(error)")
                return
            }
            
            guard let userDocument = querySnapshot?.documents.first else {
                print("User not found")
                return
            }
            
            let userID = userDocument.documentID
            
            do {
                try usersCollectionRef.document(userID).collection(self.COLLECTION_Events).addDocument(from: newEvent)
            } catch let error {
                print("Unable to add document to firestore: \(error)")
            }
        }
    }

    
    func fetchEvents(forUser userEmail: String, completion: @escaping ([Event]?, Error?) -> Void) {
        let db = Firestore.firestore()
        let usersCollectionRef = db.collection("users")

        // Query the user based on email
        usersCollectionRef.whereField("email", isEqualTo: userEmail).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting user documents: \(error)")
                completion(nil, error)
                return
            }
            
            // Assuming there is only one user with this email
            guard let userDocument = querySnapshot?.documents.first else {
                print("User not found")
                completion(nil, NSError(domain: "App", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"]))
                return
            }
            
            let userID = userDocument.documentID
            
            // Fetch events from the user's event subcollection
            let eventsRef = usersCollectionRef.document(userID).collection(self.COLLECTION_Events)
            eventsRef.getDocuments { (eventSnapshot, error) in
                if let error = error {
                    print("Error fetching events: \(error)")
                    completion(nil, error)
                    return
                }
                
                let events = eventSnapshot?.documents.compactMap { document -> Event? in
                    try? document.data(as: Event.self)
                }
                completion(events, nil)
            }
        }
    }
    
    func fetchUpcomingEvent(forUser userEmail: String, completion: @escaping (Event?, Error?) -> Void) {
        let db = Firestore.firestore()
        let usersCollectionRef = db.collection("users")
        print("------")
        print(userEmail)

        // Query the user based on email
        usersCollectionRef.whereField("email", isEqualTo: userEmail).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting user documents: \(error)")
                completion(nil, error)
                return
            }
            
            // Assuming there is only one user with this email
            guard let userDocument = querySnapshot?.documents.first else {
                print("User not found")
                completion(nil, NSError(domain: "App", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"]))
                return
            }
            
            let userID = userDocument.documentID
            
            // Fetch upcoming event from the user's event subcollection
            let eventsRef = usersCollectionRef.document(userID).collection(self.COLLECTION_Events)
            let now = Timestamp(date: Date())
            print("######")
            print(now)
            eventsRef.whereField("datetime_local", isGreaterThanOrEqualTo: now).order(by: "datetime_local").limit(to: 1).getDocuments { (eventSnapshot, error) in
                if let error = error {
                    print("Error fetching upcoming event: \(error)")
                    completion(nil, error)
                    return
                }
                
                guard let document = eventSnapshot?.documents.first else {
                    // No upcoming events found
                    completion(nil, nil)
                    return
                }
                
                if let event = try? document.data(as: Event.self) {
                    completion(event, nil)
                } else {
                    print("Failed to parse event data")
                    completion(nil, NSError(domain: "App", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to parse event data"]))
                }
            }
        }
    }

    
    // func to add user to database
    func addUserToDB(newUser : User) {
        do {
            try self.db
                .collection(COLLECTION_USER)
                .addDocument(from: newUser)
        } catch let err as NSError {
            print(#function, "Unable to add document to firestore : \(err)")
        } // do-catch
    } // func
    
    // func to get single user from DB
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
                    let data = document.data()
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
                    
                    // Create the user object
                    var user = User(firstName: firstName, lastName: lastName, fullName: fullName, email: email, password: password, phoneNumber: phoneNumber, address: address, profilePic: profilePic, friendList: [], eventList: [])
                    
                    
                    
                    // Parse friendList
                    if var friendListData = data["friendList"] as? [[String: Any]] {
                        var friendList: [User] = []
                        for friendData in friendListData {
                            
                            let profilePicString = friendData["profilePic"] as? String
                            let profilePic: URL?
                            if let profilePicString = profilePicString, let url = URL(string: profilePicString) {
                                profilePic = url
                            } else {
                                profilePic = nil
                            }
                            
//                            var friendPassword = friendData["password"] as! String
//                            friendPassword.removeAll()
                            
//                            print("____________ \(friendPassword)")
                            // Decode each friend's data
                            let friend = User(firstName: friendData["firstName"] as! String,
                                              lastName: friendData["lastName"] as! String,
                                              fullName: friendData["fullName"] as! String,
                                              email: friendData["email"] as! String,
//                                              password: friendData["password"] as! String,
                                              password: "",
                                              phoneNumber: friendData["phoneNumber"] as! String,
                                              address: friendData["address"] as! String,
                                              profilePic: profilePic,
                                              friendList: nil, // Since friend list of a friend is not required here
                                              eventList: []) // Similarly, event list is not required for a friend
                            friendList.append(friend)
                        } // for
                        
                        
                        user.friendList = friendList
                    }
                    
                    // Call completion handler with the user object
                    completion(user)
                    return
                } // for
            }
        }
        return
    } // func
    
    // func to get all the users from DB
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
    
    // func to update user in DB
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
    
    // func to remove friend from user's friendList
    func removeFriend(from userEmail: String, friendEmail: String, completion: @escaping (Bool) -> Void) {
            let db = Firestore.firestore()
        let userRef = db.collection(self.COLLECTION_USER).whereField("email", isEqualTo: userEmail)
        print("User reference \(userRef), \(userEmail), \(friendEmail)")
            
        userRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("test2")
                print("Error getting user document: \(error)")
                completion(false)
                return
            } else {
                print("test1")
                
                
                
                 print("_______________")
                guard let documents = querySnapshot?.documents else {
                    print("test3")
                    print("User document does not exist")
                    completion(false)
                    return
                }
                for document in documents {
                    print(document)
                    print("+++++++++")
                    print(document.data())
                    
                    print("_______________")
                    let data = document.data()
                    var updatedFriendList = data["friendList"] as? [[String: Any]] ?? []
                    
                    print("Before removal:")
                    print(updatedFriendList)

                    updatedFriendList.removeAll { friendData in
                        if let email = friendData["email"] as? String {
                            print("Comparing \(email) with \(friendEmail)")
                            return email == friendEmail
                        } else {
                            return false
                        }
                    }

                    print("After removal:")
                    print(updatedFriendList)
                    
                    document.reference.updateData(["friendList": updatedFriendList]) { error in
                        print("_______________")
                        print(updatedFriendList)
                        if let error = error {
                            print("Error updating friend list: \(error)")
                            completion(false)
                        } else {
                            print("Friend removed successfully")
                            completion(true)
                        }
                    }
                }
            }
            }
        }
    
    func uploadImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let storageRef = Storage.storage().reference().child("profilePictures/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard metadata != nil else {
                completion(.failure(error ?? URLError(.cannotCreateFile)))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let url = url {
                    completion(.success(url))
                } else {
                    completion(.failure(error ?? URLError(.cannotOpenFile)))
                }
            }
        }
    }
    
    func saveProfilePictureURL(_ url: URL, forUser userEmail: String) {
        let db = Firestore.firestore()
        // Assuming you find the user by their email. Adjust according to your actual user identification logic.
        db.collection(COLLECTION_USER).whereField("email", isEqualTo: userEmail).getDocuments { (querySnapshot, error) in
            guard let document = querySnapshot?.documents.first else {
                print("User document not found.")
                return
            }
            let userID = document.documentID
            let userRef = db.collection(self.COLLECTION_USER).document(userID)
            userRef.updateData(["profilePic": url.absoluteString]) { error in // Convert URL to String
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Profile picture URL successfully updated.")
                }
            }
        }
    }
}
