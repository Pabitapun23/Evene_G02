//
//  FriendListTile.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-12.
//

import SwiftUI

struct FriendListTile: View {
    @EnvironmentObject var fireDBHelper : FireDBHelper
    
    var currentUser: User
    
    var body: some View {
        HStack(alignment: .top){
            if let imageURL = currentUser.profilePic {
                AsyncImage(url: imageURL){ phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                    default:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    } // switch
                } // AsyncImage
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            } // if-else
            
            VStack(alignment: .leading){
                Text(currentUser.fullName)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(currentUser.address)
                    .font(.subheadline)
            } // VStack
        } // HStack
        .padding(.vertical, 5.0)
    } // body
}

#Preview {
    FriendListTile(currentUser: User( firstName: "", lastName: "", fullName: "", email: "", password: "", phoneNumber: "", address: "", friendList: nil, eventList: nil))
}
