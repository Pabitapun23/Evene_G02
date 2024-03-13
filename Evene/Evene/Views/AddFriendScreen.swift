//
//  AddFriendScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI

struct AddFriendScreen: View {
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @State private var searchText: String = ""
    
    var filteredUsers: [User] {
        if searchText.isEmpty {
            // If searchText is empty, return the empty array
            return []
        } else {
            // Filter the userList based on searchText containing either username or address
            return fireDBHelper.userList.filter { user in
                return user.fullName.localizedCaseInsensitiveContains(searchText) ||
                       user.address.localizedCaseInsensitiveContains(searchText)
            }
        }
    } // filteredUsers

    var body: some View {
        NavigationStack {
            
            VStack {
                List{
                
                    if searchText.isEmpty {
//                        
//                        Image("addFriend")
//                            .resizable()
//                            .frame(width: 400, height: 400)
//                            .aspectRatio(contentMode: .fit)
//                        
//                        Text("Add Friend")
//                        
                    } else if filteredUsers.isEmpty {
                        
                        // Show message when no user or city found
                        Text("No user or city found")
                    } else {
                        ForEach(filteredUsers, id: \.self) { currentUser in
                            NavigationLink(destination: OtherUserProfileScreen(selectedUser: currentUser).environmentObject(self.fireDBHelper)) {
                                VStack(alignment: .leading){
                                    FriendListTile(currentUser: currentUser)
                                } // VStack
                            } // NavigationLink
                        } // ForEach
                        
                    } // if-else-if
                } // List
                .searchable(text: $searchText, prompt: "Search by username or city name")
                
                Spacer()
            } // VStack
            .navigationTitle("Add Friend")
            .onAppear() {
                if let loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") {
                    self.fireDBHelper.getAllOtherUsersFromDB(exceptLoggedInUser: loggedInUserEmail)
                } else {
                    print("Logged in user information not available.")
                }
                        
            
            } // .onAppear
            
        } // NavigationStack
        
    } // body
    
    
    

}

#Preview {
    AddFriendScreen()
}
