//
//  UserProfileScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-09.
//

import SwiftUI

struct UserProfileScreen: View {
    
    @State private var user: User = User(firstName: "", lastName: "", fullName: "", email: "", password: "", phoneNumber: "", address: "", profilePic: nil, friendList: [], eventList: nil)
        
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var phoneNumber: String = ""
    @State private var address: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                VStack(spacing: 50) {
                    //Profile Picture Placeholder
                    ZStack {
                        if let profilePic = user.profilePic, let url = URL(string: profilePic.absoluteString) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("First Name:")
                                .bold()
                            TextField("", text: $firstName)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        HStack {
                            Text("Last Name:")
                                .bold()
                            TextField("", text: $lastName)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        HStack {
                            Text("Phone Number:")
                                .bold()
                            TextField("Phone Number", text: $phoneNumber)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        HStack {
                            Text("Address:")
                                .bold()
                            TextField("Address", text: $address)
                                .textFieldStyle(.roundedBorder)
                        }
                    }//VStack
                    .padding(.horizontal)
                    
                    Button("Save Changes") {
                        updateUserProfile()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    
                }//VStack
            }//ScrollView
            
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: MyFriendListScreen()) {
                            Image(systemName: "person.2.fill")
                        }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.fireAuthHelper.signOut()
                        isLoggedIn = false
                    }) {
                        Image(systemName: "power")
                    }
                }
            }
            
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Update Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
            .onAppear(perform: fetchCurrentUserProfile)
        } // NavigationStack
    } // body
    
    private func fetchCurrentUserProfile() {
            if let userEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") {
                fireDBHelper.getUserFromDB(email: userEmail) { user in
                    if let user = user {
                        self.user = user
                        self.firstName = user.firstName
                        self.lastName = user.lastName
                        self.phoneNumber = user.phoneNumber
                        self.address = user.address
                    }
                }
            }
        }
        
    private func updateUserProfile() {
        // Prepare the dictionary to update user profile
        let userDictToUpdate: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "phoneNumber": phoneNumber,
            "address": address
        ]
        
        // Call the function to update user in Firestore
        fireDBHelper.updateUserInDB(userDictToUpdate: userDictToUpdate) { error in
            if let error = error {
                print("Error updating user: \(error.localizedDescription)")
                alertMessage = "Failed to update user info: \(error.localizedDescription)"
                showAlert = true
            } else {
                print("User updated successfully")
                alertMessage = "User info updated successfully!"
                showAlert = true
            }
        }
    }
}

#Preview {
    UserProfileScreen(isLoggedIn: .constant(true))
}
