//
//  MyEventsScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI

struct MyEventsScreen: View {
    
    @State private var events : [Event] = []
    
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(self.events, id:\.id) { currentEvent in
                        NavigationLink(destination: EventDetailsScreen(selectedEvent: currentEvent)) {
                            EventRowView(currentEvent: currentEvent)
                        }
                    }
                } // List
                
                Spacer()
            } // VStack
            .onAppear {
                self.fireDBHelper.fetchEvents() { events, error in
                    if let events = events {
                        
                        self.events = events
                        
                    } else if let error = error {
                        // Handle the error
                        print("Error fetching events: \(error.localizedDescription)")
                    }
                }
            }
            .padding()
            .navigationTitle("My Events")
            .navigationBarTitleDisplayMode(.inline)
        } // NavigationStack
        
    } // body
    
}

#Preview {
    MyEventsScreen()
}
