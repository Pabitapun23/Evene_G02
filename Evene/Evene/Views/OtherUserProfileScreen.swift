//
//  OtherUserProfileScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI

struct OtherUserProfileScreen: View {
    var body: some View {
        VStack {
            Text("Other User Profile")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            
            HStack {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                VStack {
                    Text("Jane Smith")
                    Text("I am attending 10 events!")
                    
                    Button {
                        
                    } label: {
                        Text("ADD FRIEND")
                    } // Button
                    
                } // VStack
                
            } // HStack
            
            Text("Jane's Next Event:")
            Text("Edmonton Stingers vs Montreal Alliance \n June 25, 4:00 PM, Olympic Stadium, Montreal")
            
            Spacer()
            
        } // VStack
        .padding()
        
    } // body
}

#Preview {
    OtherUserProfileScreen()
}
