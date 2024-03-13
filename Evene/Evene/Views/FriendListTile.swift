//
//  FriendListTile.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-12.
//

import SwiftUI

struct FriendListTile: View {
//    @EnvironmentObject var fireDBHelper : FireDBHelper
//    @EnvironmentObject var fireAuthHelper : FireAuthHelper
//    @Binding var rootScreen : RootView
    
//    var user: User
    
    var body: some View {
        HStack(alignment: .top){
//            if let imageURL = Event.photo {
//                if let imageURL = Event.photo?.first { // Select the first image from the array
//                    AsyncImage(url: imageURL){ phase in
//                        switch phase {
//                        case .success(let image):
//                            image
//                                .resizable()
//                                .frame(width: 100, height: 100)
//                                .clipShape(
//                                    RoundedRectangle(cornerRadius: 10)
//                                )
//                        default:
//                            Image(systemName: "photo")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 100, height: 100)
//                        }
//                    }
//                }
//            }else{
//                Image(systemName: "photo")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 100, height: 100)
//            }
            
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
            VStack(alignment: .leading){
                Text("user.name")
                    .font(.headline)
                Text("user.address")
                    .font(.subheadline)
            }
        } // HStack
        .padding(.vertical, 5.0)
    }
}

#Preview {
    FriendListTile()
}
