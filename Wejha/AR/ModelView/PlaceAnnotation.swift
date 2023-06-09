//
//  PlaceAnnotation.swift
//  Wejha
//
//  Created by Sara Alhumidi on 17/11/1444 AH.
//

import Foundation
//import ARCL

import CoreLocation
import SceneKit
import ARKit_CoreLocation
import SwiftUI

class PlaceAnnotation : LocationNode {
    
    var title :String!
    var annotationNode :SCNNode
    
    init(location :CLLocation?, title: String) {
        
        self.annotationNode = SCNNode()
        self.title = title
        super.init(location: location)
        
        
        initializeUI()
    }
    
    private func center(node: SCNNode) {
        
        let (min,max) = node.boundingBox
        let dx = min.x + 0.5 * (max.x - min.x)
        let dy = min.y + 0.5 * (max.y - min.y)
        let dz = min.z + 0.5 * (max.z - min.z)
        node.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
    }
 
    private func initializeUI() {
        
        let plane = SCNPlane(width: 194, height: 85)
        plane.cornerRadius = 50
        plane.firstMaterial?.diffuse.contents = UIColor(named: "#32C25B")?.withAlphaComponent(22)
        //Color("32C25B").opacity(0.8)
        
        let text = SCNText(string: self.title, extrusionDepth: 0)
        text.containerFrame = CGRect(x: 0, y: 0, width: 50, height: 30)
        text.isWrapped = true
        text.font = UIFont(name: "Futura", size: 15.0)
        text.alignmentMode = CATextLayerAlignmentMode.center.rawValue
                text.truncationMode = CATextLayerTruncationMode.middle.rawValue
                text.firstMaterial?.diffuse.contents = UIColor(named: "#32C25B")
        //
        text.firstMaterial?.diffuse.contents = UIColor(named: "#32C25B")?.withAlphaComponent(22)
        
        let textNode = SCNNode(geometry: text)
        textNode.position = SCNVector3(0, 0, 0.2)
        center(node: textNode)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.addChildNode(textNode)
        
        self.annotationNode.scale = SCNVector3(3,3,3)
        self.annotationNode.addChildNode(planeNode)
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        self.addChildNode(self.annotationNode)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//class PlaceAnnotationView: LocationNode, UIViewControllerRepresentable {
//
////    typealias UIViewControllerType = SCNView
//
//
////    func makeUIViewController(context: Context) -> ArViewController {
////
////    }
////
////    func updateUIViewController(_ uiViewController: ArViewController, context: Context) {
////
////    }
////
//    var title :String!
//    var annotationNode :SCNNode
//    init(location :CLLocation?, title: String) {
//        self.annotationNode = SCNNode()
//        self.title = title
//        super.init(location: location)
//     }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    func makeUIViewController(context: Context) -> SCNView {
//        let sceneView = SCNView()
//        sceneView.scene = SCNScene()
//
//        let annotationNode = SCNNode()
//        annotationNode.position = SCNVector3(x: 0, y: 0, z: 0)
//        sceneView.scene?.rootNode.addChildNode(annotationNode)
//
//        let plane = SCNPlane(width: 194, height: 85)
//        plane.cornerRadius = 50
//        plane.firstMaterial?.diffuse.contents = Color("32C25B").opacity(0.8)
//        //
//
//        let text = SCNText(string: self.title, extrusionDepth: 0)
//        text.containerFrame = CGRect(x: 0, y: 0, width: 50, height: 30)
//        text.isWrapped = true
//        text.font = UIFont(name: "Futura", size: 15.0)
//        text.alignmentMode = CATextLayerAlignmentMode.center.rawValue
//        text.truncationMode = CATextLayerTruncationMode.middle.rawValue
//        text.firstMaterial?.diffuse.contents = UIColor.white
//
//        let textNode = SCNNode(geometry: text)
//        textNode.position = SCNVector3(0, 0, 0.2)
//      // textNode.position = textNode.position + textNode.geometry?.center() ?? SCNVector3Zero
//
//
//        let planeNode = SCNNode(geometry: plane)
//        planeNode.addChildNode(textNode)
//
//        annotationNode.scale = SCNVector3(3, 3, 3)
//        annotationNode.addChildNode(planeNode)
//
//        let billboardConstraint = SCNBillboardConstraint()
//        billboardConstraint.freeAxes = SCNBillboardAxis.Y
//        annotationNode.constraints = [billboardConstraint]
//
//        return sceneView
//    }
//
//    func updateUIViewController(_ uiView: SCNView, context: Context) {
//        // Update the view if needed
//    }
//}
////PlaceAnnotationView(title: "Example Annotation")
////                .frame(width: 300, height: 300, alignment: .center)
////extension Color {
////    init?(hex: String, alpha: Double = 1.0) {
////        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
////
////        if hexFormatted.hasPrefix("#") {
////            hexFormatted.remove(at: hexFormatted.startIndex)
////        }
////
////        if hexFormatted.count != 6 {
////            return nil
////        }
////
////        var rgbValue: UInt64 = 0
////        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
////
////        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
////        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
////        let blue = Double(rgbValue & 0x0000FF) / 255.0
////
////        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
////    }
////}
////////tuekdsodkfkdfkkfsf
////extension SCNGeometry {
////    func center() -> SCNVector3? {
////        if let (min, max) = boundingBox {
////            let dx = min.x + 0.5 * (max.x - min.x)
////            let dy = min.y + 0.5 * (max.y - min.y)
////            let dz = min.z + 0.5 * (max.z - min.z)
////            return SCNVector3(dx, dy, dz)?
////        }
////        else { return nil }
////    }
////}
//
//
