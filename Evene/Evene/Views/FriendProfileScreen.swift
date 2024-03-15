//
//  FriendProfileScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-13.
//

import SwiftUI

struct FriendProfileScreen: View {
    //    let selectedUserIndex : Int
    let selectedUser : User
    
    @State private var eventsList : [Event] = []
    @State private var upcomingEvent : Event?
    @State private var totalEvent : Int = 0
    
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @State private var loggedInUserEmail: String? // Define state for loggedInUserEmail
    
    @State private var isUserFriend: Bool = false
    
    @State private var friendsList: [User] = []
    @State private var friendsAttendingUpcomingEvent: [User] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                if let imageURL = selectedUser.profilePic {
                    AsyncImage(url: imageURL){ phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 10)
                                )
                        default:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                        } // switch
                    } // AsyncImage
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                } // if-else
                
                VStack (alignment: .leading, spacing: 10) {
                    Text(selectedUser.fullName)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(.bold)
                    
                    Text("I am attending \(totalEvent) events!")
                    
//                    self.fireDBHelper.fetchEvents(forUser: selectedUser) {
//                        
//                    }
                    
                    if isUserFriend {
                        Button {
                            removeFriend()
                        } label: {
                            Text("UNFRIEND")
                        } // Button
                        .padding(.horizontal, 15.0)
                        .padding(.vertical, 10.0)
                        .background(Color.gray)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                        .cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
                    } else {
                        Button {
                            addFriend()
                        } label: {
                            Text("ADD FRIEND")
                        } // Button
                        .padding(.horizontal, 15.0)
                        .padding(.vertical, 10.0)
                        .background(Color.green)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                        .cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
                    }
                    
                } // VStack
                .padding(.horizontal, 20.0)
                
            } // HStack
            
            Text("\(selectedUser.firstName)'s Next Event:")
                .font(.title2)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(.top, 30)
            Text(upcomingEvent?.eventName ?? "")
            if let event = upcomingEvent {
                            // Format the date
                            let formattedDate = formatEventDate(event.date)
                            
                            // Use the formatted date in a Text view
                            Text(formattedDate)
                        } else {
                            Text("No upcoming event")
                        }
            Text(upcomingEvent?.venue.address ?? "")
            
            Text("Friends who are also attending...")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 20.0)
                .foregroundColor(.green)
            
            List {
                ForEach(friendsAttendingUpcomingEvent, id: \.email) { friend in
                   VStack(alignment: .leading){
                        if let imageURL = friend.profilePic {
                            AsyncImage(url: imageURL){ phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 10)
                                        )
                                default:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                } // switch
                            } // AsyncImage
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                        } // if-else
                        
                        Text(friend.fullName)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                } // ForEach
            } // List
            
            Spacer()
            
        } // VStack
        .padding()
        .navigationTitle("Other User Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Fetch loggedInUserEmail on view appear
            loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL")
            if let loggedInUserEmail = loggedInUserEmail {
                fireDBHelper.getUserFromDB(email: loggedInUserEmail) { user in
                    if var friendList = user?.friendList {
                        if friendList.contains(where: { $0.email == selectedUser.email }) {
                            isUserFriend = true
                        }
                    }
                }
                
                fireDBHelper.fetchUpcomingEvents(forUser: selectedUser.email) { (events, error) in
                    if let error = error {
                        // Handle error
                        print("Error fetching events: \(error)")
                    } else if let events = events {
                        totalEvent = events.count
                        upcomingEvent = events.first
                        getFriendsAttendingEvent()
                        
                    } else {
                        // This block shouldn't be executed, as either events or error should have a value
                        print("Unexpected result: both events and error are nil")
                    }
                }
                
            } else {
                print("Logged-in user email is nil.")
            }
            print("Logged-in user email: \(loggedInUserEmail ?? "nil")")
            
        }
