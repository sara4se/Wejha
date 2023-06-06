////
////  SwiftUIView202.swift
////  Wejha
////
////  Created by Sara Alhumidi on 17/11/1444 AH.
////
//
//import SwiftUI
//import RealityKit
//import SceneKit
//import ARKit
//
//class ArrowNode: SCNNode {
//    override init() {
//        super.init()
//        
//        let arrowGeometry = SCNPyramid(width: 0.1, height: 0.2, length: 0.05)
//        let arrowMaterial = SCNMaterial()
//        arrowMaterial.diffuse.contents = UIColor.red
//        arrowGeometry.materials = [arrowMaterial]
//        
//        geometry = arrowGeometry
//        position = SCNVector3(0, 0, -1) // Adjust the initial position as needed
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func updateRotation(withHeading heading: Double) {
//        let headingInRadians = heading.degreesToRadians
//        let rotation = SCNVector3(0, headingInRadians, 0)
//        eulerAngles = rotation
//    }
//}
//
//extension Double {
//    var degreesToRadians: Double { return self * .pi / 180 }
//}
//import SwiftUI
//import RealityKit
//
//struct ARViewContainer: UIViewRepresentable {
//    func makeUIView(context: Context) -> ARView {
//        let arView = ARView(frame: .zero)
//        
//        // Create the arrow entity
//        let arrowEntity = try! ModelEntity.load(named: "arrow.usdz")
//        
//        // Add the arrow entity to the scene
//        let anchor = AnchorEntity()
//        anchor.addChild(arrowEntity)
//        arView.scene.addAnchor(anchor)
//        
//        return arView
//    }
//    
//    func updateUIView(_ uiView: ARView, context: Context) {
//        // Update the AR view or perform any necessary updates
//    }
//}
//
//struct ContentView202: View {
//    var body: some View {
//        ARViewContainer()
//            .edgesIgnoringSafeArea(.all)
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
