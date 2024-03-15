//
//  LocationManager.swift
//  Evene
//
//  Created by Alfie on 2024/3/14.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    @Published var latitude: Double?
    @Published var longitude: Double?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location authorization granted")
        case .denied, .restricted:
            print("Location authorization denied")
        case .notDetermined:
            print("Location authorization not determined")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("Latitude: \(latitude), Longitude: \(longitude)")
            
            self.latitude = latitude
            self.longitude = longitude
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}
