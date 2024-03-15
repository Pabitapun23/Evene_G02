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
    
    private let geoCoder = CLGeocoder()
    
    @Published var latitude: Double?
    @Published var longitude: Double?
    
    @Published var didUpdateLocation: Bool = false
    
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
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            let latitude = location.coordinate.latitude
//            let longitude = location.coordinate.longitude
//            print("Latitude: \(latitude), Longitude: \(longitude)")
//            
//            self.latitude = latitude
//            self.longitude = longitude
//        }
//    }
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        // 將位置信息設置到相應的屬性中
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.didUpdateLocation = true // 當位置更新時，將 didUpdateLocation 設置為 true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
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
