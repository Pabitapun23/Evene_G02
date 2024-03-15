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
            Text("Sign Up")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding()
            
            Text("Create an account to find amazing events!")
                .font(.headline)
                .foregroundStyle(.gray)
                .italic()
                .padding(.bottom, 15.0)
            
            VStack(spacing: 15) {
                TextField("First name", text: $firstName)
                    
                TextField("Last name", text: $lastName)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .keyboardType(.default)
                
                SecureField("Confirm password", text: $confirmPassword)
                    .keyboardType(.default)

                TextField("Phone number", text: $phoneNumber)
                    .keyboardType(.phonePad)
                
                TextField("Address", text: $address)
            } // VStack
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
        
        // Reset error message
        errorMsg = ""

        // Form validation
        guard !firstName.isEmpty else {
            errorMsg = "First Name cannot be empty"
            return
        }

        guard !lastName.isEmpty else {
            errorMsg = "Last Name cannot be empty"
            return
        }

        guard !email.isEmpty else {
            errorMsg = "Email cannot be empty"
            return
        }

        guard !password.isEmpty else {
            errorMsg = "Password cannot be empty"
            return
        }

        guard !confirmPassword.isEmpty else {
            errorMsg = "Confirmed Password cannot be empty"
            return
        }

        guard password == confirmPassword else {
            errorMsg = "Passwords do not match"
            return
        }

        guard !phoneNumber.isEmpty else {
            errorMsg = "Phone number cannot be empty"
            return
        }

        guard !address.isEmpty else {
            errorMsg = "Address cannot be empty"
            return
        }

        // store this info into user obj
        let user = User(firstName: firstName, lastName: lastName, fullName: "\(firstName) \(lastName)", email: email, password: password, phoneNumber: phoneNumber, address: address, friendList: [], eventList: [])
        
        //if all the data is validated, create account on FirebaseAuth
        self.fireAuthHelper.signUp(user: user) { error in
            if let error = error {
                // Handle sign up error
                
                errorMsg = "Cannot create an account"
                
                print("Error signing up:", error.localizedDescription)
                print(#function, "Cannot create an account")
            } else {
                // Sign up successful,
                print("Sign up successful!")
                
                // reset error msg
                errorMsg = ""
                
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
