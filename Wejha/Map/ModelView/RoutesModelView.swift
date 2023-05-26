//
//  ViewPlacesController.swift
//  Wejha
//
//  Created by Rawan on 26/10/1444 AH.
//

import Foundation 
import GooglePlaces
import UIKit
import SwiftUI
import GoogleMaps


//struct RoutesModelViewRepresentable: UIViewRepresentable {
//    typealias UIViewType = RoutesModelVie
//    func makeUIView(context: Context) -> RoutesModelView {
//        // Create and configure the GMSMapView
//        let camera = GMSCameraPosition.camera(withLatitude: 24.861191, longitude: 46.725490, zoom: 12.0)
//        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
//        mapView.settings.myLocationButton = true
//        mapView.isMyLocationEnabled = true
//
//        return RoutesModelView
//    }
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//
//    }
//}
struct RoutesView : View{
    @State private var tDistance: String = ""
    @State private var time: String = ""
    let googleApiKey = "YOUR_GOOGLE_API_KEY"
    
    var mapView: GMSMapView!
    //24.861191, 46.725490
    //24.861762, 46.724032
    var body: some View {
        Text("")
//        MapView()
//            .onAppear {
//                drawGoogleApiDirection()
//                getTotalDistance()
//            }
    }

}
struct RoutesView_Previews: PreviewProvider {
    static var previews: some View {
        RoutesView()
    }
}
//class RoutesDis :Obse
