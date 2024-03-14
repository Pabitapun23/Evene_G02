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
    
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @State private var loggedInUserEmail: String? // Define state for loggedInUserEmail
    
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
                    
                    Text("I am attending 10 events!")
                    
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
                    
                } // VStack
                .padding(.horizontal, 20.0)
                
            } // HStack
            
            Text("\(selectedUser.firstName)'s Next Event:")
                .font(.title2)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(.top, 30)
            Text("Edmonton Stingers vs Montreal Alliance \nJune 25, 4:00 PM, Olympic Stadium, Montreal")
            
            Spacer()
            
        } // VStack
        .padding()
        .navigationTitle("Other User Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Fetch loggedInUserEmail on view appear
            loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL")
            print("Logged-in user email: \(loggedInUserEmail ?? "nil")")
            
            
            
        }
        
    } // body
    
    // add friend to my friendlist
    func addFriend() {
        
        print("Add friend button pressed!!!")
        
        //        print(fireDBHelper.searchedUserList)
//        print(fireDBHelper.userList)
        
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
                    } else {
                        var updatedFriendList = friendList
                        updatedFriendList.append(selectedUser)
                        self.updateFriendList(updatedFriendList, for: user)
                    }
                } else {
                    var updatedFriendList = [selectedUser]
                    self.updateFriendList(updatedFriendList, for: user)
                }
            }
        
    } // func
    
    private func updateFriendList(_ updatedFriendList: [User], for user: User) {
        var updatedUser = user
        updatedUser.friendList = updatedFriendList

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
            }
        }
    }
    
}

#Preview {
    FriendProfileScreen(selectedUser: User( firstName: "NA", lastName: "NA", fullName: "NA", email: "", password: "", phoneNumber: "", address: "", profilePic: nil, friendList: nil, eventList: nil))
}