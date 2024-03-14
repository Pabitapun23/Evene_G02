//
//  EveneApp.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import MapKit

@main
struct EveneApp: App {
    // Initialize FireAuthHelper as an environment object
    @StateObject var fireAuthHelper = FireAuthHelper()
    // Initialize FireDBHelper as an environment object
    @StateObject var fireDBHelper = FireDBHelper.getInstance()
    let locationHelper = LocationHelper()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fireAuthHelper)
                .environmentObject(fireDBHelper)
                .environmentObject(locationHelper)
        }
    }
}
