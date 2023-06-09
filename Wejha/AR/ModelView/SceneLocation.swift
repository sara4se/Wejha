//
//  File.swift
//  Wejha
//
//  Created by Sara Alhumidi on 24/10/1444 AH.
//

import Foundation
import ARKit_CoreLocation
import CoreLocation
import UIKit
import SceneKit
import SwiftUI
import GooglePlaces
import MapKit
import UIKit

///
struct SceneLocationViewWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
   
    @Binding var valueToReceive: String
    init(valueToReceive: Binding<String>) {
        self._valueToReceive = valueToReceive
    }
    
    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController(valueToPass: valueToReceive)
    //    viewController.valueToPass = valueToReceive
        return viewController
    
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // No updates needed for this example
    }
}

class ViewController: UIViewController ,CLLocationManagerDelegate {
    var sceneLocationView = SceneLocationView()
//    @Binding var selectedPlace: String?
    var valueToPass: String
    let locationManager = CLLocationManager()
    let token = GMSAutocompleteSessionToken.init()
    let client = GMSPlacesClient()
    let googleApiKey = "AIzaSyDgXEpiATw1IAcW1T2gYLcwhM8S1v0IHOI"
    init(valueToPass:  String) {
         self.valueToPass = valueToPass
         super.init(nibName: nil, bundle: nil) // Call the superclass initializer
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    
    override func viewDidLoad(){
      super.viewDidLoad()
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
//        ARINIT2(selectedPlace: selectedPlace )
        
        ARINITWithGoogleMap(selectedPlace:valueToPass)
        print("nil valueToReceive\(valueToPass)")
        locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
     //   ARINITWithMarked()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return
        }

        // Use the current location for further processing
        // For example, you can store it in a property or pass it to other methods
        // ...

        // Stop updating location if you don't need continuous updates
        locationManager.stopUpdatingLocation()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      sceneLocationView.frame = view.bounds
    }
    
    //take the place from search then try to find it from the places api then start drow location from my location to the distntion
    func ARINIT2(selectedPlace: String) {
        // Create a location variable to store the selected location
        var location: CLLocation?
       
        // Define the completion handler for place details fetching
        let placeDetailsCompletionHandler: GMSPlaceResultCallback = { (place, error) in
            if let error = error {
                print("Error fetching place details: \(error.localizedDescription)")
            }

            if let place = place {
                // Use the place's coordinate and altitude to create a CLLocation
                location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)

                // Calculate the route between the current location and the selected location
                guard let currentLocation = self.locationManager.location else {
                    return
                }
                
                let sourcePlacemark = MKPlacemark(coordinate: currentLocation.coordinate)
                let destinationPlacemark = MKPlacemark(coordinate: place.coordinate)

                let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
                let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

                let directionRequest = MKDirections.Request()
                directionRequest.source = sourceMapItem
                directionRequest.destination = destinationMapItem
                directionRequest.transportType = .walking

                let directions = MKDirections(request: directionRequest)
                directions.calculate { (response, error) in
                    guard let route = response?.routes.first else {
                        return
                    }

                    // Create annotation nodes along the route
                    let steps = route.steps
                    for step in steps {
                        let stepLocation = CLLocation(latitude: step.polyline.coordinate.latitude, longitude: step.polyline.coordinate.longitude)
                        let annotationNode = LocationAnnotationNode(location: stepLocation, image: UIImage(named: "Pin")!)
                        annotationNode.annotationNode.name = step.instructions
                        self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
                    }
                }
            }
        }

