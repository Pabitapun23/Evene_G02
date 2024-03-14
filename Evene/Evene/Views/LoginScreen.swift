//
//  LoginScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI
import FirebaseFirestore

struct LoginScreen: View {
    
    // env obj
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    @EnvironmentObject var fireDBHelper: FireDBHelper
    
    @State private var emailFromUI : String = ""
    @State private var passwordFromUI : String = ""
    @State private var rememberMe: Bool = false
    @State private var errorMessage: String?
    
    // Use binding to update the state
    @Binding var isLoginActive: Bool
    @Binding var isSignUpActive: Bool
    @Binding var isLoggedIn: Bool
    
    
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
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button {
                doLogin()
            } label: {
                Text("Login")
            }
            .padding(.horizontal, 20.0)
            .padding(.vertical, 13.0)
            .background(Color.green)
            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
            .cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
            
            HStack {
                Text("Don't have an account?")
                
                Button(action: {
                    isSignUpActive = true
                    isLoginActive = false
                }) {
                    Text("Sign Up")
                        .foregroundColor(.green)
                } // Button
                    
            } // HStack
            
            Spacer()
            
        } // VStack
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            
            // Retrieve rememberMe status from UserDefaults
            rememberMe = UserDefaults.standard.bool(forKey: "RememberMeStatus")
            
            // If rememberMe is true, retrieve the previously logged-in user's email and password
            if rememberMe {
                if let savedEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL"),
                   let savedPassword = UserDefaults.standard.string(forKey: "KEY_PASSWORD") {
                    self.emailFromUI = savedEmail
                    self.passwordFromUI = savedPassword
                    
                }
            } else {
                self.emailFromUI = ""
                self.passwordFromUI = ""
                self.rememberMe = false
            }
        }
        
    } // body
    
    func doLogin() {
        
        self.fireAuthHelper.signIn(email: emailFromUI, password: passwordFromUI) { error in
            if let error = error {
                // Handle login error
                print("Error logging in:", error.localizedDescription)
                print(#function, "Cannot logged into the account")
            } else {
                // Login successful show success msg
                print("Login successful!")
                
                // navigate to next screen by changing the state
                self.isLoggedIn = true
                self.isLoginActive = false
                self.isSignUpActive = false
                
                // For remember me
                if self.rememberMe {
                    // Save rememberMe status to UserDefaults
                    UserDefaults.standard.set(self.rememberMe, forKey: "RememberMeStatus")
                    
                    // Save logged-in user's email and password to UserDefaults
                    UserDefaults.standard.set(self.emailFromUI, forKey: "KEY_EMAIL")
                    UserDefaults.standard.set(self.passwordFromUI, forKey: "KEY_PASSWORD")
                } else {
                    // If rememberMe is false, clear the saved user's email and password from UserDefaults
                    UserDefaults.standard.removeObject(forKey: "KEY_EMAIL")
                    UserDefaults.standard.removeObject(forKey: "KEY_PASSWORD")
                }
                                  
            }
                
        } // fireAuthHelper.signIn()
    } // func
}

#Preview {
    LoginScreen(isLoginActive: .constant(true), isSignUpActive: .constant(false), isLoggedIn: .constant(false))
}
