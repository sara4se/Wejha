//
//  CompineAR_MapModelView.swift
//  Wejha
//
//  Created by Sara Alhumidi on 01/11/1444 AH.
//

import Foundation
import FirebaseFirestore
import Combine
import UIKit
import SwiftUI
 
class FirebaseModel: ObservableObject {
    @Published var places = [Places]()
    
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    deinit {
        unsubscribe()
    }
    
    func FireLostFoundOffice() {
        if listenerRegistration == nil {
            listenerRegistration =  db.collection("Lost&FoundOffice").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.places = documents.compactMap { queryDocumentSnapshot in
                    let documentData = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    let Lat = documentData["Lat"] as? Double ?? 0.0
                    let Lang = documentData["Lang"] as? Double ?? 0.0
                    let Name = documentData["Name"] as? String ?? ""
                    // Extract and assign other properties as needed
                    
                    return Places(id: id, Lang: Lang ,Lat: Lat, Name: Name)
                }
            }
        }
    }
    func FireRestRoom() {
        if listenerRegistration == nil {
            listenerRegistration =  db.collection("Restrooms").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.places = documents.compactMap { queryDocumentSnapshot in
                    let documentData = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    let Lat = documentData["Lat"] as? Double ?? 0.0
                    let Lang = documentData["Lang"] as? Double ?? 0.0
                    let Name = documentData["Name"] as? String ?? ""
                    // Extract and assign other properties as needed
                    
                    return Places(id: id, Lang: Lang ,Lat: Lat, Name: Name)
                }
            }
        }
    }
    func FireBusStation() {
        if listenerRegistration == nil {
            listenerRegistration =  db.collection("BusStation").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.places = documents.compactMap { queryDocumentSnapshot in
                    let documentData = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    let Lat = documentData["Lat"] as? Double ?? 0.0
                    let Lang = documentData["Lang"] as? Double ?? 0.0
                    let Name = documentData["Name"] as? String ?? ""
                    // Extract and assign other properties as needed
                    
                    return Places(id: id, Lang: Lang ,Lat: Lat, Name: Name)
                }
            }
        }
    }
    func FireVerticalTransportations() {
        if listenerRegistration == nil {
            listenerRegistration =  db.collection("VerticalTransportation").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.places = documents.compactMap { queryDocumentSnapshot in
                    let documentData = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    let Lat = documentData["Lat"] as? Double ?? 0.0
                    let Lang = documentData["Lang"] as? Double ?? 0.0
                    let Name = documentData["Name"] as? String ?? ""
                    // Extract and assign other properties as needed
                    
                    return Places(id: id, Lang: Lang ,Lat: Lat, Name: Name)
                }
            }
        }
    }
    func FireWheelchairPlace() {
        if listenerRegistration == nil {
            listenerRegistration =  db.collection("WheelchairStore").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.places = documents.compactMap { queryDocumentSnapshot in
                    let documentData = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    let Lat = documentData["Lat"] as? Double ?? 0.0
                    let Lang = documentData["Lang"] as? Double ?? 0.0
                    let Name = documentData["Name"] as? String ?? ""
                    // Extract and assign other properties as needed
                    
                    return Places(id: id, Lang: Lang ,Lat: Lat, Name: Name)
                }
            }
        }
    }
//    Ablution
    func FireAblution() {
        if listenerRegistration == nil {
            listenerRegistration =  db.collection("Ablution").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.places = documents.compactMap { queryDocumentSnapshot in
                    let documentData = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    let Lat = documentData["Lat"] as? Double ?? 0.0
                    let Lang = documentData["Lang"] as? Double ?? 0.0
                    let Name = documentData["Name"] as? String ?? ""
                    // Extract and assign other properties as needed
                    
                    return Places(id: id, Lang: Lang ,Lat: Lat, Name: Name)
                }
            }
        }
    }
    func FireAlsafaAlmarwaGates() {
        if listenerRegistration == nil {
            listenerRegistration =  db.collection("Al-Safa & Al-marwah").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.places = documents.compactMap { queryDocumentSnapshot in
                    let documentData = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    let Lat = documentData["Lat"] as? Double ?? 0.0
                    let Lang = documentData["Lang"] as? Double ?? 0.0
                    let Name = documentData["Name"] as? String ?? ""
                    // Extract and assign other properties as needed
                    
                    return Places(id: id, Lang: Lang ,Lat: Lat, Name: Name)
                }
            }
        }
    }
    func FireGate() {
        if listenerRegistration == nil {
            listenerRegistration =  db.collection("Gate").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.places = documents.compactMap { queryDocumentSnapshot in
                    let documentData = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    let Lat = documentData["Lat"] as? Double ?? 0.0
                    let Lang = documentData["Lang"] as? Double ?? 0.0
                    let Name = documentData["Name"] as? String ?? ""
                    // Extract and assign other properties as needed
                    
                    return Places(id: id, Lang: Lang ,Lat: Lat, Name: Name)
                }
            }
        }
    }
    func FireAlSahan() {
        if listenerRegistration == nil {
            listenerRegistration =  db.collection("Al-Sahan").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.places = documents.compactMap { queryDocumentSnapshot in
                    let documentData = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    let Lat = documentData["Lat"] as? Double ?? 0.0
                    let Lang = documentData["Lang"] as? Double ?? 0.0
                    let Name = documentData["Name"] as? String ?? ""
                    // Extract and assign other properties as needed
                    
                    return Places(id: id, Lang: Lang ,Lat: Lat, Name: Name)
                }
            }
        }
    }
    func unsubscribe() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
}

























//    func retrieveDocumentFileds(completion: @escaping ([String]) -> Void) {
//       let db = Firestore.firestore()
//        let doc = db.collection("Category").document("Ablution-W")
//        doc.addSnapshotListener { DocumentSnapshot?, <#Error?#> in
//            <#code#>
//        }
//       collection.getDocuments { (querySnapshot, error) in
//           if let error = error {
//               print("Error retrieving documents: \(error)")
//               completion([])
//           } else {
//               guard let documents = querySnapshot?.documents else {
//                   print("No documents found")
//                   completion([])
//                   return
//               }
//
//               let documentIDs = documents.map { $0.documentID }
//               completion(documentIDs)
//           }
//       }
//   }
//







   /* func removePosts(atOffsets indexSet: IndexSet) {
    let posts = indexSet.lazy.map { self.places[$0] }
    posts.forEach { post in
        if let documentId = post.id {
            db.collection("Ablution-W").document(documentId).delete { error in
                if let error = error {
                    print("Unable to remove document: \(error.localizedDescription)")
                }
            }
        }
    }
}
    func retrieveAllGate(completion: @escaping ([String]) -> Void) {
        let db = Firestore.firestore()
        let collection = db.collection("Gate")
        
        collection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error retrieving documents: \(error)")
                completion([])
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                    completion([])
                    return
                }
                
                let documentIDs = documents.map { $0.documentID }
                completion(documentIDs)
            }
        }
    }
    

func unsubscribe() {
    if listenerRegistration != nil {
        listenerRegistration?.remove()
        listenerRegistration = nil
    }
}

func subscribe() {
    if listenerRegistration == nil {
        //Gates
        listenerRegistration = db.collection("Ablution-W").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.places = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Places.self)
            }
        }
    }
}
*/