        // Retrieve the place details for the selected place using the place ID
        let placesClient = GMSPlacesClient()
        placesClient.fetchPlace(fromPlaceID: "Makkah", placeFields: .coordinate, sessionToken: nil, callback: placeDetailsCompletionHandler)
        
        
    }
    
    func ARINITWithGoogleMap(selectedPlace: String) {
         
          print(" print selectedPlace \(selectedPlace)")
            client.findAutocompletePredictions(fromQuery: "makkah"
                                               , filter: .none, sessionToken: token) { results, error in
                if let error = error {
                    print("Error find predictions : \(error.localizedDescription)")
                }
                guard let results = results else {return}
                for result in results {
//
                        // Fetch place details using the placeID
                        let placesClient = GMSPlacesClient()
                        placesClient.fetchPlace(fromPlaceID: result.placeID, placeFields: .coordinate, sessionToken: nil) { place, error in
                            if let error = error {
                                print("Error fetching place details: \(error.localizedDescription)")
                                return
                            }
                            
                            if let place = place {
                                let latitude = place.coordinate.latitude
                                let longitude = place.coordinate.longitude
                                
                                print("Place coordinates: latitude \(latitude), longitude \(longitude)")
                                
                                // Do further processing with latitude and longitude here
                                
                                
                                // Calculate the route between the current location and the selected location
                                guard let currentLocation = self.locationManager.location else {
                                    return
                                }
                                
                                
                                
                                let session = URLSession.shared
                                
                                
                                //        arViewController.moveArrowWithHeading(heading: heading)
                                let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)&destination=\(place.coordinate.latitude),\(place.coordinate.longitude)&sensor=true&mode=walking&alternatives=true&key=\(self.googleApiKey)")!
                                let task = session.dataTask(with: url, completionHandler: {
                                    (data, response, error) in
                                    
                                    guard error == nil else {
                                        print(error!.localizedDescription)
                                        return
                                    }
                                    
                                    guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
                                        
                                        print("error in JSONSerialization")
                                        return
                                        
                                    }
                                    //  print("jsonResult :\(jsonResult)")
                                    
                                    guard let routes = jsonResult["routes"] as? [Any], !routes.isEmpty else {
                                        print("No routes found.")
                                        return
                                    }
                                    
                                    guard routes[0] is [String: Any] else {
                                        print("Invalid route data.")
                                        return
                                    }
                                    
                                    
                                    
                                    guard let route = routes[0] as? [String: Any] else {
                                        return
                                    }
                                    
                                    guard let legs = route["legs"] as? [Any] else {
                                        return
                                    }
                                    
                                    guard let leg = legs[0] as? [String: Any] else {
                                        return
                                    }
                                    
                                    guard let steps = leg["steps"] as? [Any] else {
                                        return
                                    }
                                    for item in steps {
                                        guard let step = item as? [String: Any] else {
                                            return
                                        }
                                        
                                        guard let polyline = step["polyline"] as? [String: Any] else {
                                            return
                                        }
                                        
                                        guard let polyLineString = polyline["points"] as? String else {
                                            return
                                        }
                                        
                                        guard let startLocation = step["start_location"] as? [String: Any],
                                              let latitude = startLocation["lat"] as? CLLocationDegrees,
                                              let longitude = startLocation["lng"] as? CLLocationDegrees else {
                                            return
                                        }
                                        
                                        let stepLocation = CLLocation(latitude: latitude, longitude: longitude)
                                        
                                        DispatchQueue.main.async {
                                            // Add pin annotation to the step location
                                            let annotationNode = LocationAnnotationNode(location: stepLocation, 
                                                                                        image: UIImage(named: "Pin")!)
                                            annotationNode.annotationNode.name = step["instructions"] as? String
                                            self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
                                        }
                                    }
                                    
                                })
                                task.resume()
                            }
                        }
                    }
                }
        
    }
  
    func ARINIT(selectedPlace:String) {
        // Create a location variable to store the selected location
        var location: CLLocation?
        
        // Define the completion handler for place details fetching
        let placeDetailsCompletionHandler: GMSPlaceResultCallback = { (place, error) in
            if let error = error {
                print("Error fetching place details: \(error.localizedDescription)")
            }
            
            if let place = place {
                // Use the place's coordinate and altitude to create a CLLocation
                location = CLLocation(coordinate: place.coordinate, altitude: 100)
                
                // Create an annotation node using the selected place's name and image
                let annotationNode = LocationAnnotationNode(location: location!, image: UIImage(named: "Pin")!)
                annotationNode.annotationNode.name = place.name
                self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
            }
        }
        
        // Retrieve the place details for the selected place using the place ID
   
            let placesClient = GMSPlacesClient()
            placesClient.fetchPlace(fromPlaceID: selectedPlace, placeFields: .coordinate, sessionToken: nil, callback: placeDetailsCompletionHandler)
        
    }

    
    func ARINITWithMarked()  { // Test locations around me. you can also plot these using google place API

            var location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 28.610497, longitude: 77.360733), altitude: 0) // ISKPRO
            let image = UIImage(named: "Pin")!
            var annotationNode = LocationAnnotationNode(location: location, image: image)
            annotationNode.annotationNode.name = "ISKPRO"
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)

            location  = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 28.610413, longitude: 77.358863), altitude: 100) // Un named next to ISKPRO
            annotationNode = LocationAnnotationNode(location: location, image: image)
            annotationNode.annotationNode.name = "Next to ISKPRO"
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)

            location  = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 28.6101371, longitude: 77.3433248), altitude: 100) // R Systems
            annotationNode = LocationAnnotationNode(location: location, image: image)
            annotationNode.annotationNode.name = "R Systems"
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)

            location  = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 28.604624, longitude: 77.3717694), altitude: 100) // Mamura
            annotationNode = LocationAnnotationNode(location: location, image: image)
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)

            location  = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 28.6191904, longitude: 77.4209194), altitude: 100) // Gaur City
            annotationNode = LocationAnnotationNode(location: location, image: image)
            annotationNode.annotationNode.name = "Gaur City"
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)


            annotationNode = LocationAnnotationNode(location: nil, image: image)
            sceneLocationView.addLocationNodeForCurrentPosition(locationNode:annotationNode) // Current location
            annotationNode.annotationNode.name = "My location"

        }
    
    
    // MARK: - SceneLocationViewDelegate
   
}

@available(iOS 11.0, *)
extension ViewController: SceneLocationViewDelegate {
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        print("add scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
    }
    
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        print("remove scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
    }
    
    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
        print("7845768")
    }
    
    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {
        print("546456")
    }
    
    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {
    }
}
 
import UIKit

class PathView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        // Customize the appearance of the path view
        backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        layer.cornerRadius = 4.0
        // Add any other customization as needed
    }
}
