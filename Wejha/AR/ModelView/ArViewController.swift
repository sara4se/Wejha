//
//  ArViewController.swift
//  Wejha
//
//  Created by Sara Alhumidi on 17/11/1444 AH.
//

import Foundation
import CoreLocation
import UIKit
import ARKit_CoreLocation
import MapKit
import GoogleMaps
import GooglePlaces
//import ARCL
import SceneKit
import SwiftUI
import ARKit

class ARViewController: UIViewController, CLLocationManagerDelegate, ARSCNViewDelegate , ARSessionDelegate{
     
    var place :String!
    var mapButton: UIButton!
    var arButton: UIButton!
    var sceneLocationView = SceneLocationView()
    @ObservedObject var manger = LocationManager()
     var locationManager = CLLocationManager()
    var mapButtonAction: (() -> Void)? // Closure property for button action
    var arButtonAction: (() -> Void)? // Closure property for button action
    //    arrowNode.startRotationAnimation360()
    let arrowNode = ArrowNode()
    let scene = SCNScene()
    @State private var rotationAngle: Double = 0.0
    var currentHeading: Double = 0.0
    var targetLocation: CLLocation? // Add this line to declare targetLocation
        
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneLocationView.scene = scene
        arrowNode.position = SCNVector3(0, 0, -1)
        sceneLocationView.scene.rootNode.addChildNode(arrowNode)
           mapButton = UIButton(type: .custom)
           mapButton.setImage(UIImage(named: "MapButtonActive"), for: .normal)
           mapButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
           mapButton.frame = CGRect(x: 20, y: 20, width: 100, height: 40)
           
            // Create and configure the AR button
            arButton = UIButton(type: .custom)
            arButton.setImage(UIImage(named: "ArButtonDisable"), for: .normal)
            arButton.addTarget(self, action: #selector(arButtonTapped), for: .touchUpInside)
            
            // Add buttons to the AR view
            sceneLocationView.scene.rootNode.addChildNode(arrowNode)
            sceneLocationView.addSubview(mapButton)
            sceneLocationView.addSubview(arButton)
             

        sceneLocationView.run()
        self.view.addSubview(sceneLocationView)
        
        self.title = self.place
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingHeading()
        sceneLocationView.session.delegate = self
        findLocalPlaces()
    }
    @objc private func mapButtonTapped() {
            // Handle map button tap action
        mapButtonAction?()
        }
        
        @objc private func arButtonTapped() {
            // Handle AR button tap action
            arButtonAction?()
            print("AR button tapped!")
        }
    
//    func moveArrowWithHeading(heading: Double) {
//        // Convert heading from degrees to radians
//        let headingRadians = GLKMathDegreesToRadians(Float(33))
//         // Rotate the arrow node around the y-axis
//        self.arrowNode.eulerAngles.y = 33
//        print("headingRadians : \(headingRadians)")
//    }
//
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        / Position the buttons within the AR view
        let buttonSize = CGSize(width: 50, height: 50)
        let buttonPadding: CGFloat = 1
        let totalButtonHeight = buttonSize.height * 2 + buttonPadding
        let paddingFromTop: CGFloat = 40
        let paddingFromRight: CGFloat = 30
        let buttonOriginY = paddingFromTop
        let buttonOriginX = sceneLocationView.bounds.width - buttonSize.width - paddingFromRight
        mapButton.frame = CGRect(x: buttonOriginX, y: buttonOriginY, width: buttonSize.width, height: buttonSize.height)
        arButton.frame = CGRect(x: buttonOriginX, y: buttonOriginY + buttonSize.height + buttonPadding, width: buttonSize.width, height: buttonSize.height)
        sceneLocationView.frame = self.view.bounds
    }
    
    private func findLocalPlaces() {
        
        guard let location = self.locationManager.location else {
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = place
        
        var region = MKCoordinateRegion()
        region.center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            
            if error != nil {
                return
            }
            
            guard let response = response else {
                return
            }
        
            for item in response.mapItems {
           
                print((item.placemark))
                
                let placeLocation = (item.placemark.location)!
                self.targetLocation = placeLocation
                let placeAnnotationNode = PlaceAnnotation(location: placeLocation, title: item.placemark.name!)
                let arrowAnnotationNode = PlaceAnnotation(location: self.targetLocation, title: "this is your place")
                
                DispatchQueue.main.async {
                     self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: placeAnnotationNode)
                //    self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: arrowAnnotationNode)
//                    self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: arrowNode)
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneLocationView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneLocationView.session.pause()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading,didUpdateLocations locations: [CLLocation]) {
       
            
         // Update the current heading
        if let target = targetLocation {
           let userLocation = CLLocation(latitude: manager.location?.coordinate.latitude ?? 0.0, longitude: manager.location?.coordinate.longitude ?? 0.0)
            let distance = userLocation.distance(from: target)
            // Move the arrow closer to the target location
            let translation = SCNVector3(x: 0.0, y: 0.0, z: -Float(distance))
            arrowNode.simdPosition += simd_float3(translation)
            
            let bearing = userLocation.bearing(between: target) // Custom method to calculate bearing angle
            arrowNode.eulerAngles.y = Float(-GLKMathDegreesToRadians(Float(bearing)))
            }
         currentHeading = newHeading.trueHeading
     }
     
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
         // Update the arrow's position or orientation based on the current heading

         // Convert heading from degrees to radians
         let headingRadians = GLKMathDegreesToRadians(Float(currentHeading))

         // Calculate the translation vector based on the heading
         let translation = SCNVector3(x: 0.0, y: 0.0, z: -headingRadians) // Example translation along the negative z-axis

         // Apply the translation to the arrow node
         arrowNode.simdPosition += simd_float3(translation)

         // Rotate the arrow node to match the heading
         arrowNode.eulerAngles.y = Float(-headingRadians)
     }
     
}
 
