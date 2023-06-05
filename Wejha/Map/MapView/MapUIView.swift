//
//  MapUIView.swift
//  Wejha
//@State var userLocation: CLLocationCoordinate2D?
//  Created by Sara Alhumidi on 04/11/1444 AH.
//
import GoogleMaps

import SwiftUI
class LocationViewModel: ObservableObject {
    @Published var selectedPlace: String?
}
class FocusPlace: ObservableObject {
    @Published var focusPlace: String = ""
}
struct MapUIView: View {
    @State var offset: CGFloat = 0
    @State var locationQuery : String = ""
    @State var startLocationY: CGFloat = 0
    @State var translationHeight: CGFloat = 0
    @State var translationWidth: CGFloat = 0
    @State var ShowAR: Bool = true
    @State var selectedPlace: String? = ""
    @StateObject private var viewModels = FirebaseModel()
   @ObservedObject private var locationViewModel = LocationViewModel()
    @ObservedObject var locationHandler = PlaceSearch()
    @State var isARViewActive = false // New state variable
    @State var isMapActive = false
    @State var presentSheet = true
    @State private var searchText :String? = ""
    @State private var tDistance: String = ""
    @State private var time: String = ""
    @State private var markers: [GMSMarker] = []
//    @Binding var directions: [String]
//    @State private var placesView: [Places] = []
    @State private var places: [Spical] = []
    var body: some View {
        NavigationView {
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                MapViewRepresentable(tDistance: $tDistance, time: $time, places: $places ).edgesIgnoringSafeArea(.all)
                
                GeometryReader { geo in
                    VStack(spacing: 0){
                        Button {
                            isMapActive.toggle()
                        } label: {
                            if(isARViewActive){
                                Image("MapButtonActive").resizable()
                            }else{
                                Image("MapButtonDisable").resizable()
                            }
                        }.disabled(isMapActive ? false  : true)
                        Button {
                            isARViewActive.toggle()
                        } label: {
                          if(isARViewActive){
                                Image("ArButtonDisable").resizable()
                            }else{
                                Image("ArButtonActive").resizable()
                            }
                        }
                    }.frame(width: 50,height: 100).padding(.leading, 330)
                    // to read frame height
                    
                    if(tDistance.isEmpty){
                    BottomSheet(locationQuery: $locationQuery, locationViewModel: locationViewModel, locationHandler: locationHandler)
                        .offset(y: geo.frame(in: .global).height - 140)
                        .offset(y: offset)
                        .gesture(DragGesture().onChanged({ value in
                            startLocationY = value.startLocation.y
                            translationHeight = value.translation.height
                            translationWidth = value.translation.width
                            
                            withAnimation {
                                if value.startLocation.y > geo.frame(in: .global).midX {
                                    if value.translation.height < 0 && offset > (-geo.frame(in: .global).height + 150) {
                                        offset = value.translation.height
                                    }
                                }
                                if value.startLocation.y < geo.frame(in: .global).midX {
                                    if value.translation.height > 0 && offset < 0 {
                                        offset = (-geo.frame(in: .global).height + 150) + value.translation.height
                                    }
                                }
                            }
                        })
                            .onEnded({ value in
                                withAnimation {
                                    // checking and pulling up the screen
                                    if value.startLocation.y > geo.frame(in: .global).midX {
                                        if -value.translation.height > geo.frame(in: .global).midX {
                                            offset = (-geo.frame(in: .global).height + 150)
                                            return
                                        }
                                        offset = 0
                                    }
                                    if value.startLocation.y < geo.frame(in: .global).midX {
                                        if value.translation.height < geo.frame(in: .global).midX {
                                            offset = (-geo.frame(in: .global).height + 150)
                                            return
                                        }
                                        offset = 0
                                    }
                                }
                            }))
                }
                    if(!tDistance.isEmpty){
                        MapCardView(tDistance: $tDistance, time: $time)
                           // .offset(y: geo.size.height - 140 + offset)
                            .padding([.leading,.trailing],24).padding(.top,600).padding(.bottom,72)
                    }
                }.ignoresSafeArea(.all, edges: .bottom)
            } 
            .onAppear{
                //placesView = viewModels.places
                viewModels.FireGate()
            }
            .fullScreenCover(isPresented: $isARViewActive, content: {
                ARUIView(selectedPlace: $selectedPlace)
            })
            .fullScreenCover(isPresented: $isMapActive, content: {
                MapUIView()
            })
//            .sheet(isPresented: $isARViewActive, content: {
//                ARUIView()
//            })
//                .navigationDestination(isPresented: $isARViewActive) {
//                    let _ = print("hello")
//                    ARUIView()
//                }
        }
    }
}

 

struct MapUIView_Previews: PreviewProvider {
    static var previews: some View {
        MapUIView().environment(\.locale, .init(identifier: "ar"))
        MapUIView().environment(\.locale, .init(identifier: "en"))
    }
}
//


