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
class FirebaseModel : ObservableObject {
    // Function to retrieve the IDs of all documents within a collection
     func retrieveAllDocumentIDs(completion: @escaping ([String]) -> Void) {
        let db = Firestore.firestore()
        let collection = db.collection("Category")
        
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
}

class PostsViewModel: ObservableObject {
    @Published var places = [Places]()
    
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    deinit {
        unsubscribe()
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
    func retrieveDocument(completion: @escaping (DocumentSnapshot?) -> Void) {
        let collection = db.collection("Category")

        collection.document().getDocument { (document, error) in
            if let error = error {
                print("Error retrieving document: \(error)")
                completion(nil)
            } else {
                if let document = document, document.exists {
                    completion(document)
                    
                } else {
                    print("Document does not exist")
                    completion(nil)
                }
            }
        }
    }

    func subscribeFireAblutionW() {
        if listenerRegistration == nil {
      

            listenerRegistration = db.collection("Category").document("Ablution-W").collection("Ablution-W1").addSnapshotListener { (querySnapshot, error) in
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

    func removePosts(atOffsets indexSet: IndexSet) {
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
    
    
}
