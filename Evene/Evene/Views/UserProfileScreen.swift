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
    
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Text("User info")
                
                NavigationLink(destination: MyFriendListScreen()) {
                    Text("My Friend List")
                } // NavigationLink
                
                Button(action: {
                    self.fireAuthHelper.signOut()
//                    self.rootScreen = .Login
                    
                    isLoggedIn = false
                    
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
    UserProfileScreen(isLoggedIn: .constant(true))
}
