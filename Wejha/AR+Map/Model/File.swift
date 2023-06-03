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

struct Places : Identifiable,Codable{
    
    @DocumentID var id: String?
    var  Lang : Double
    var Lat : Double
    var Name : String
}

struct c : Identifiable,Codable{
    
    @DocumentID var id: String?
    var  Lang : Double
    var Lat : Double
    var Name : String
}
struct Spical {
    let id: String
    let coordinates: GeoPoint
    let Name: String
    // Other properties
    
    // Initialize the struct with a document snapshot
    init(id: String, document: DocumentSnapshot) {
        self.id = id
        self.coordinates = document.get("Coordinates") as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
        self.Name = document.get("Name") as? String ?? ""
        // Initialize other properties as needed
    }
}
