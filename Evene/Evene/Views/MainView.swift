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
    @Binding var rootScreen : RootView
    
    var body: some View {
        
        // This shows all the views after authentication
        
        // For now, we have tabview -> for home screeen, profile screen, history screen
        TabView {
            NavigationView {
                HomeScreen()
            } //NavigationView
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
                BookmarkedEventsScreen()
            }
            .tabItem {
                Image(systemName: "bookmark.circle")
                Text("Bookmarks")
            }
            
            NavigationView {
                UserProfileScreen(rootScreen: self.$rootScreen)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
        } // TabView
    } // body
}

//#Preview {
//    MainView(rootScreen: .constant(.Home))
//}