//        .onChange(of: friendsAttendingUpcomingEvent) { _ in
//                        // Refresh the view when friendsAttendingUpcomingEvent is updated
//                    }
        
    } // body
    
    func formatEventDate(_ dateString: String) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

           if let date = dateFormatter.date(from: dateString) {
               dateFormatter.dateFormat = "MMM dd, yyyy , hh:mm a"
               return dateFormatter.string(from: date)
           } else {
               return "Invalid date"
           }
       }
    
    // add friend to my friendlist
    func addFriend() {
        
        print("Add friend button pressed!!!")
        
        
        // Ensure loggedInUserEmail is safely unwrapped
        guard let loggedInUserEmail = loggedInUserEmail else {
            print("Logged-in user email is nil")
            return
        }
        
        self.fireDBHelper.getUserFromDB(email: loggedInUserEmail) { user in
            guard let user = user else {
                print("User not found")
                return
            }
            
            if let friendList = user.friendList {
                if friendList.contains(where: { $0.email == selectedUser.email }) {
                    print("User is already a friend")
                    isUserFriend = true
                } else {
                    var updatedFriendList = friendList
                    updatedFriendList.append(selectedUser)
                    self.updateFriendList(updatedFriendList, for: user)
                    isUserFriend = true
                
                    
                } // if-else
            } else {
            
                var updatedFriendList = [selectedUser]
                self.updateFriendList(updatedFriendList, for: user)
                isUserFriend = true
            } // if-else
        } // fireDBHelper.getUserFromDB
        
    } // func
    
    private func removeFriend() {
        print("Removing friend...")
        print("================")
        print(isUserFriend)

        guard let loggedInUserEmail = loggedInUserEmail else {
            print("Logged-in user email is nil")
            return
        }

        self.fireDBHelper.getUserFromDB(email: loggedInUserEmail) { user in
            guard var user = user else {
                print("User not found")
                return
            }

            print("================")
            print(isUserFriend)
            if var friendList = user.friendList {
                if friendList.contains(where: { $0.email == selectedUser.email }) {
                    // Friend found, remove from friendList
                    friendList.removeAll(where: { $0.email == selectedUser.email })
                    user.friendList = friendList
                    
                    // Update UI
                    isUserFriend = false
                    self.friendsList = friendList

                    
                    // Update friend list in database
                    self.updateFriendList(friendList, for: user)
                    
                    print("================")
                    print(isUserFriend)
                } else {
                    print("User is not a friend")
                    isUserFriend = false
                }
            } else {
                print("No friends found for the user")
                isUserFriend = false
            }
        } // fireDBHelper.getUserFromDB
        
    } // func
    
    private func updateFriendList(_ updatedFriendList: [User], for user: User) {
        var updatedUser = user
        updatedUser.friendList = updatedFriendList
        
        print("================")
        print(isUserFriend)

        // Convert updatedUser to a dictionary
        guard let userDict = try? updatedUser.toDictionary() else {
            print("Error converting user to dictionary")
            return
        }

        // Update user data in Firestore
        fireDBHelper.updateUserInDB(userDictToUpdate: userDict) { error in
            if let error = error {
                print("Error updating user: \(error)")
            } else {
                print("Friend added successfully")
//                isUserFriend = !isUserFriend
                print("================")
                print(isUserFriend)
            }
        }
    }
    
    private func getFriendsAttendingEvent()
    {
        let eventID = upcomingEvent?.id
        guard let loggedInUserEmail = loggedInUserEmail else {
            print("Logged-in user email is nil")
            return
        }
        print(loggedInUserEmail)
        self.fireDBHelper.getUserFromDB(email: loggedInUserEmail) { user in
            guard var user = user else {
                print("User not found")
                return
            }

            if let friendList = user.friendList {
                        for friend in friendList {
                            if (friend.email == selectedUser.email) {
                                continue
                            }
                            
                            fireDBHelper.fetchUpcomingEvents(forUser: friend.email) { (events, error) in
                                if let error = error {
                                    // Handle error
                                    print("Error fetching events: \(error)")
                                } else if let events = events {
                                    // Events successfully fetched, handle events array
                                    for event in events {// Do whatever you need with each event
                                        if (event.id == eventID)  {
                                            friendsAttendingUpcomingEvent.append(friend)
                                        }
                                    }
                                } else {
                                    // This block shouldn't be executed, as either events or error should have a value
                                    print("Unexpected result: both events and error are nil")
                                }
                            }
                        }
                    } else {
                        print("No friends found for the user")
                    }
        }
        
    }
    
    
    
}
//
//#Preview {
//    FriendProfileScreen(selectedUser: User( firstName: "NA", lastName: "NA", fullName: "NA", email: "", password: "", phoneNumber: "", address: "", profilePic: nil, friendList: nil, eventList: nil))
//}
