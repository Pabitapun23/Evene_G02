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
            VStack(alignment: .leading, spacing: 10) {
                
                Text("HomePage")
                    .font(.title)
                    .fontWeight(.bold)
                    
                // It'll show list of events
                Text("List of Events")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                
                // For EventListScreen
                NavigationLink(destination: EventListScreen()) {
                    Text("EventListScreen")
                } // NavigationLink
                
                Spacer()
            } // VStack
            .padding(.top, 40.0)
            .padding()
//            .navigationTitle("Homepage")
            
        } // NavigationStack
     
    } // body
}

#Preview {
    HomeScreen()
}




