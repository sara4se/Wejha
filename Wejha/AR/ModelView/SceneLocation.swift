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
struct SceneLocationViewWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
    @Binding var selectedPlace: String?

   
    init(selectedPlace: Binding<String?>) {
        self._selectedPlace = selectedPlace
    }
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController(selectedPlace: $selectedPlace)
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // No updates needed for this example
    }
}

class ViewController: UIViewController {
    var sceneLocationView = SceneLocationView()
    @Binding var selectedPlace: String?
   
    init(selectedPlace: Binding<String?>) {
         self._selectedPlace = selectedPlace
         super.init(nibName: nil, bundle: nil) // Call the superclass initializer
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    //
    override func viewDidLoad(){
      super.viewDidLoad()
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
//        ARINIT(selectedPlace: selectedPlace ?? "")
        ARINITWithMarked()
    }

    
    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      sceneLocationView.frame = view.bounds
    }
    
    //take the place from search then try to find it from the places api then start drow location from my location to the distntion
    
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
