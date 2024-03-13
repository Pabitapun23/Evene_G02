//
//  HomeScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 10) {
                // It'll show list of events
                Text("List of Events")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                
                // For EventListScreen
                NavigationLink(destination: EventListScreen()) {
                    Text("EventListScreen")
                } // NavigationLink
                
                // For EventDetailsScreen
                NavigationLink(destination: EventDetailsScreen()) {
                    // Here, there should be eventListTile
                    Text("EventDetailsScreen")
                } // NavigationLink
                
                // LoginScreen - Just for demo
                NavigationLink(destination: LoginScreen()) {
                    Text("Login Screen")
                } // NavigationLink
                
                // SignUpScreen - Just for demo
                NavigationLink(destination: SignUpScreen()) {
                    Text("Sign Up Screen")
                } // NavigationLink
                
                Spacer()
            } // VStack
            .padding()
            .navigationTitle("Homepage")
            
        } // NavigationStack
     
    } // body
}

#Preview {
    HomeScreen()
}
