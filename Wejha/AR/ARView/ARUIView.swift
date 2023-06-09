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
    @State var permissionHandler : PermissionHandler = PermissionHandler(cantOpenCamera: .constant(true))
    var body: some View {
        NavigationView {
//            Text("hello")
            let _ = permissionHandler.requestCameraPermission()
//            SceneLocationViewWrapper(valueToPass: selectedPlace)
//               .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ARUIView_Previews: PreviewProvider {
    static var previews: some View {
        ARUIView(selectedPlace: .constant(""))
    }
}
