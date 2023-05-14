//
//  SwiftUIView.swift
//  Wejha
//
//  Created by Sara Alhumidi on 22/10/1444 AH.
//

import SwiftUI
import ARKit
import CoreLocation
struct ARView : UIViewRepresentable{
    func makeUIView(context: Context) -> some UIView {
        let sceneView = ARSCNView()
        sceneView.showsStatistics = true
        
        
        let scene = SCNScene(named: "image")!
        sceneView.scene = scene
        let config = ARWorldTrackingConfiguration()
        sceneView.session.run(config)
        
        
        return sceneView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
struct SwiftUIView: View {
    var body: some View {
        ARView()
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}


/*
 //
 //  SwiftUIView.swift
 //  Wejha
 //
 //  Created by Sara Alhumidi on 22/10/1444 AH.
 //

 import SwiftUI
 import ARKit
 import RealityKit
 struct ARViewContainer2 : UIViewRepresentable{
     
     func makeUIView(context: Context) -> ARView {
         let arView = ARView(frame : .zero)
         let anchor = AnchorEntity(plane: .horizontal)
         let material = SimpleMaterial(color: .blue, isMetallic : true)
         let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.3), materials: [material])
         anchor.addChild(box)
         arView.scene.anchors.append(anchor)
         return arView
     }
     
 //    func makeUIView(context: Context) -> some UIView {
 //        let sceneView = ARSCNView()
 //        sceneView.showsStatistics = true
 //
 //
 //        let scene = SCNScene(named: "image")!
 //        sceneView.scene = scene
 //        let config = ARWorldTrackingConfiguration()
 //        sceneView.session.run(config)
 //
 //
 //        return sceneView
 //    }
     func updateUIView(_ uiView: UIViewType, context: Context) {
         
     }
 }
 struct SwiftUIView: View {
     var body: some View {
         return ARViewContainer2().edgesIgnoringSafeArea(.all)
     }
 }

 struct SwiftUIView_Previews: PreviewProvider {
     static var previews: some View {
         SwiftUIView()
     }
 }

 */
