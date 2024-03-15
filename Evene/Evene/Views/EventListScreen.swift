//
//  EventListScreen.swift
//  Evene
//
//  Created by Alfie on 2024-03-09.
//

import SwiftUI

struct EventListScreen: View {

    @ObservedObject var eventApiManager = EventAPIManager()
    @State private var searchText: String = ""
    @StateObject var locationManager = LocationManager()
    @State private var showNearbyEvents = false

    private var filteredEvents: [Event] {
        if searchText.isEmpty {
            return eventApiManager.eventsList
        } else {
            return eventApiManager.eventsList.filter { $0.venue.city.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {

        NavigationStack {
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                    TextField("Search by city", text: $searchText)
                        .padding(.horizontal, 10)
                }
                .frame(height: 50)
                .background(Color(.systemGray6))
                .cornerRadius(25)

//                Button(action: {
//                    showNearbyEvents.toggle()
//                    if showNearbyEvents {
//                        if let latitude = locationManager.latitude, let longitude = locationManager.longitude {
//                            print("latitude: \(latitude), longitude: \(longitude)")
//                            self.eventApiManager.loadDataFromAPI(lat: latitude, lon: longitude)
//                        } else {
//                            print("Unable to retrieve device location")
//                        }
//                    }
//                }) {
//                    Text("Show Nearby Events")
//                }

                List {
                    ForEach(showNearbyEvents ? self.filteredEvents : eventApiManager.eventsList, id: \.id) { currentEvent in
                        NavigationLink(destination: EventDetailsScreen(selectedEvent: currentEvent)) {
                            EventRowView(currentEvent: currentEvent)
                        }
                    }
                }
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
}


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
