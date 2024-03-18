//
//  EventDetailsScreen.swift
//  Evene
//
//  Created by Alfie on 2024-03-13.
//

import SwiftUI
import MapKit

struct EventDetailsScreen: View {
    
    let selectedEvent : Event
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.openURL) private var openURL
    
    @State private var coordinates: CLLocationCoordinate2D?
    @EnvironmentObject var locationHelper: LocationHelper
  
  
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            
            HeaderPhotoView(photo: selectedEvent.performers[0].image)
            
            VStack(alignment: .leading, spacing: 15) {
                
                // DONE: Event Name
                Text("Event")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Text("Name: \(selectedEvent.eventName)")
                Text("Type: \(selectedEvent.type)")
                    
                Divider()
                    .frame(height: 1)
                    .overlay(Color(hue: 1.0, saturation: 0.0, brightness: 0.781))
                
                // DONE: Event Host
                Text("Description")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                Text("Host By: \(selectedEvent.venue.name)")
                Text("Date: \(selectedEvent.date)")
                Text("Location: \(selectedEvent.venue.address), \(selectedEvent.venue.city)")
                        
                
                // DONE: MapView
                if let coordinates = coordinates {
                    MyMap(coordinates: coordinates)
                        .frame(height: 300)
                } else {
                    Text("Loading map...")
                }
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color(hue: 1.0, saturation: 0.0, brightness: 0.781))
                
                // DONE: Performer Name
                Text("Performer")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Name: \(selectedEvent.performers[0].name)").font(.body)
                
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color(hue: 1.0, saturation: 0.0, brightness: 0.781))
                
                // DONE: Event Price
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Price")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Average Price: \(selectedEvent.stats.averagePrice != nil ? "$\(selectedEvent.stats.averagePrice!)" : "Unavailable")")
                        Text("Lowest Price: \(selectedEvent.stats.lowestPrice != nil ? "$\(selectedEvent.stats.lowestPrice!)" : "Unavailable")")
                        Text("Highest Price: \(selectedEvent.stats.highestPrice != nil ? "$\(selectedEvent.stats.highestPrice!)" : "Unavailable")")
                        Text("Visible Listing Count: \(selectedEvent.stats.visibleListingCount != nil ? "$\(selectedEvent.stats.visibleListingCount!)" : "Unavailable")")
                        Text("Ticket Count: \(selectedEvent.stats.ticketCount != nil ? "$\(selectedEvent.stats.ticketCount!)" : "Unavailable")")

                    }
                } // HStack
                
                
                HStack {
                    
                    Spacer()
                    
                    // DONE: Purchase Ticket
                    Button(action: {
                        if let purchaseURL = URL(string: selectedEvent.venue.externalPurchaseLink ) {
                            UIApplication.shared.open(purchaseURL)
                        }
                    }) {
                        Text("Purchase Ticket")
                            .padding(.horizontal, 20.0)
                            .padding(.vertical, 13.0)
                            .background(Color.green)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            .cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
                    } // Button
                    
                    Spacer()
                    
                    // DONE:Add to My Events
                    Button(action: {
                        addNewEvent()
                    }) {
                        Text("Attending")
                    } // Button
                    .padding(.horizontal, 20.0)
                    .padding(.vertical, 13.0)
                    .background(Color.green)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                    .cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
                    
                    Spacer()
                    
                } // HStack
                .padding(.vertical, 20.0)
                
            } // VStack
            .padding(.horizontal, 10)
        } // ScrollView
        
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        
        // Toolbar ICONS
        .toolbar {
            
            ToolbarItemGroup(placement: .topBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 15, weight: .bold))
                        .padding(10)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                })
            } // ToolbarItemGroup
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                
                ShareLink(
                    item: """
                    Check out this Event: \(selectedEvent.eventName)
                    Type: \(selectedEvent.type)
                    Hosted By: \(selectedEvent.venue.name)
                    Date: \(selectedEvent.date)
                    Location: \(selectedEvent.venue.address), \(selectedEvent.venue.city)
                    Purchase Tickets: \(selectedEvent.venue.externalPurchaseLink)
                    """
                ) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 13, weight: .heavy))
                        .padding(8)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                }

                
            } // ToolbarItemGroup
            
        }
        .onAppear {
            locationHelper.convertAddressToCoordinates(address: selectedEvent.venue.address) { coordinates in
                self.coordinates = coordinates
            }
        } // .onAppear
        
    }//body
    
    private func addNewEvent(){

        self.fireDBHelper.insertEvent(newEvent: selectedEvent)
            
    }
    
} // ActivityDetailsView


struct HeaderPhotoView: View {
    let photo: String
               
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                AsyncImage(url: URL(string: photo)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        .scrollTargetBehavior(.paging)
    }
}

struct MyMap: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    let coordinates: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        uiView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = "Event Location"
        uiView.addAnnotation(annotation)
    }
}
