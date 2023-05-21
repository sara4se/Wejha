//
//  MapIView.swift
//  Wejha
//
//  Created by Sara Alhumidi on 24/10/1444 AH.
//

import SwiftUI
import GoogleMaps
import UIKit
import CoreLocation
import GooglePlaces
import MapKit


struct MapView: View {
    //24.793105, 46.746623
    //MapLocationViewWrapper()
    @State var locationQuery : String = ""
    @StateObject var locationHandler = PlaceSearch()
    @State var selectedPlace: String?
    var body: some View {
        NavigationView {
                  VStack {
                      MapViewRepresentable(selectedPlace: $selectedPlace)
                  }
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
              }
              .searchable(text: $locationQuery) {
                  ForEach(locationHandler.searchedLocation, id: \.self) { place in
                      Text(place)
                          .onTapGesture {
                              selectedPlace = place
                              locationQuery = "" // Clear the search query
                              UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // Dismiss the keyboard
                          }
                  }
              }
              .onChange(of: locationQuery) { query in
                  locationHandler.searchLocation(query)
              }

    }
}

    
    struct MapView_Previews: PreviewProvider {
        static var previews: some View {
            MapView()
        }
    }
