//
//  MyEventsScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI

struct MyEventsScreen: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Shows list of events")
                
                Spacer()
            } // VStack
            .padding()
            .navigationTitle("My Events")
        } // NavigationStack
        
    } // body
}

#Preview {
    MyEventsScreen()
}
