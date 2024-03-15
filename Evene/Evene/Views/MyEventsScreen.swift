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
//                    .onDelete(perform: deleteEvent)
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
    
    // Swipe to delete action
//        private func deleteEvent(at offsets: IndexSet) {
//            offsets.forEach { index in
//                // Get the ID of the event to delete
//                if let eventID = events[index].id {
//                    // Call the function to delete the event from Firestore
//                    fireDBHelper.deleteEvent(eventID: eventID) { error in
//                        if let error = error {
//                            // Handle any errors
//                            print("Error deleting event: \(error.localizedDescription)")
//                        } else {
//                            // Remove the event from the local array to update UI
//                            events.remove(atOffsets: offsets)
//                        }
//                    }
//                }
//            }
//        }
}

#Preview {
    MyEventsScreen()
}
