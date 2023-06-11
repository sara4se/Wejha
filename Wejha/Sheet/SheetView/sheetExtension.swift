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
    @Binding var stringAR : String
    @Binding var placeFromTapped : String
    @Binding var locationQuery: String 
    @ObservedObject var locationHandler: PlaceSearch
    var categories : Categories = Categories()
    @ObservedObject var focusPlace: FocusPlace = FocusPlace()
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
                    TextField(LocalizedStringKey("Text53"), text: $locationQuery)
                    
                        .onChange(of: locationQuery) { newValue in
//                            locationViewModel.selectedPlace = locationQuery
                            locationHandler.searchLocation(newValue)
                           // locationQuery = newValue
                        }
                        
                }.padding(20) //categories
                   
                if(locationQuery.isEmpty){
                   NavigationView {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                NavigationLink(destination:  AlSafaAlmarwahList()) {
                                    VStack {
                                        Circle()
                                            .frame(width: 69, height: 69)
                                            .foregroundColor(Color("DarkGreen"))
                                            .overlay(
                                                Image("safaAndMarwa")
                                                    .aspectRatio(contentMode: .fill))
                                        Text(LocalizedStringKey("Text18")).foregroundColor(Color("DarkGreen"))
                                    }
                                }
                                NavigationLink(destination: AlSahanList()) {
                                    VStack {
                                        Circle()
                                            .frame(width: 69, height: 69)
                                            .foregroundColor(Color("DarkGreen"))
                                            .overlay(
                                                Image("Al-Sahan")
                                                    .aspectRatio(contentMode: .fill) )
                                        Text(LocalizedStringKey("Text17")).foregroundColor(Color("DarkGreen"))
                                    }
                                }
                                NavigationLink(destination: GateLists()) {
                                    VStack {
                                        Circle()
                                            .frame(width: 69, height: 69)
                                            .foregroundColor(Color("DarkGreen"))
                                            .overlay(
                                                Image("Gates")
                                                    .aspectRatio(contentMode: .fill))
                                        Text(LocalizedStringKey("Text16")).foregroundColor(Color("DarkGreen"))
                                    }
                                }
                                NavigationLink(destination: AblutionLists()) {
                                    VStack {
                                        Circle()
                                            .frame(width: 69, height: 69)
                                            .foregroundColor(Color("DarkGreen"))
                                            .overlay(
                                                Image("Ablution")
                                                    .aspectRatio(contentMode: .fill)
                                            )
                                        Text(LocalizedStringKey("Text21")).foregroundColor(Color("DarkGreen"))
                                    }
                                }
                                NavigationLink(destination: RestRoomLists()) {
                                    VStack {
                                        Circle()
                                            .frame(width: 69, height: 69)
                                            .foregroundColor(Color("DarkGreen"))
                                            .overlay(
                                                Image("Restroom")
                                                    .aspectRatio(contentMode: .fill)
                                           )
                                        Text(LocalizedStringKey("Text20")).foregroundColor(Color("DarkGreen"))
                                    }
                                }
                                
                                NavigationLink(destination:   WheelchairPlaceList()) {
                                    VStack {
                                        Circle()
                                            .frame(width: 69, height: 69)
                                            .foregroundColor(Color("DarkGreen"))
                                            .overlay(
                                                Image("WheelchairStore")
                                                    .aspectRatio(contentMode: .fill)
                                            )
                                        Text(LocalizedStringKey("Text19")).foregroundColor(Color("DarkGreen"))
                                    }
                                }
                                
                                NavigationLink(destination:  LostFoundOfficeList()) {
                                    VStack {
                                        Circle()
                                            .frame(width: 69, height: 69)
                                            .foregroundColor(Color("DarkGreen"))
                                            .overlay(
                                                Image("LostAndFoundOffice")
                                                    .aspectRatio(contentMode: .fill)
                                           )
                                        Text(LocalizedStringKey("Text24")).foregroundColor(Color("DarkGreen"))
                                    }
                                }
                                NavigationLink(destination:  BusStationList()) {
                                    VStack {
                                        Circle()
                                            .frame(width: 69, height: 69)
                                            .foregroundColor(Color("DarkGreen"))
                                            .overlay(
                                                Image("BusStation")
                                                    .aspectRatio(contentMode: .fill)
                                            )
                                        Text(LocalizedStringKey("Text23")).foregroundColor(Color("DarkGreen"))
                                    }
                                }
                                NavigationLink(destination:  VerticalTransportationsList()) {
                                    VStack {
                                        Circle()
                                            .frame(width: 69, height: 69)
                                            .foregroundColor(Color("DarkGreen"))
                                            .overlay(
                                                Image("VerticalTransportation")
                                                    .aspectRatio(contentMode: .fill)
                                            )
                                        Text(LocalizedStringKey("Text22")).foregroundColor(Color("DarkGreen"))
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
                                            stringAR = place
                                            focusPlace.focusPlace = place
                                            print("i enter to focus2 : \(focusPlace.focusPlace.description)")
                                            print("i give locationViewModel.selectedPlace = \( place)")
                                            locationQuery = "" // Clear the search query
                                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // Dismiss the keyboard
                                        }
                                    Divider()
                                        .padding(.top, 10)
                                }
                                
                            }//lazyVGrid
                        }//scrollview
                        .padding(20)
                    }
                }
                
                .navigationTitle(LocalizedStringKey("Text15"))
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
            }
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
struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet(stringAR: .constant(""), placeFromTapped: .constant(""), locationQuery: .constant(""), locationHandler: PlaceSearch()).environment(\.locale, .init(identifier: "ar"))
        BottomSheet(stringAR: .constant(""), placeFromTapped: .constant(""), locationQuery: .constant(""),locationHandler: PlaceSearch()).environment(\.locale, .init(identifier: "en"))
        BottomSheet(stringAR: .constant(""), placeFromTapped: .constant(""),locationQuery: .constant(""), locationHandler: PlaceSearch()).environment(\.locale, .init(identifier: "fr"))
    }
}
