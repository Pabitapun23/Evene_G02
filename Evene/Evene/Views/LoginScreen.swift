//
//  LoginScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI
import FirebaseFirestore

struct LoginScreen: View {
    
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    @EnvironmentObject var fireDBHelper: FireDBHelper
    
//    var fireAuthHelper: FireAuthHelper
//    var fireDBHelper: FireDBHelper
    @Binding var rootScreen : RootView
    
    @State private var emailFromUI : String = ""
    @State private var passwordFromUI : String = ""
    @State private var rememberMe: Bool = false
//    @Binding var isLoggedIn: Bool // Use binding to update the state
    @State private var errorMessage: String? // Hold error message
//    @State private var loggedInUserEmail: String? // Hold the logged-in user's email
    
    
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
            
//            NavigationLink(destination: HomeScreen(), isActive: $isLoggedIn) {
//                EmptyView()
//            }
//            .isDetailLink(false)
//            .hidden()
            
            HStack {
                Text("Don't have an account?")
                
                NavigationLink(destination: SignUpScreen(rootScreen: $rootScreen)) {
                    Text("SignUp")
                        .foregroundStyle(.green)
                } // NavigationLink
            } // HStack
            
            Spacer()
        } // VStack
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
//            self.emailFromUI = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""
//            self.passwordFromUI = UserDefaults.standard.string(forKey: "KEY_PASSWORD") ?? ""
            
            // Retrieve rememberMe status from UserDefaults
//            rememberMe = UserDefaults.standard.bool(forKey: "RememberMeStatus")
//            // If rememberMe is true, retrieve the previously logged-in user's email and password
//            if rememberMe {
//                if let savedEmail = UserDefaults.standard.string(forKey: "LoggedInUserEmail"),
//                   let savedPassword = UserDefaults.standard.string(forKey: "LoggedInUserPassword") {
//                    emailFromUI = savedEmail
//                    passwordFromUI = savedPassword
////                    loggedInUserEmail = savedEmail // Set loggedInUserEmail
//                    
//                    // Automatically log in the user if rememberMe is true
//                    doLogin()
//                }
//            }
        }
        
    } // body
    
    func doLogin() {
        //validate the data
        if (!self.emailFromUI.isEmpty && !self.passwordFromUI.isEmpty){
            
            //validate credentials
            self.fireAuthHelper.signIn(email: self.emailFromUI, password: self.passwordFromUI)
            
            //navigate to home screen
            self.rootScreen = .Home
            
            print("Attempting to log in with email:", self.emailFromUI)
        } else {
            //trigger alert displaying errors
            print(#function, "email and password cannot be empty")
        }
    }
}

#Preview {
    // Pass a binding to isLoggedIn
//    LoginScreen(isLoggedIn: .constant(false))
    
    LoginScreen(rootScreen: .constant(.Login))
}
