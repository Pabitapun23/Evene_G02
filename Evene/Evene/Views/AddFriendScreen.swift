//
//  AddFriendScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI

struct AddFriendScreen: View {
    var body: some View {
        NavigationStack {
            
            VStack {
                Text("Shows list of other users")
                
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

#Preview {
    AddFriendScreen()
}
