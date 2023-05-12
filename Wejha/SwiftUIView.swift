//
//  SwiftUIView.swift
//  Wejha
//
//  Created by Sara Alhumidi on 22/10/1444 AH.
//

import SwiftUI
import ARKit
struct ARView : UIViewRepresentable{
    func makeUIView(context: Context) -> some UIView {
        let sceneView = ARSCNView()
        sceneView.showsStatistics = true
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
