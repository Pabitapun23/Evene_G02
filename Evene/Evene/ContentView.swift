//
//  ContentView.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        // For now, we have login screen, sign up screen and tabview -> for home screeen, profile screen, history screen
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
                MyEventsScreen()
            }
            .tabItem {
                Image(systemName: "bookmark.circle")
                Text("Bookmarks")
            }
            
            NavigationView {
                UserProfileScreen()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            
        }
    }
}

#Preview {
    ContentView()
}
