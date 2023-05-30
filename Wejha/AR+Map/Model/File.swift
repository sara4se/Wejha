//
//  File.swift
//  Wejha
//
//  Created by Sara Alhumidi on 09/11/1444 AH.
//

import Foundation
import FirebaseFirestoreSwift
import UIKit
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
