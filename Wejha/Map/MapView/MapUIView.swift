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
    @State private var placesView: [Places] = []
    
//    init() {
//        _mapViewModel = StateObject(wrappedValue:MapViewRepresentable(firebaseViewModel: viewModels))
//    }
    //    @ObservedObject
    //    @State var MVR = MapViewRepresentable( selectedPlace:  .constant(""), tDistance:  .constant(""), time: .constant(""))
    var body: some View {
        NavigationView {
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                MapViewRepresentable(tDistance: $tDistance, time: $time, places: $placesView ).edgesIgnoringSafeArea(.all)
                
                GeometryReader { geo in
                    VStack(spacing: 0){
                    
                        Button {
                            print("i am here")
                            isMapActive.toggle()
                        } label: {
                            if(isARViewActive){
                                Image("MapButtonActive").resizable()
                            }else{
                                Image("MapButtonDisable").resizable()
                            }
                        }.disabled(isMapActive ? false  : true)
                        Button {
                            print("i am here")
                            isARViewActive.toggle()
                        } label: {
                            //                        Text("width:\(geo.frame(in: .global).width) height:\(geo.frame(in: .global).height) maxX:\(geo.frame(in: .global).maxX) midX:\(geo.frame(in: .global).midX) midY:\(geo.frame(in: .global).midY) maxY:\(geo.frame(in: .global).maxY) startLocation.y:\(startLocationY) translation.width:\(translationWidth) translation.height:\(translationHeight) offset:\(offset)")
                            
                            if(isARViewActive){
                             Image("ArButtonDisable").resizable()
                            }else{
                             Image("ArButtonActive").resizable()
                            }
                        }
                    }.frame(width: 50,height: 100).padding(.leading, 330)
                    // to read frame height
                    BottomSheet(offset: $offset, value: (-geo.frame(in: .global).height + 150), locationQuery: $locationQuery, locationViewModel: locationViewModel, locationHandler: locationHandler)
                    
                        .offset(y: geo.frame(in: .global).height - 140)
                    // adding Gesture
                        .offset(y: offset)
                        .gesture(DragGesture().onChanged({ value in
                            startLocationY = value.startLocation.y
                            translationHeight = value.translation.height
                            translationWidth = value.translation.width
                            
                            withAnimation {
                                // checking Scroll direction
                                // scrolling upwards
                                // usingstartLocation because translation will change when we drag up and down
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
                }.ignoresSafeArea(.all, edges: .bottom)
            }
            .onAppear{
                placesView = viewModels.places
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

struct BottomSheet: View {
    @Binding var offset: CGFloat
    var value: CGFloat
    @Binding var locationQuery: String
    @ObservedObject var locationViewModel: LocationViewModel
    @ObservedObject var locationHandler: PlaceSearch
    var categories : Categories = Categories()
    @StateObject private var viewModels = FirebaseModel()
    @State private var documentIDs: [String] = []
    @State var currentItem : Places?
     var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 15) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                      TextField("Search Place", text: $locationQuery)
                        .onChange(of: locationQuery) { newValue in
                            locationViewModel.selectedPlace = locationQuery
                            locationHandler.searchLocation(newValue)
                         }
                } //categories
                 if(locationQuery.isEmpty){
//                        ScrollView() {
//                            LazyVGrid(columns: [
//                                GridItem(.flexible()),
//                                GridItem(.flexible()),
//                                GridItem(.flexible())])
//                            {
//                                    let _ = print("helllokeo")
                            NavigationView {
                                ScrollView {
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                        NavigationLink(destination: GateLists()) {
                                                    VStack {
                                                        Circle()
                                                            .frame(width: 69, height: 69)
                                                            .cornerRadius(8)
                                                        Text("Gates")
                                                    }
                                                }
                                                NavigationLink(destination: RestRoomLists()) {
                                                    VStack {
                                                        Circle()
                                                            .frame(width: 69, height: 69)
                                                            .cornerRadius(8)
                                                        Text("Rest Rooms")
                                                    }
                                                }
                                        NavigationLink(destination: AblutionLists()) {
                                            VStack {
                                                Circle()
                                                    .frame(width: 69, height: 69)
                                                    .cornerRadius(8)
                                                Text("Ablution")
                                            }
                                        }
                                        NavigationLink(destination: AlSahanList()) {
                                                    VStack {
                                                        Circle()
                                                            .frame(width: 69, height: 69)
                                                            .cornerRadius(8)
                                                        Text("Al Sahan")
                                                    }
                                                }
                                        NavigationLink(destination:  LostFoundOfficeList()) {
                                                    VStack {
                                                        Circle()
                                                            .frame(width: 69, height: 69)
                                                            .cornerRadius(8)
                                                        Text("Lost and Found Office")
                                                    }
                                                }
                                        NavigationLink(destination:  BusStationList()) {
                                                    VStack {
                                                        Circle()
                                                            .frame(width: 69, height: 69)
                                                            .cornerRadius(8)
                                                        Text("Bus Station")
                                                    }
                                                }
                                        NavigationLink(destination:  VerticalTransportationsList()) {
                                                    VStack {
                                                        Circle()
                                                            .frame(width: 69, height: 69)
                                                            .cornerRadius(8)
                                                        Text("Vertical Transportations")
                                                    }
                                                }
                                        NavigationLink(destination:   WheelchairPlaceList()) {
                                                    VStack {
                                                        Circle()
                                                            .frame(width: 69, height: 69)
                                                            .cornerRadius(8)
                                                        Text("Wheelchair Place")
                                                    }
                                                }
                                        NavigationLink(destination:  AlSafaAlmarwahList()) {
                                                    VStack {
                                                        Circle()
                                                            .frame(width: 69, height: 69)
                                                            .cornerRadius(8)
                                                        Text("AlSafa & Almarwah Gate")
                                                    }
                                                }
                                    }
                                    .padding()
                                }
                       
                            }
//                        }//lazyVGrid
//                    }//scrollview
              }
                VStack(spacing: 10){
     if(!locationQuery.isEmpty){
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVStack(alignment: .leading, spacing: 15) {
                                
                                ForEach(locationHandler.searchedLocation, id: \.self) { place in
                                    Text(place)
                                        .onTapGesture {
                                            //  locationViewModel.selectedPlace = place
                                            print("i give locationViewModel.selectedPlace = place")
                                            locationQuery = "" // Clear the search query
                                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // Dismiss the keyboard
                                        }
                                    Divider()
                                        .padding(.top, 10)
                                }
                                
                            }//lazyVGrid
                        }//scrollview
                    }
                }.onAppear() {
                    print("PostsListView appears. and data updates.")
                   // self.viewModels.subscribeFireAblutionW()
                     
//                    self.viewModels.retrieveAllGate(completion:  { documentIDs in
//                        self.documentIDs = documentIDs
//                })
                    self.viewModels.retrieveAllDocumentIDs(colliction: "") { documentIDs in
                        self.documentIDs = documentIDs}
                }
                .navigationTitle("حدد وجهتك")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
            }
//            .background(BlurView(style: .systemMaterial))
//                .cornerRadius(15)
            
            
        }
         
    }
}



struct MapUIView_Previews: PreviewProvider {
    static var previews: some View {
        MapUIView()
    }
}
//


