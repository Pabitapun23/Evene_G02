//
//  OtherUserProfileScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI

struct OtherUserProfileScreen: View {
//    let selectedUserIndex : Int
    let selectedUser : User
    
    @EnvironmentObject var fireDBHelper : FireDBHelper
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                VStack (alignment: .leading, spacing: 10) {
                    Text(selectedUser.fullName)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(.bold)
                    
                    Text("I am attending 10 events!")
                    
                    Button {
                        
                    } label: {
                        Text("ADD FRIEND")
                    } // Button
                    .padding(.horizontal, 15.0)
                    .padding(.vertical, 10.0)
                    .background(Color.green)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                    .cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
                    
                } // VStack
                .padding(.horizontal, 20.0)
                
            } // HStack
            
            Text("\(selectedUser.firstName)'s Next Event:")
                .font(.title2)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(.top, 30)
            Text("Edmonton Stingers vs Montreal Alliance \nJune 25, 4:00 PM, Olympic Stadium, Montreal")
            
            Spacer()
            
        } // VStack
        .padding()
        .navigationTitle("Other User Profile")
        .navigationBarTitleDisplayMode(.inline)
        
    } // body
}

#Preview {
    OtherUserProfileScreen(selectedUser: User(firstName: "NA", lastName: "NA", fullName: "NA", email: "", password: "", phoneNumber: "", address: "", profilePic: nil, friendList: nil))
}
