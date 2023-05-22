//
//  ARUIView.swift
//  Wejha
//
//  Created by Sara Alhumidi on 24/10/1444 AH.
//

import SwiftUI
import GoogleMaps
struct ARUIView: View {
    @Binding var selectedPlace: String?
    var body: some View {
        SceneLocationViewWrapper(selectedPlace: $selectedPlace)
                //   .edgesIgnoringSafeArea(.all)
    }
}

struct ARUIView_Previews: PreviewProvider {
    static var previews: some View {
        ARUIView(selectedPlace: .constant(""))
    }
}
