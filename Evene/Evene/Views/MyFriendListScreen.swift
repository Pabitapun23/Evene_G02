//
//  MyFriendListScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI

struct MyFriendListScreen: View {
    
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @State private var loggedInUserEmail: String? 
    @State private var friendsList: [User] = [] // State variable to hold the friend list
    @State private var isEditing = false // Add state variable to track edit mode
//    @State private var upcomingEvent : Event
    
    var body: some View {
        VStack {
            Text("My Friend List")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
         
            List {
                ForEach(friendsList, id: \.email) { currentFriend in
                    NavigationLink(destination: FriendProfileScreen(selectedUser: currentFriend).environmentObject(self.fireDBHelper)) {
                        FriendListTile(currentFriend: currentFriend)
                    } // NavigationLink
                } // ForEach
                .onDelete(perform: deleteFriend)
            } // List
            .environment(\.editMode, .constant(isEditing ? EditMode.active : EditMode.inactive)) // Enable edit mode
            
            Spacer()
        } // VStack
        .onAppear() {
            // Fetch loggedInUserEmail on view appear
            loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL")
            
            if let loggedInUserEmail = loggedInUserEmail {
                fireDBHelper.getUserFromDB(email: loggedInUserEmail) { user in
                    if let friendList = user?.friendList {
                        print("test")
                        self.friendsList = friendList // Update the state variable with friendList data
                        print("\(self.friendsList)")
                        print(friendList)
                    } else {
                        print("Failed to retrieve friend list.")
                    }
                }
            } else {
                print("Logged-in user email is nil.")
            }
        } // .onAppear
        
        
        
    } // body
    
    func deleteFriend(at offsets: IndexSet) {
        
        print("deleting......")
        guard let loggedInUserEmail = loggedInUserEmail else {
            return
        }
    
        print("+________________++++++")
        print(loggedInUserEmail)
        
        var updatedFriendsList = friendsList
        offsets.forEach { index in
            let friendToRemove = updatedFriendsList.remove(at: index)
            
            print("+________________")
            print("Friend to remove: \(friendToRemove.fullName)")
            
            print("\(friendToRemove.email)")
            print("+________________")
            // Update the friend list in the database
            fireDBHelper.removeFriend(from: loggedInUserEmail, friendEmail: friendToRemove.email) { success in
                if success {
                    print("Friend removed successfully")
                } else {
                    print("Failed to remove friend")
                    // Revert the changes if removing the friend fails
                    updatedFriendsList.insert(friendToRemove, at: index)
                }
            }
        }
        // Update the local state variable after deleting the friend
        friendsList = updatedFriendsList
        print(friendsList)
            
    } // func
}

#Preview {
    MyFriendListScreen()
}
