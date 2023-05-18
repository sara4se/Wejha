//
//  File.swift
//  Wejha
//
//  Created by Sara Alhumidi on 24/10/1444 AH.
//

import Foundation
import ARCL
import CoreLocation
import UIKit
import SceneKit
import SwiftUI

struct SceneLocationViewWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
    
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // No updates needed for this example
    }
}

class ViewController: UIViewController {
    var sceneLocationView = SceneLocationView()
    
    
    //
    override func viewDidLoad() {
      super.viewDidLoad()

      sceneLocationView.run()
      view.addSubview(sceneLocationView)
        ARINIT()
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
    
    
    
    
    
    func ARINIT()  { // Test locations around me. you can also plot these using google place API
           
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
