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
        
        NavigationView {
            VStack {
                Text("Login")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Image("evene")
                    .resizable()
                    .frame(width: 250, height: 250)
                
                VStack(spacing: 15) {
                    TextField("Enter your email", text: $emailFromUI)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Enter your password", text: $passwordFromUI)
                        .keyboardType(.default)
                } // VStack
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                
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

                }
            }
        } // NavigationView
        
    } // body
    
    func doLogin() {
        
        //validate the data
        if self.emailFromUI.isEmpty {
            errorMessage = "Email cannot be empty"
            return
        }
        if self.passwordFromUI.isEmpty {
            errorMessage = "Password cannot be empty"
            return
        }

        if (!self.emailFromUI.isEmpty && !self.passwordFromUI.isEmpty){
            
            errorMessage = ""
            
            //validate credentials
            self.fireAuthHelper.signIn(email: emailFromUI, password: passwordFromUI) { error in
                if let error = error {
                    // Handle login error
                    print("Error logging in:", error.localizedDescription)
                    print(#function, "Cannot logged into the account")
                    
                    errorMessage = "The supplied auth credential is not matched"
                } else {
                    // Login successful show success msg
                    print("Login successful!")
                    
                    // reset error message
                    errorMessage = ""
                    
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
                        
                        // Save rememberMe status to UserDefaults
                        UserDefaults.standard.set(self.rememberMe, forKey: "RememberMeStatus")
            
                    }
                                      
                }
                    
            } // fireAuthHelper.signIn()
            
            
        }
    } // func
}

#Preview {
    LoginScreen(isLoginActive: .constant(true), isSignUpActive: .constant(false), isLoggedIn: .constant(false))
}
