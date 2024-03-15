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
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var addToEventBtnDisabled : Bool = false
    @State private var userEvents: [Event] = []
    
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
            
            VStack(alignment: .leading, spacing: 25) {
                
                // DONE: Event Name
                Text("Event")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Text("Name: \(selectedEvent.eventName)")
                Text("Type: \(selectedEvent.type)")
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color(hue: 1.0, saturation: 0.0, brightness: 0.781))
                
                // TODO: Event Host
                Text("Description")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Text("Host By: \(selectedEvent.venue.name)")
                Text("Date: \(selectedEvent.date)")
                Text("Location: \(selectedEvent.venue.address), \(selectedEvent.venue.city)")
                
                // Done: MapView
                if let coordinates = coordinates {
                    MyMap(coordinates: coordinates)
                        .frame(height: 300)
                } else {
                    Text("Loading map...")
                }
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color(hue: 1.0, saturation: 0.0, brightness: 0.781))
                
                // TODO: Performer Name And Photo
                Text("Performer")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Name: \(selectedEvent.performers[0].name)").font(.body)
                
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color(hue: 1.0, saturation: 0.0, brightness: 0.781))
                
                // TODO: Event Price
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Price")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Average Price: $647")
                        Text("Lowest Price: $429")
                        Text("Highest Price: $1488")
                        Text("Ticket Count: 32")
                    }
                } // HStack
            }//VStack
            .padding(.horizontal, 30)
            
            Button(action: {
                if let purchaseURL = URL(string: selectedEvent.venue.externalPurchaseLink) {
                    UIApplication.shared.open(purchaseURL)
                }
            }) {
                Text("Purchase Ticket!")
            }
            .padding(.horizontal, 20.0)
            .padding(.vertical, 13.0)
            .background(Color.green)
            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
            .cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
            
            Button(action: {
                addNewEvent()
                alertMessage = "Event added successfully"
                showAlert = true
                addToEventBtnDisabled = true
            }) {
                Text("Add to My Events")
            }
            .padding(.horizontal, 20.0)
            .padding(.vertical, 13.0)
            .background(Color.green)
            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
            .cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
            .disabled(self.addToEventBtnDisabled)
        }
        
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
                        .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                        .clipShape(Circle())
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                })
            } // ToolbarItemGroup
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                ShareLink(item: "\(selectedEvent.eventName)",
                          subject: Text("Check out this Activity!"),
                          preview: SharePreview(
                            "\(selectedEvent.eventName)",
                            image: Image("\(selectedEvent.performers[0].image)")
                        )
                ) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 13, weight: .heavy))
                        .padding(8)
                        .background(Color.green)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                        .clipShape(Circle())
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                }
            } // ToolbarItemGroup
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Update Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            locationHelper.convertAddressToCoordinates(address: selectedEvent.venue.address) { coordinates in
                self.coordinates = coordinates
            }
        }
        
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
