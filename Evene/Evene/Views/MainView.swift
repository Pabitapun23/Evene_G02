//
//  MainView.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-11.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper

    @Binding var isLoggedIn: Bool
    
    var body: some View {
        
        // This shows all the views after authentication
        
        if isLoggedIn {
            TabView {
                NavigationView {
                    HomeScreen()
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                
                NavigationView {
                    MyEventsScreen()
                }
                .tabItem {
                    Image(systemName: "calendar")
                    Text("My Events")
                }
                
                
                NavigationView {
                    AddFriendScreen()
                }
                .tabItem {
                    Image(systemName: "person.fill.badge.plus")
                    Text("Add Friends")
                }
                
                NavigationView {
                    UserProfileScreen(isLoggedIn: $isLoggedIn)
                }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
            } // TabView
                
        } // isLoggedIn
        
    } // body
}

#Preview {
    MainView(isLoggedIn: .constant(true))
}
