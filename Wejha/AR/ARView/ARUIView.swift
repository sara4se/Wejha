//
//  ARUIView.swift
//  Wejha
//
//  Created by Sara Alhumidi on 24/10/1444 AH.
//

import SwiftUI
import GoogleMaps
struct ARUIView: View {
    var body: some View {
        SceneLocationViewWrapper()
                //   .edgesIgnoringSafeArea(.all)
    }
}

struct ARUIView_Previews: PreviewProvider {
    static var previews: some View {
        ARUIView()
    }
}
