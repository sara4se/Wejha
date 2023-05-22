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
    @State var isARViewActive = false // New state variable
    
    var body: some View {
        NavigationView {
            ZStack {
                MapViewRepresentable(selectedPlace: $selectedPlace)
                VStack {
                    Spacer()
                    
                    NavigationLink(destination: ARUIView(selectedPlace: $selectedPlace), isActive: $isARViewActive) {
                        Image(systemName: "arrow.right.circle")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                
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
        .navigationBarTitle("Map")
        .navigationBarItems(trailing: Button("AR") {
            isARViewActive = true // Activate the AR view when the button is tapped
        })
        
    }
}

    
    struct MapView_Previews: PreviewProvider {
        static var previews: some View {
            MapView()
        }
    }
