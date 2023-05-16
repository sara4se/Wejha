//
//  MapModelView.swift
//  Wejha
//
//  Created by Rawan on 25/10/1444 AH.
//

import Foundation
import CoreLocation
import SwiftUI
import GoogleMaps
import UIKit


struct MapLocationViewWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewMapController
     
    func makeUIViewController(context: Context) -> ViewMapController {
        return ViewMapController()
    }
    
    func updateUIViewController(_ uiViewController: ViewMapController, context: Context) {
        // No updates needed for this example
    }
}


struct MapView: UIViewRepresentable {
    var latitude: Double
    var longitude: Double
    var zoom: Float
//    ViewMapController
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        mapView.animate(to: camera)
    }
}

class ViewMapController: UIViewController, CLLocationManagerDelegate{
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
         GMSServices.provideAPIKey("AIzaSyDgXEpiATw1IAcW1T2gYLcwhM8S1v0IHOI")
        
        print("License: \n\n\(GMSServices.openSourceLicenseInfo())")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // coordinate -33.86,151.20 at zoom level 6.
        let coordinate = location.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 6.0)
        // remove self
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
             marker.title = "London"
             marker.snippet = "UK"
             marker.map = mapView

    }
}
