//
//  MapModelView.swift
//  Wejha
//
//  Created by Sara Alhumidi on 24/10/1444 AH.
//

import Foundation
import CoreLocation
import SwiftUI
import GoogleMaps
import UIKit
import CoreLocation
import GooglePlaces

 
struct MapViewRepresentable: UIViewRepresentable {
    @ObservedObject var locationManager = LocationManager()
    @Binding var selectedPlace: String?
   
    //var searchResults: [Place]
    class Coordinator: NSObject, CLLocationManagerDelegate {
        var mapView: GMSMapView?
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                mapView?.animate(toLocation: location.coordinate)
            }
        }
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse {
                manager.startUpdatingLocation()
                mapView?.isMyLocationEnabled = true
                mapView?.settings.myLocationButton = true
                mapView?.settings.compassButton = true
                mapView?.settings.rotateGestures = true
                mapView?.settings.scrollGestures = true
                mapView?.settings.tiltGestures = true
                mapView?.settings.zoomGestures = true
                //                mapView?.camera = GMSCameraPosition(target: manager.location!.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            }
        }
    }
    
    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView(frame: .zero)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.settings.rotateGestures = true
        mapView.settings.scrollGestures = true
        mapView.settings.tiltGestures = true
        mapView.settings.zoomGestures = true
        mapView.isIndoorEnabled = true
        mapView.settings.indoorPicker = true
        mapView.delegate = context.coordinator as? any GMSMapViewDelegate
        
        return mapView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.clear()
        
        if let selectedPlace = selectedPlace {
            let placesClient = GMSPlacesClient()
            
            placesClient.findAutocompletePredictions(fromQuery: selectedPlace , filter: GMSAutocompleteFilter(), sessionToken: nil) { predictions, error in
                guard let prediction = predictions?.first else { return }
                
                placesClient.fetchPlace(fromPlaceID: prediction.placeID, placeFields: .coordinate, sessionToken: nil) { (fetchedPlace, error) in
                    guard let coordinate = fetchedPlace?.coordinate else { return }
                    let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
                    mapView.animate(to: camera)
                }
            }
        }
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {

    // Publish the user's location so subscribers can react to updates
    @Published var lastKnownLocation: CLLocation? = nil
    private let manager = CLLocationManager()

    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Notify listeners that the user has a new location
        self.lastKnownLocation = locations.last
    }
}

 
