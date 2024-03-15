//
//  LocationHelper.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-13.
//

import Foundation
import MapKit
import Contacts

class LocationHelper: NSObject, ObservableObject, CLLocationManagerDelegate{
    // ObservableObject: Combine framework’s type for an object with a publisher that emits before the object has changed.
    // The methods that you use to receive events from an associated location-manager object.
    
    private let geoCoder = CLGeocoder()
    // An interface for converting between geographic coordinates and place names.
    
    private let locationManager = CLLocationManager()
    //The object that you use to start and stop the delivery of location-related events to your app.
    
    @Published var authorizationStatus : CLAuthorizationStatus = .notDetermined
    // Constants indicating the app's authorization to use location services.
    
    @Published var currentLocation: CLLocation?
    //The latitude, longitude, and course information reported by the system.
    
    override init() {
        super.init()
        if (CLLocationManager.locationServicesEnabled()){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //The best level of accuracy available.
            
        }
        // permission check
        self.checkPermission()
        
        if (CLLocationManager.locationServicesEnabled() && (self.authorizationStatus == .authorizedAlways || self.authorizationStatus == .authorizedWhenInUse)){
            self.locationManager.startUpdatingLocation()
        }else{
            self.requestPermission()
        }
        
    }// init
    
    func requestPermission(){
        if (CLLocationManager.locationServicesEnabled()){
            self.locationManager.requestWhenInUseAuthorization()
            //Requests the user’s permission to use location services while the app is in use.
        }
    }
    
    
    func checkPermission(){
        switch self.locationManager.authorizationStatus{
        case .denied:
            // req perm
            self.requestPermission()
            
        case .notDetermined:
            self.requestPermission()
            
        case .restricted:
            self.requestPermission()
            
        case .authorizedAlways:
            self.locationManager.startUpdatingLocation()
            
        case .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            
        default:
            break
            
            
        }
    }//checkPerm
    
    // ******

   
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function, "Authorization Status changed : \(self.locationManager.authorizationStatus)")
        
        self.authorizationStatus = manager.authorizationStatus
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //process received locations
        
        if locations.last != nil{
            //most recent
            print(#function, "most recent location : \(locations.last!)")
            
            self.currentLocation = locations.last!
        }else{
            //oldest known location
            print(#function, "last known location : \(String(describing: locations.first))")
            
            self.currentLocation = locations.first
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, "Error while trying to get location updates : \(error)")
    }
    
    deinit{
        self.locationManager.stopUpdatingLocation()
    }
    
    
    //******
    
    // convert coordinates to address
    func doReverseGeocoding(location: CLLocation, completionHandler: @escaping(String?, NSError?) -> Void){
        self.geoCoder.reverseGeocodeLocation(location
        , completionHandler: {
            (placemarks, error) in
            
            if(error != nil){
                print(#function, "Unable to obtain street address for the given coordinates \(String(describing: error))")
                
                completionHandler(nil, error as NSError?)
            }else{
                if let placemarkList = placemarks, let firstPlace = placemarks?.first{
                    // get street address from coordinates
                    
                    let street = firstPlace.thoroughfare ?? "NA"
                    let postalCode = firstPlace.postalCode ?? "NA"
                    let country = firstPlace.country ?? "NA"
                    let province = firstPlace.administrativeArea ?? "NA"
                    
                    print(#function, "\(street), \(postalCode), \(country), \(province)")
                    
                    //An object that you use to format a contact's postal addresses.
                    let address = CNPostalAddressFormatter.string(from: firstPlace.postalAddress!, style: .mailingAddress)
                    
                    completionHandler(address, nil)
                    return
                    
                }
            }
            
        })
    }
    
    func convertAddressToCoordinates(address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        geoCoder.geocodeAddressString(address) { placemarks, error in
            guard let placemark = placemarks?.first, let location = placemark.location else {
                print("Error converting address to coordinates: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            completion(location.coordinate)
        }
    }

    
    
    
    
    
}
