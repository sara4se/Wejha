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
    //    @Binding var selectedPlace: String?
    @ObservedObject private var locationViewModel = LocationViewModel()
    
    @ObservedObject var locationHandler = PlaceSearch()
    @State var isARViewActive = false // New state variable
    @State var presentSheet = true
    @State private var searchText = ""
    @State private var tDistance: String = ""
    @State private var time: String = ""
    @State private var markers: [GMSMarker] = []
    //    @ObservedObject
    //    @State var MVR = MapViewRepresentable( selectedPlace:  .constant(""), tDistance:  .constant(""), time: .constant(""))
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            MapViewRepresentable(tDistance: $tDistance, time: $time, markers: $markers).edgesIgnoringSafeArea(.all)
            
            GeometryReader { geo in
                
                //                here i can make button to switch between the ar and map
                
                //                Text("width:\(geo.frame(in: .global).width) height:\(geo.frame(in: .global).height) maxX:\(geo.frame(in: .global).maxX) midX:\(geo.frame(in: .global).midX) midY:\(geo.frame(in: .global).midY) maxY:\(geo.frame(in: .global).maxY) startLocation.y:\(startLocationY) translation.width:\(translationWidth) translation.height:\(translationHeight) offset:\(offset)")
                //
                
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
                
            }
            
            .ignoresSafeArea(.all, edges: .bottom)
            
        }
        
        .navigationBarTitle("Map")
        .navigationBarItems(trailing: Button("AR") {
            isARViewActive = true // Activate the AR view when the button is tapped
        })
        
    }
}

struct BottomSheet: View {
    @Binding var offset: CGFloat
    var value: CGFloat
    @Binding var locationQuery: String
    @ObservedObject var locationViewModel: LocationViewModel
    @ObservedObject var locationHandler: PlaceSearch
    var categories : Categories = Categories()
    //var category : Category = Category(name: "")
    @StateObject var viewModels = PostsViewModel()
    
    @StateObject private var firebaseModel = FirebaseModel()
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
                }
                 
                .background(BlurView(style: .systemMaterial))
                .cornerRadius(15)
                .padding()
                
                
                //categories
                 if(locationQuery.isEmpty){
//                        ScrollView() {
//                            LazyVGrid(columns: [
//                                GridItem(.flexible()),
//                                GridItem(.flexible()),
//                                GridItem(.flexible())])
//                            {
                                    let _ = print("helllokeo")
                            NavigationView {
                                ScrollView {
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                        ForEach(documentIDs, id: \.self) { documentID in
                                            NavigationLink(destination: categoryContent()) {
                                                VStack {
                                                    Circle()
                                                        .frame(width: 69, height: 69)
                                                        .cornerRadius(8)
                                                    Text(documentID)
                                                }
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
                    self.viewModels.subscribeFireAblutionW()
                    firebaseModel.retrieveAllDocumentIDs { documentIDs in
                        self.documentIDs = documentIDs}
                }
                .navigationTitle("حدد وجهتك")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
            } .background(BlurView(style: .systemMaterial))
                .cornerRadius(15)
            
            
        }
       
    }
}


struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> some UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //
    }
}

struct MapUIView_Previews: PreviewProvider {
    static var previews: some View {
        MapUIView()
    }
}

struct categoryContent: View {
    var body: some View{
        Text("this is category content")
    }
}
