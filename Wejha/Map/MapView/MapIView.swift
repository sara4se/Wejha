//
//  MapIView.swift
//  Wejha
//
//  Created by Sara Alhumidi on 24/10/1444 AH.
//

import SwiftUI
import GoogleMaps
import UIKit
import CoreLocation


struct MapView: UIViewRepresentable {
    let apiKey = "AIzaSyDgXEpiATw1IAcW1T2gYLcwhM8S1v0IHOI" // Replace with your own API key
    @ObservedObject var locationManager = LocationManager()
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
            }
        }
    }
    func makeUIView(context: Self.Context) -> GMSMapView {
        // Just default the camera to anywhere (this will be overwritten as soon as myLocation is grabbed
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 20.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.setMinZoom(0, maxZoom: 20)
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = true
        mapView.isIndoorEnabled = false
        
        return mapView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    /*
     func makeUIView(context: Context) -> GMSMapView {
     let camera = GMSCameraPosition.camera(withLatitude: 24.793105, longitude: 46.746623, zoom: 12.0)
     let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
     
     let locationManager = CLLocationManager()
     locationManager.delegate = context.coordinator
     locationManager.requestWhenInUseAuthorization()
     
     context.coordinator.mapView = mapView
     
     return mapView
     }
     */
    func updateUIView(_ mapView: GMSMapView, context: Self.Context) {
        
        // When the locationManager publishes updates, respond to them
        if let myLocation = locationManager.lastKnownLocation {
            mapView.animate(toLocation: myLocation.coordinate)
            print("User's location: \(myLocation)")
        }
    }
}
struct MapIViewUi: View {
        //24.793105, 46.746623
//MapLocationViewWrapper()
    @State private var showingMap = false

       var body: some View {
           Button(action: {
               showingMap = true
           }) {
               Text("Show Map")
           }
           .sheet(isPresented: $showingMap) {
               MapView()
           }
       }
    }


struct MapIViewUi_Previews: PreviewProvider {
    static var previews: some View {
        MapIViewUi()
    }
}
