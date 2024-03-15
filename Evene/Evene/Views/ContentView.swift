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
    
    @State private var isLoginActive = false
    @State private var isSignUpActive = false
    // Add binding for login status
    @State private var isLoggedIn = false
    
    var body: some View {
        if !isLoggedIn {
            
            if !isLoginActive && !isSignUpActive {
                LoginScreen(isLoginActive: $isLoginActive, isSignUpActive: $isSignUpActive, isLoggedIn: $isLoggedIn)
                    .environmentObject(fireAuthHelper)
                    .environmentObject(fireDBHelper)
            } else if isLoginActive {
                LoginScreen(isLoginActive: $isLoginActive, isSignUpActive: $isSignUpActive, isLoggedIn: $isLoggedIn)
                    .environmentObject(fireAuthHelper)
                    .environmentObject(fireDBHelper)
            } else if isSignUpActive {
                SignUpScreen(isLoginActive: $isLoginActive, isSignUpActive: $isSignUpActive)
                    .environmentObject(fireAuthHelper)
                    .environmentObject(fireDBHelper)
            }
            
        } else {
            MainView(isLoggedIn: $isLoggedIn)
                .environmentObject(fireAuthHelper)
                .environmentObject(fireDBHelper)
        }
        
    } // body
}

#Preview {
    ContentView()
}

