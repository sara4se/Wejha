//
//  sheetExtension.swift
//  buttom sheet
//
//  Created by roba on 15/05/2023.
//

import Foundation
import SwiftUI
//MARK: costume bottom sheet
struct BottomSheet: View {
//    @Binding var offset: CGFloat
//    var value: CGFloat
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


//extension View{
//    @ViewBuilder
//    func bottomSheet<Content:View>(
//        presentationeDetents: Set<PresentationDetent>,
//        isPresented: Binding<Bool>,
//        dragIndicator: Visibility = .visible,
//        sheetCornerRadius: CGFloat?,
//        largesrUndimmedIdentifier: UISheetPresentationController.Detent.Identifier = .large,
//        isTransparentBG: Bool = false,
//        interactiveDisabled: Bool = true,
//        @ViewBuilder content: @escaping ()->Content,
//        onDismiss: @escaping ()->()
//    )->some View{
//        self
//            .sheet(isPresented: isPresented){
//                onDismiss()
//            } content: {
//                content()
//                    .presentationDetents(presentationeDetents)
//                    .presentationDragIndicator(dragIndicator)
//                    .interactiveDismissDisabled(interactiveDisabled)
//                    .background(Color.clear) // Add a transparent background
//                    .onAppear{
//                        //MARK: costume code for bottom sheet
//                        //finding th presented view controller
//                        guard let windows = UIApplication.shared.connectedScenes.first as?
//                                UIWindowScene else{
//                            return
//                        }
//                        //from extracting presentation controller
//                        if let controller = windows.windows.first?.rootViewController? .presentedViewController, let sheet = controller.presentationController as? UISheetPresentationController{
//
//                            //remove tinted bg
//                            controller.presentedViewController?.view.tintAdjustmentMode = .normal
//                            //MARK: set properties to whatever u wish here w sheet controller
//                            sheet.largestUndimmedDetentIdentifier = largesrUndimmedIdentifier
//                            sheet.preferredCornerRadius = sheetCornerRadius
//                        }
//                        else {
//                            print("NO CONTROLLER FOUND")
//                        }
//                    }
//            }
//
//    }
//
//
//}
