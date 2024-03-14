//
//  EventDetailsScreen.swift
//  Evene
//
//  Created by Alfie on 2024-03-13.
//

import SwiftUI

struct EventDetailsScreen: View {
    
    let selectedEvent : Event
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.openURL) private var openURL
    
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            
            HeaderPhotoView(photo: selectedEvent.performers[0].image)
            
            VStack(alignment: .leading, spacing: 25) {
                
                // TODO: Event Name
                Text("Event")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Text("Name: \(selectedEvent.eventName)")
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color(hue: 1.0, saturation: 0.0, brightness: 0.781))
                
                // TODO: Event Host
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Event Host")
                            .font(.title2)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                        Text("Name: \(selectedEvent.venue.name)")
                        Text("Location: \(selectedEvent.venue.address), \(selectedEvent.venue.city)")
                        
                        // TODO: Call Telephone
//                        Button {
//                            if let url = URL(string: "tel://\(selectedEvent.tel)") {
//                                openURL(url)
//                            }
//                        } label: {
//                            Label("\(selectedEvent.tel)", systemImage: "phone.circle")
//                        }
                    }
                    
                    
                    Spacer()
                    
                }
                
                // TODO: MapView
//                    MapView()
                
                Spacer()
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color(hue: 1.0, saturation: 0.0, brightness: 0.781))
                
                
                // TODO: Event description
                Text("Event Description")
                    .font(.title2)
                    .fontWeight(.bold)
//                Text(selectedEvent.description)
                Text("Type: \(selectedEvent.type)")
//                Text("Date And Time: \(selectedEvent.date)")
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color(hue: 1.0, saturation: 0.0, brightness: 0.781))
                
                // TODO: Performer Name And Photo
                Text("Performer Name")
                    .font(.title2)
                    .fontWeight(.bold)
//                Text(selectedEvent.performers.name)
//                    .font(.body)
                
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color(hue: 1.0, saturation: 0.0, brightness: 0.781))
                
                // TODO: Event Price
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Price")
                            .font(.title2)
                            .fontWeight(.bold)
//                        Text("Average Price: $\(selectedEvent.stats.average_price)")
//                        Text("Lowest Price: $\(selectedEvent.stats.lowest_price)")
//                        Text("Highest Price: $\(selectedEvent.stats.highest_price)")
                        Text("Average Price: $100")
                        Text("Lowest Price: $200")
                        Text("Highest Price: $300")
                    }
                }
                

                // TODO: Purchase Ticket
                Button(action: {
                    // TODO: Go To Website
                }) {
                    Text("Purchase Ticket!")
                        .foregroundColor(.blue)
                        .underline()
                }
                
                Button(action: {
                    // TODO: Add to My Events
                    addNewEvent()
                }) {
                    Text("Add to My Events!")
                        .buttonStyle(.borderedProminent)
                        .padding()
                }
                
                
            }
            .padding(.horizontal, 30)
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
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                })
            } // ToolbarItemGroup
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                
                ShareLink(item: "\(selectedEvent.eventName)",
                          subject: Text("Check out this Activity!"),
//                          message: Average Price: $\(selectedEvent.stats.average_price)")
                          preview: SharePreview(
                            "\(selectedEvent.eventName)",
                            image: Image("\(selectedEvent.performers[0].image)")
                        )
                ) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 13, weight: .heavy))
                        .padding(8)
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                }
                
                // TODO: Add to favority
                Button(action: {
                    // TODO: Add Event To User Favorite List
                    
                }, label: {
                    // TODO: If it's added, use "heart.fill"
                    Image("heart.filllet description: String?")
                        .font(.system(size: 14, weight: .bold))
                        .padding(8)
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                })
                
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
