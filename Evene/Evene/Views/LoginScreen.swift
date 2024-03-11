//
//  LoginScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI

struct LoginScreen: View {
    
    @State private var emailFromUI : String = ""
    @State private var passwordFromUI : String = ""
    @State private var rememberMe: Bool = false
//    @Binding var isLoggedIn: Bool // Use binding to update the state
    @State private var errorMessage: String? // Hold error message
    @State private var loggedInUserEmail: String? // Hold the logged-in user's email
    
    
    var body: some View {
        
        VStack {
            Text("Login Screen")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            
            TextField("Enter your email", text: $emailFromUI)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
            
            SecureField("Enter your password", text: $passwordFromUI)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .keyboardType(.default)
            
            Toggle("Remember Me", isOn: $rememberMe)
                .padding(.horizontal)
            
            Button {
//                login()
            } label: {
                Text("Login")
            }
            .padding(.horizontal, 20.0)
            .padding(.vertical, 13.0)
            .background(Color.green)
            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
            .cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
            
            Spacer()
        } // VStack
        .padding()
        
    } // body
}

#Preview {
    // Pass a binding to isLoggedIn
//    LoginScreen(isLoggedIn: .constant(false))
    
    LoginScreen()
}
