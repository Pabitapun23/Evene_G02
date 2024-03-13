//
//  MapView.swift
//  Evene
//
//  Created by Pabita Pun on 2024-03-13.
//

import SwiftUI
import MapKit

struct MapView : UIViewRepresentable{
    
    typealias UIViewType = MKMapView
    
    private var location : CLLocation
    @EnvironmentObject var locationHelper : LocationHelper
    let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    
    init(location : CLLocation){
        self.location = location
    }
    
    func makeUIView(context: Context) -> MKMapView {
        
        let sourceCoordinates : CLLocationCoordinate2D
        let region : MKCoordinateRegion
        
        if (self.locationHelper.currentLocation != nil){
            sourceCoordinates = self.locationHelper.currentLocation!.coordinate
        }else{
            sourceCoordinates = CLLocationCoordinate2D(latitude: 43.64732, longitude: -79.38279)
        }
        
        region = MKCoordinateRegion(center: sourceCoordinates, span: span)
        
        let map = MKMapView(frame: .infinite)
        map.mapType = MKMapType.standard
        map.isZoomEnabled = true
        map.isUserInteractionEnabled = true
        map.showsUserLocation = true
        
        map.setRegion(region, animated: true)
        
        return map
        
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        let sourceCoordinates : CLLocationCoordinate2D
        let region : MKCoordinateRegion
        
        if (self.locationHelper.currentLocation != nil){
            sourceCoordinates = self.locationHelper.currentLocation!.coordinate
        }else{
            sourceCoordinates = CLLocationCoordinate2D(latitude: 43.64732, longitude: -79.38279)
        }
        
        region = MKCoordinateRegion(center: sourceCoordinates, span: span)
        
        let mapAnnotation = MKPointAnnotation()
        mapAnnotation.coordinate = sourceCoordinates
        mapAnnotation.title = "You're here !"
        
        uiView.setRegion(region, animated: true)
        uiView.addAnnotation(mapAnnotation)
        
    }
    
}



//#Preview {
//    MapView(location: CLLocation(latitude: CLLocationDegrees, longitude: <#T##CLLocationDegrees#>))
//}

