//
//  MapIView.swift
//  Wejha
//
//  Created by Sara Alhumidi on 24/10/1444 AH.
//

import SwiftUI
import GoogleMaps

struct MapView: UIViewRepresentable {
    var latitude: Double
    var longitude: Double
    var zoom: Float
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        mapView.animate(to: camera)
    }
}

struct MapIViewUi: View {
    var body: some View {
        //24.793105, 46.746623
        MapView(latitude: 24.793105, longitude:  46.746623, zoom: 0.4)
    }
}

struct MapIViewUi_Previews: PreviewProvider {
    static var previews: some View {
        MapIViewUi()
    }
}
