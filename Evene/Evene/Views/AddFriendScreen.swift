//
//  AddFriendScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI

struct AddFriendScreen: View {
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    @Binding var rootScreen : RootView
//    var user: User
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Text("Shows list of other users")
                List{
                    
                }
                
                NavigationLink(destination: OtherUserProfileScreen()) {
                    FriendListTile()
                } // NavigationLink
                
                NavigationLink(destination: OtherUserProfileScreen()) {
                    Text("Other user profile")
                } // NavigationLink
                
                
                Spacer()
            } // VStack
            .padding()
            .navigationTitle("Add Friend")
            
        } // NavigationStack
    }
}

//#Preview {
//    AddFriendScreen()
//}
