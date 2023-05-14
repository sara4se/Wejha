//
//  ContentView.swift
//  Wejha
//
//  Created by Sara Alhumidi on 20/10/1444 AH.
//

import SwiftUI

//import LocationBasedAR
import ARKit
import RealityKit
//24.793416, 46.746357
//import ARCL

//struct ARViewContainer: UIViewControllerRepresentable {
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//
//    }
//
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let arView = LBARView(frame: .zero)
//        let configuration: ARWorldTrackingConfiguration = LBARView.defaultConfiguration()
//        let options: ARSession.RunOptions = [
//        ]
//        let location = CLLocation(latitude: 24.793416, longitude: 46.746357)
//        arView.add(location: location)
//
//        let coordinate = CLLocationCoordinate2D(latitude: 24.793416, longitude: 46.746357)
//        let accuracy = CLLocationAccuracy(10) // Set the accuracy to 10 meters
//        let placemark = Placemark(coordinate: coordinate, accuracy: accuracy)
//        let altitude = CLLocationDistance(0)
//        arView.add(placemark: placemark)
//        let transform = simd_float4x4.distanceTransform(Float(2))
//        let name = "My Anchor"
//        let anchor = LBAnchor(name: name, transform: transform, coordinate: coordinate, accuracy: accuracy, altitude: altitude)
//        arView.add(anchor: anchor)
//        let anchorEntity = AnchorEntity(world: SIMD3<Float>(0, 0, -1))
//        arView.scene.addAnchor(anchorEntity)
//
//
//        arView.session.run(configuration, options: options)
//
//        // perform view's configuration
//
////        return arView
//
//
//        let viewController = UIViewController()
//        viewController.view = arView
//        return viewController
//    }
//
//}
//
struct ContentView: View {
   
  // options to run session
   

    var body: some View {
        VStack{
          //  ARViewContainer()
            HStack{
                Text("hi")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View
    {
        ContentView()
    }
}

