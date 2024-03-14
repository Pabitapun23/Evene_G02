//
//  SignUpScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI
import FirebaseFirestore

struct SignUpScreen: View {
    
    // env obj
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    @EnvironmentObject var fireDBHelper : FireDBHelper
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var phoneNumber: String = ""
    @State private var address: String = ""
    @State private var errorMsg: String = ""
    
    // Binding var
    @Binding var isLoginActive: Bool
    @Binding var isSignUpActive: Bool
    
    var body: some View {
        
        VStack {
            Text("Sign Up Screen")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            
            TextField("First name", text: $firstName)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            
            TextField("Last name", text: $lastName)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            
            TextField("Email", text: $email)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .keyboardType(.default)
            
            SecureField("Confirm password", text: $confirmPassword)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .keyboardType(.default)

            TextField("Phone number", text: $phoneNumber)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .keyboardType(.phonePad)
            
            TextField("Address", text: $address)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            
            Text(errorMsg)
                .foregroundStyle(.red)
            
            HStack {
                Button {
                    self.createAccount()
                    
                } label: {
                    Text("Sign Up")
                }
                .padding(.horizontal, 20.0)
                .padding(.vertical, 13.0)
                .background(Color.green)
                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                .cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
            } // HStack
            .padding()
            
            HStack {
                Text("Already have an account?")
                
                Button(action: {
                    // navigating to loginScreen
                    isLoginActive = true
                }) {
                    Text("Login")
                        .foregroundColor(.green)
                } // Button
                
            } // HStack
            
            Spacer()
        } // VStack
        .padding()
        
    } // body
    
    func createAccount() {
        let user = User(firstName: firstName, lastName: lastName, fullName: "\(firstName) \(lastName)", email: email, password: password, phoneNumber: phoneNumber, address: address, friendList: [], eventList: [])
        
        self.fireAuthHelper.signUp(user: user) { error in
            if let error = error {
                // Handle sign up error
                print("Error signing up:", error.localizedDescription)
                print(#function, "Cannot create an account")
            } else {
                // Sign up successful, dismiss the current view

                print("Sign up successful!")
                
                // Navigate to login screen by changing state for login screen
                isLoginActive = true
                isSignUpActive = false
            } // if-let-else
    
        } // fireAuthHelper.signUp(user: user)
    } // func

}

#Preview {
    SignUpScreen(isLoginActive: .constant(false), isSignUpActive: .constant(true))
}
