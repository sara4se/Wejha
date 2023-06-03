//
//  File.swift
//  Wejha
//
//  Created by Sara Alhumidi on 09/11/1444 AH.
//

import Foundation
import FirebaseFirestoreSwift
import UIKit
import FirebaseFirestore
import CoreLocation

struct Places : Identifiable,Codable{
    
    @DocumentID var id: String?
    var  Lang : Double
    var Lat : Double
    var Name : String
}

//struct c : Identifiable,Codable{
//    
//    @DocumentID var id: String?
//    var  Lang : Double
//    var Lat : Double
//    var Name : String
//}
struct Spical {
    let id: String
    let coordinates: CLLocationCoordinate2D
    init(id: String, coordinates: CLLocationCoordinate2D) {
        self.id = id
        self.coordinates = coordinates
    }
}

    // Other properties
//    init(){
//        self.id = id
//        self.coordinates =  GeoPoint(latitude: 0, longitude: 0)
//        self.Name =  ""
//        // Initialize other properties as needed
//    }
    // Initialize the struct with a document snapshot
 
 
