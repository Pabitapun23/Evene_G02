//
//  SignUpScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI
import FirebaseFirestore

struct SignUpScreen: View {
    
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @Binding var rootScreen : RootView
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var phoneNumber: String = ""
    @State private var address: String = ""
    @State private var errorMsg: String = ""
    
    @State private var isAccountCreated: Bool = false
    
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
                
                NavigationLink(destination: LoginScreen(rootScreen: self.$rootScreen)) {
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
            errorMsg = "Password cannot be empty"
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
        
        //if all the data is validated, create account on FirebaseAuth
        if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && !phoneNumber.isEmpty && !address.isEmpty {
            // Perform sign up
            self.fireAuthHelper.signUp(fullName: "\(firstName) \(lastName)", email: email, password: password, phoneNumber: phoneNumber)
            
            print("testing \(fireAuthHelper)")
            
            self.rootScreen = .UserAddress
            
            print("success")
            // add user to db
            // user fullname
            let name = "\(self.firstName) \(self.lastName)"
            let newUser = User(name: name, email: self.email, password: self.password, phoneNumber: self.phoneNumber, address: self.address)
            self.fireDBHelper.addUserToDB(newUser: newUser)
            
            print("new user : \(newUser)")
            
            print(self.fireDBHelper.addUserToDB(newUser: newUser))
            
            print("yesssssss")
            
//            isAccountCreated = true
            
            
            
            print("checking")
            
            // reset fields
        } else {
            print(#function, "Unable to create an account")
            return
        }
        
//        if isAccountCreated {
//            //move to login screen
//            self.rootScreen = .UserAddress
//            print(#function, "Account created successfully")
//        } else {
//            print(#function, "sorry Unable to create an account")
//        }
        
    } // func
}

#Preview {
    SignUpScreen(rootScreen: .constant(RootView.SignUp))
}
