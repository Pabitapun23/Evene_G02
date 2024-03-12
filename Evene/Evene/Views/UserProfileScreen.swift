//
//  UserProfileScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI

struct UserProfileScreen: View {
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    @Binding var rootScreen : RootView
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Text("User info")
                
                NavigationLink(destination: MyFriendListScreen()) {
                    Text("My Friend List")
                } // NavigationLink
                
                Button(action: {
                    self.fireAuthHelper.signOut()
                    self.rootScreen = .Login
                }) {
                    Text("Sign Out")
                }
                
                Spacer()
            } // VStack
            .padding()
            .navigationTitle("Profile")
            
        } // NavigationStack
        
    } // body
}

#Preview {
    UserProfileScreen(rootScreen: .constant(.Home))
}
