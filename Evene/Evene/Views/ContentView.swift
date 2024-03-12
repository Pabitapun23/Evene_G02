//
//  ContentView.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI

struct ContentView: View {
    private let fireDBHelper = FireDBHelper.getInstance()
    var fireAuthHelper = FireAuthHelper()
    
    @State private var root : RootView = .Login
    
    var body: some View {
        NavigationStack{
            
            switch (root) {
            case .Login:
//                LoginScreen(rootScreen: self.$root)
//                    .environmentObject(fireAuthHelper)
//                    .environmentObject(self.fireDBHelper)
                LoginScreen(fireAuthHelper: fireAuthHelper, fireDBHelper: fireDBHelper, rootScreen: self.$root)
            case .SignUp:
//                SignUpScreen(rootScreen: self.$root)
//                    .environmentObject(fireAuthHelper)
//                    .environmentObject(self.fireDBHelper)
                SignUpScreen(fireAuthHelper: fireAuthHelper, fireDBHelper: fireDBHelper, rootScreen: self.$root)

            case .Home:
                MainView(rootScreen: self.$root)
                    .environmentObject(self.fireDBHelper)
                    .environmentObject(self.fireAuthHelper)
            
            }
         
        }//NavigationStack
        
    } // body
}

#Preview {
    ContentView()
}

                
