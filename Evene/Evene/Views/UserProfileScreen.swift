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
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var imageURL: URL?
    
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                VStack(spacing: 15) {
                    //Profile Picture Placeholder
                    ZStack {
                        if let profilePic = user.profilePic, let url = URL(string: profilePic.absoluteString) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 150, height: 150)
                                .foregroundColor(.gray)
                                
                        }
                    } // ZStack
                    .padding(.top, 20)
                    
                    Button("Upload Image") {
                        selectImage()
                    }
                    .sheet(isPresented: $showingImagePicker, onDismiss: handleImageSelection) {
                        ImagePicker(selectedImage: $inputImage)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        VStack(alignment: .leading) {
                            Text("First Name:")
                                .bold()
                            TextField("", text: $firstName)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Last Name:")
                                .bold()
                            TextField("", text: $lastName)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Phone Number:")
                                .bold()
                            TextField("Phone Number", text: $phoneNumber)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Address:")
                                .bold()
                            TextField("Address", text: $address)
                                .textFieldStyle(.roundedBorder)
                        }
                    }//VStack
                    .padding(.horizontal)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                  
                    HStack {
                        Button {
                            updateUserProfile()
                        } label: {
                            Text("Save Changes")
                        }
                        .padding(.horizontal, 20.0)
                        .padding(.vertical, 13.0)
                        .background(Color.green)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                        .cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
                    } .padding(.top, 20.0)
                    
                }//VStack
                .padding()
                
            }//ScrollView
            
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: MyFriendListScreen()) {
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.green)
                        }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.fireAuthHelper.signOut()
                        isLoggedIn = false
                    }) {
                        Image(systemName: "power")
                            .foregroundColor(.green)
                    }
                }
            }
            
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Update Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
            .onAppear(perform: fetchCurrentUserProfile)
        }// NavigationStack
    } // body
    
    func selectImage() {
        showingImagePicker = true
    }

    func handleImageSelection() {
        guard let inputImage = inputImage else { return }
        
        self.fireDBHelper.uploadImage(inputImage) { result in
            switch result {
            case .success(let url):
                print(#function, "successful!")
                self.fireDBHelper.saveProfilePictureURL(url, forUser: user.email)
                self.imageURL = url
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchCurrentUserProfile() {
            if let userEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") {
                fireDBHelper.getUserFromDB(email: userEmail) { user in
                    if let user = user {
                        self.user = user
                        self.firstName = user.firstName
                        self.lastName = user.lastName
                        self.phoneNumber = user.phoneNumber
                        self.address = user.address
                        self.imageURL = user.profilePic
                    }
                }
            }
        }
        
    private func updateUserProfile() {
        let userDictToUpdate: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "phoneNumber": phoneNumber,
            "address": address,
            "profilePic": imageURL?.absoluteString ?? ""
        ]
        
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