struct ARViewControllerWrapper: UIViewControllerRepresentable {
    var place: String
    @State var isARViewActive = false // New state variable
    @State var isMapActive = false
    @State private var tDistance: String = ""
    @State private var time: String = ""
    @State private var places: [Spical] = []
    @ObservedObject var locationManager = LocationManager()
    
    func makeUIViewController(context: Context) -> ARViewController {
        let arViewController = ARViewController()
        arViewController.place = place
       // arViewController.moveArrowWithHeading(heading:  locationManager.heading)
         //arViewController.moveRightAction(angle: Float(locationManager.heading))
        //print("Current heading:\(locationManager.heading)")
//        arViewController.moveLeftAction()
//        arViewController.moveUpAction()
        arViewController.mapButtonAction = {
            arViewController.mapButton.isEnabled = true
            arViewController.arButton.isEnabled = false
                    // Navigate to MapUIView when the map button is tapped
               navigateToMap()
      }
        arViewController.arButtonAction = {
                  // Perform AR button action
        }
        return arViewController
    }
    
    func updateUIViewController(_ uiViewController: ARViewController, context: Context){
        // Update the view controller if needed
//        locationManager.startUpdatingHeading()
        let arViewController = ARViewController()
        arViewController.place = place
        arViewController.locationManager.startUpdatingLocation()
       // arViewController.moveRightAction(angle: Float(locationManager.heading))
//        arViewController.moveLeftAction()
//        arViewController.moveUpAction()
    }
    func navigateToMap() {
        // Navigate to MapUIView
        // You can present the view or push it onto a navigation stack here
        // Example:
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        let mapUIView = MapUIView()
             let hostingController = UIHostingController(rootView: mapUIView)
             window.rootViewController = hostingController
             window.makeKeyAndVisible()
    }

}

extension CLLocation {
    func bearing(to destination: CLLocation) -> Double {
        let lat1 = self.coordinate.latitude.toRadians()
        let lon1 = self.coordinate.longitude.toRadians()
        let lat2 = destination.coordinate.latitude.toRadians()
        let lon2 = destination.coordinate.longitude.toRadians()
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        var radiansBearing = atan2(y, x)
        
        if radiansBearing < 0.0 {
            radiansBearing += 2 * Double.pi
        }
        
        return radiansBearing.toDegrees()
    }
}

extension Double {
    func toRadians() -> Double {
        return self * Double.pi / 180.0
    }
    
    func toDegrees() -> Double {
        return self * 180.0 / Double.pi
    }
}
