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

 
class ViewMapController: UIViewController, CLLocationManagerDelegate{
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        //GMSServices.provideAPIKey("AIzaSyDgXEpiATw1IAcW1T2gYLcwhM8S1v0IHOI")
//
   //     print("License: \n\n\(GMSServices.openSourceLicenseInfo())")
        
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
