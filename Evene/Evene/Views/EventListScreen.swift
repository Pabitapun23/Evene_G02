//
//  EventListScreen.swift
//  Evene
//
//  Created by Alfie Pun on 2024-03-09.
//

import SwiftUI

struct EventListScreen: View {

    @ObservedObject var eventApiManager = EventAPIManager()

    // TODO: use mapview or listview for filter event?
    //    @State private var selectedCity = "Toronto"
    //    let cities = ["Toronto", "Vancouver"]

    var body: some View {

        NavigationStack {
            VStack(spacing: 10) {

//                TODO: Update Data?
//                Button {
//                    loadDataFromAPI()
//                } label: {
//                    Text("Get Data!")
//                }

                // TODO: Search by city
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(.systemGray6))
                    .frame(width: 200, height: 50)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .fontWeight(.bold)
                            Spacer()
//                            Picker("Please choose a city", selection: $selectedCity) {
//                                ForEach(cities, id: \.self) {
//                                    Text($0)
//                                }
//                            }
//                                .accentColor(Color.yellow)
                        }
                        .padding(.leading, 20)
                    )// end of search overlay

                // list to display data
                List {
                    ForEach(self.eventApiManager.eventsList, id:\.id) { currentEvent in
                        NavigationLink(destination: EventDetailsScreen(selectedEvent: currentEvent)) {
                            EventRowView(currentEvent: currentEvent)
                        }
                    }
                    
                } // List
            } // VStack

            Spacer()
        }

        .listStyle(.inset)
        .navigationTitle("All Events")
        .padding()
        .onAppear {
            self.eventApiManager.loadDataFromAPI()
        }
    }   // end body
} // end ContentView struct


struct EventRowView: View {
    let currentEvent: Event

    var body: some View {
        HStack {
                    // images
                    AsyncImage(url: URL(string: currentEvent.performers[0].image)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                        case .failure:
                            Image(systemName: "photo") // display default image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                        @unknown default:
                            EmptyView()
                        }
                    }

                    // text
                    VStack(alignment: .leading, spacing: 4) {
                        Text(currentEvent.eventName)
                            .font(.headline)
                        Text(currentEvent.type)
                            .font(.subheadline)
                        Text(currentEvent.date)
                            .font(.subheadline)
                        Text(currentEvent.venue.city)
                            .font(.subheadline)
                    }

                    Spacer()
                }
                .padding(.vertical, 8)
    }
}
