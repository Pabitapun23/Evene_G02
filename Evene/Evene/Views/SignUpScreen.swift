//
//  SignUpScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI
import FirebaseFirestore

struct SignUpScreen: View {
    
    var fireAuthHelper : FireAuthHelper
    var fireDBHelper : FireDBHelper
    @Binding var rootScreen : RootView
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var phoneNumber: String = ""
    @State private var address: String = ""
    @State private var errorMsg: String = ""
    
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
                
                NavigationLink(destination: LoginScreen( fireAuthHelper: self.fireAuthHelper, fireDBHelper: self.fireDBHelper, rootScreen: self.$rootScreen)) {
                    Text("Login")
                        .foregroundStyle(.green)
                } // NavigationLink
            } // HStack
            
            Spacer()
        } // VStack
        .padding()
        
    } // body
    
    private func createAccount() {
        // Reset error message
        errorMsg = ""
                
        // Form validation
        guard !firstName.isEmpty || !lastName.isEmpty else {
            errorMsg = "Name cannot be empty"
            return
        }
        
        guard !email.isEmpty else {
            errorMsg = "Email cannot be empty"
            return
        }
        
        guard !password.isEmpty || !confirmPassword.isEmpty else {
            errorMsg = "Password cannot be empty"
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
        
        guard password == confirmPassword else {
            errorMsg = "Passwords do not match"
            return
        }
        
        if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && !phoneNumber.isEmpty && !address.isEmpty {
            // Perform sign up
            fireAuthHelper.signUp(fullName: "\(firstName) \(lastName)", email: email, password: password, phoneNumber: phoneNumber, address: address)
            
            print("testing \(fireAuthHelper)")
            
            // add user to db
            // user fullname
            let name = "\(self.firstName) \(self.lastName)"
            let newUser = User(name: name, email: self.email, password: self.password, phoneNumber: self.phoneNumber, address: self.address)
            self.fireDBHelper.addUserToDB(newUser: newUser)
            
            //move to login screen
            self.rootScreen = .Home
        } else {
            print(#function, "Unable to create an account")
        }
        
        
    }
}

#Preview {
//    SignUpScreen(fireAuthHelper: FireAuthHelper(), fireDBHelper: FireDBHelper(db: Firestore), rootScreen: .constant(.Home))
    SignUpScreen(fireAuthHelper: FireAuthHelper(), fireDBHelper: FireDBHelper(db: Firestore.firestore()), rootScreen: .constant(RootView.SignUp))
}



//        self.fireAuthHelper.signUp(fullName: "\(self.firstName) \(self.lastName)", email: self.email, password: self.password, phoneNumber: self.phoneNumber, address: self.address)
//
//fireAuthHelper.signUp(fullName: "\(firstName) \(lastName)", email: email, password: password, phoneNumber: phoneNumber, address: address)
