//
//  ViewPlacesController.swift
//  Wejha
//
//  Created by Rawan on 26/10/1444 AH.
//

import Foundation
//ViewPlacesController
import GooglePlaces
import UIKit
import SwiftUI
import GoogleMaps

struct GetStartedViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewPlacesController
    
    func makeUIViewController(context: Context) -> ViewPlacesController {
        let viewController = ViewPlacesController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewPlacesController, context: Context) {
        // No need to implement anything here for this example
    }
}
class ViewPlacesController : UIViewController , CLLocationManagerDelegate{
    
    let manager = CLLocationManager()
    
    // Add a pair of UILabels in Interface Builder, and connect the outlets to these variables.
    var nameLabel: String = ""
    var addressLabel: String = ""
    
    private var placesClient: GMSPlacesClient!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        GMSPlacesClient.provideAPIKey("AIzaSyDgXEpiATw1IAcW1T2gYLcwhM8S1v0IHOI")
        placesClient = GMSPlacesClient.shared()
      //  print("License: \n\n\(GMSServices.openSourceLicenseInfo())")
        
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
  

    // Add a UIButton in Interface Builder, and connect the action to this function.
      func getCurrentPlace() {
    let placeFields: GMSPlaceField = [.name, .formattedAddress]
    placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { (placeLikelihoods, error) in
    guard error == nil else {
        print("Current place error: \(error?.localizedDescription ?? "")")
    return
    }

            guard let place = placeLikelihoods?.first?.place else {
                self.nameLabel = "No current place"
                self.addressLabel = ""
                return
            }

        self.nameLabel = place.name ?? ""
        self.addressLabel = place.formattedAddress ?? ""
        }
    }
}

