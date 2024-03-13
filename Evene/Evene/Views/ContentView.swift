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
            
            switch root {
            case .Login:
                LoginScreen(rootScreen: self.$root)
                    .environmentObject(self.fireAuthHelper)
                    .environmentObject(self.fireDBHelper)

            case .SignUp:
                SignUpScreen(rootScreen: self.$root)
                    .environmentObject(self.fireAuthHelper)
                    .environmentObject(self.fireDBHelper)
                
            case .UserAddress:
                UserAddressScreen(rootScreen: self.$root)
                    .environmentObject(self.fireAuthHelper)
                    .environmentObject(self.fireDBHelper)
                
            case .Home:
                MainView(rootScreen: self.$root)
                    .environmentObject(self.fireAuthHelper)
                    .environmentObject(self.fireDBHelper)
                    
            
            }
         
        }//NavigationStack
        
    } // body
}

#Preview {
    ContentView()
}

