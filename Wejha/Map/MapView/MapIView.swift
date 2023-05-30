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
//

//struct MapView: View {
//    //24.793105, 46.746623
//    //MapLocationViewWrapper()
//    @State var locationQuery : String = ""
//    @StateObject var locationHandler = PlaceSearch()
//    @State var selectedPlace: String?
//    @State var isARViewActive = false // New state variable
//    @State var presentSheet = true
//    @State private var searchText = ""
//    @State private var tDistance: String = ""
//    @State private var time: String = ""
//    var category = Category()
////    @ObservedObject
//   // @State var MVR = MapViewRepresentable( tDistance:  .constant(""), time: .constant(""))
//    var body: some View {
//        NavigationView {
//           
//                    
//                    //                    .onAppear{
//                    //                    MVR.drawGoogleApiDirection()
//                    //                    MVR.getTotalDistance()
//                    //                }
//                    //   RoutesView()
//                    VStack {
////                        Button("Modal") {
////                            presentSheet = true
////                        }
////                        MapViewRepresentable(tDistance: $tDistance, time: $time, markers: )
//                        NavigationLink(destination: ARUIView(selectedPlace: $selectedPlace), isActive: $isARViewActive) {
//                            Image(systemName: "arrow.right.circle")
//                                .font(.largeTitle)
//                                .foregroundColor(.white)
//                        }
//                        .padding()
//                    }
//                    .onChange(of: locationQuery) { query in
//                        locationHandler.searchLocation(query)
//                    }
//                    .navigationBarTitle("Map")
//                    .navigationBarItems(trailing: Button("AR") {
//                        isARViewActive = true // Activate the AR view when the button is tapped
//                    })
//                
//            
//        }
//        .bottomSheet(
//            presentationeDetents: [.fraction(0.30), .medium, .large],
//            isPresented: .constant(true),
//            sheetCornerRadius: 20,
//            isTransparentBG: true // Set isTransparentBG to true
//        ) {
//            //MARK: building sheet UI
////            .bottomSheet(presentationeDetents: [.fraction(0.30),.medium,.large], isPresented:.constant(true), sheetCornerRadius: 20){
//                NavigationView {
//                
//                //categories
//                let items = ["ksks","skms"]
//                
//                VStack(spacing: 10){
//             
//                
//                    ScrollView() {
//                        
//                        
//                        LazyVGrid(columns: [
//                            GridItem(.flexible()),
//                            GridItem(.flexible()),
//                            GridItem(.flexible())]){
//                        
//                            ForEach(items, id: \.self) { item in
//                               
//    //                            Button{
//    //
//    //                            } label: {
//                                NavigationLink {categoryContent()}
//                            label: {
//                                HStack{
//                                    VStack(spacing:1){
//                                        Circle()
//                                        //  .clipShape(Circle())
//                                            .frame(width: 69 ,height: 69)
//                                            .cornerRadius(8)
//                                            .padding()
//                                        Text("\(item)")
//                                        
//                                    }//Vstack
//                                    }//Hstack
//                                }  // navigation button
//                          
//                            } //Foreach
//                        }//lazyVGrid
//                    }//scrollview
//
//                .navigationTitle("حدد وجهتك")
//                .navigationBarTitleDisplayMode(.inline)
//                .navigationBarBackButtonHidden(true)
//                                 }
//
//                .searchable(text: $locationQuery) {
//                    ForEach(locationHandler.searchedLocation, id: \.self) { place in
//                        Text(place)
//                            .onTapGesture {
//                                selectedPlace = place
//                                locationQuery = "" // Clear the search query
//                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // Dismiss the keyboard
//                            }
//                    }
//                }  .frame(maxWidth: .infinity, maxHeight: .infinity)
//
//             
//            }
//              
//          
//            } onDismiss: {}
//   
//        
//        
//    }
//}
//
//    
//    struct MapView_Previews: PreviewProvider {
//        static var previews: some View {
//            MapView()
//        }
//    }
