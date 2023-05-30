//
//  PlaceSearch.swift
//  SwiftUI-GooglePlaceSearch
//
//  Created by Sara Alhumidi on 24/10/1444 AH.
//

import Foundation
import GooglePlaces
import GoogleMaps
/// https://developers.google.com/maps/documentation/places/ios-sdk/autocomplete#call_gmsplacesclient
final class PlaceSearch : ObservableObject {
    
    /// `GMSAutocompleteSessionToken.init()` : allow create session token to uniquely identify queries to the Google Places API Services for fetching place predictions
    let token = GMSAutocompleteSessionToken.init()
    let client = GMSPlacesClient()
    
    @Published var searchedLocation = [String]()
    func searchLocation(_ query:String) {
        searchedLocation = []
        let filter = createSearchFilter()
        client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: token) { results, error in
            if let error = error {
                print("Error find predictions : \(error.localizedDescription)")
            }
           guard let results = results else {return}
            for result in results {
                self.searchedLocation.append(result.attributedFullText.string)
                print("Result \(result.attributedFullText) with placeID \(result.placeID)")
            }
        }
    }

/// https://developers.google.com/maps/documentation/places/ios-sdk/supported_types
func createSearchFilter() -> GMSAutocompleteFilter {
    /// `GMSAutocompleteFilter()`:   allow to set restrictions on autocomplete requests
    let filter = GMSAutocompleteFilter()
    /// `types`: add filter to request :
    
    filter.types = [""]
    
    /// `locationBias`: allow to show results in defined region, in this case we only set London
    ///  `north-east = top-right corner` and `south-west = bottom-left corner` of a rectangle for the specifed region
    
    // Set the location bias to Makkah (Saudi Arabia)
    let northEast = CLLocationCoordinate2D(latitude: 21.5728, longitude: 39.1608)
    let southWest = CLLocationCoordinate2D(latitude: 21.0975, longitude: 39.9492)
    filter.locationBias = GMSPlaceRectangularLocationOption(northEast, southWest)
    
    // Set the country to Saudi Arabia
    filter.countries = ["SA"]
    
    return filter
}
}
