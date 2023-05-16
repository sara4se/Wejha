//
//  SwiftUIViewPlaces.swift
//  Wejha
//
//  Created by Sara Alhumidi on 26/10/1444 AH.
//

 
import SwiftUI
import GooglePlaces

struct GetStartedView: View {
        @State private var name: String = ""
        @State private var address: String = ""
   
 
    var body: some View {
        VStack {
            GetStartedViewControllerRepresentable()
        }
    }
}
//    private func getCurrentPlace() {
//        let placeFields: GMSPlaceField = [.name, .formattedAddress]
//        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { (placeLikelihoods, error) in
//            guard error == nil else {
//                print("Current place error: \(error?.localizedDescription ?? "")")
//                return
//            }
//
//            guard let place = placeLikelihoods?.first?.place else {
//                name = "No current place"
//                address = ""
//                return
//            }
//
//            name = place.name ?? ""
//            address = place.formattedAddress ?? ""
//        }
//    }


 

struct GetStartedView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedView()
    }
}
