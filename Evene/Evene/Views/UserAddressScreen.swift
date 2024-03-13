//
//  UserAddressScreen.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-13.
//

import SwiftUI

struct UserAddressScreen: View {
    
    @EnvironmentObject var locationHelper: LocationHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @Binding var rootScreen : RootView
    
    @State var address: String = ""
    
    var body: some View {
        VStack {
            // user address
            Text("User Address")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            HStack {
                TextField("Enter your address", text: $address)
                Button {
                    self.locationHelper.checkPermission()
                    self.getCurrentLocation()
                } label: {
                    Text("Current Location")
                }
            } // HStack
            
            // Map
            if (self.locationHelper.currentLocation != nil){
     
                MapView(location: self.locationHelper.currentLocation!)
                
            }else{
                Text("Obtaining user location ....")
            }
            
        } // VStack
    } // body
    
    func getCurrentLocation() {
        
    }
}

//#Preview {
//    UserAddressScreen()
//}
