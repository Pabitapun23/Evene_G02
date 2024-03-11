//
//  BookmarkedEventsScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-10.
//

import SwiftUI

struct BookmarkedEventsScreen: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Shows the list of saved events")
                
                Spacer()
            } // VStack
            .padding()
            .navigationTitle("Bookmarked Events")
        } // NavigationStack
    } // body
}

#Preview {
    BookmarkedEventsScreen()
}
