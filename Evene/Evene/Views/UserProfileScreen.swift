//
//  UserProfileScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI

struct UserProfileScreen: View {
    var body: some View {
        NavigationStack {
            
            VStack {
                Text("User info")
                
                NavigationLink(destination: MyFriendListScreen()) {
                    Text("My Friend List")
                } // NavigationLink
                
                
                Spacer()
            } // VStack
            .padding()
            .navigationTitle("Profile")
            
        } // NavigationStack
        
    } // body
}

#Preview {
    UserProfileScreen()
}
