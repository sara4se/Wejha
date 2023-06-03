//
//  MapModelView.swift
//  Wejha
//
//  Created by Sara Alhumidi on 24/10/1444 AH.
//

import Foundation
import CoreLocation
import SwiftUI
import GoogleMaps
import UIKit
import CoreLocation
import GooglePlaces
import Firebase

struct MapViewRepresentable: UIViewRepresentable  {
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject private var locationViewModel = LocationViewModel()
    @ObservedObject private var vmMapRouteTasks = MapRouteTasks()
    @ObservedObject var locationHandler = PlaceSearch()
    @StateObject private var viewModels = FirebaseModel()
    let mapView = GMSMapView(frame: .zero)
    @Binding var tDistance: String
    @Binding var time: String
    @Binding var places: [Places]
    let googleApiKey = "AIzaSyDgXEpiATw1IAcW1T2gYLcwhM8S1v0IHOI"
   // @State var plasesArray = [Places]()
    var db = Firestore.firestore()
    //24.814339, 46.720124
    //24.729377, 46.716325
    //24.741268, 46.749721
    //24.726353, 46.773846
    let destination1 = CLLocationCoordinate2D(latitude: 24.741268, longitude: 46.749721)
    let destination2 = CLLocationCoordinate2D(latitude: 24.726353, longitude: 46.773846)

   
class Coordinator: NSObject, CLLocationManagerDelegate, GMSMapViewDelegate {
    var mapView: GMSMapView?
    var listenerRegistration: ListenerRegistration?
    //@Binding var currentLocation : CLLocationCoordinate2D
    var parent: MapViewRepresentable
    init(_ parent: MapViewRepresentable){
        self.parent = parent
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
           let marker = GMSMarker(position: coordinate)
           marker.map = mapView
        guard let currentLocation = mapView.myLocation?.coordinate else {
                   return
               }
        parent.getRouteSteps(from: currentLocation, to: coordinate)
        parent.getTotalDistance(from: currentLocation, to: coordinate)
       }
    func updateMarkers2(mapView: GMSMapView) {
     //   mapView.clear()
        
        if listenerRegistration == nil {
            listenerRegistration = parent.db.collection("test").addSnapshotListener {
                (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                let places = documents.compactMap { document in
                    let id = document.documentID
                    let point1 = document.get("point1") as? GeoPoint
                    let name = document.get("Name") as? String ?? ""
                    
                    if let point1 = point1 {
                        let place = Spical(id: id, document: document)
                        return place
                    } else {
                        print("nil point")
                    }
                    return Spical(id: id, document: document)
                }
                
                for place in places {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: place.coordinates.latitude, longitude: place.coordinates.longitude)
                    marker.map = mapView
                    print("I'm for place")
                }
                
                if places.isEmpty {
                    print("I'm empty")
                }
            }
        }
    }

    func updateMarkers(mapView: GMSMapView) {
//        mapView.clear()

        if  listenerRegistration == nil {
            listenerRegistration = parent.db.collection("Gate").addSnapshotListener { [self]
                (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return  }
                self.parent.places = documents.compactMap { document in
                    let documentData = document.data()
                    let id = document.documentID
                    let Lat = documentData["Lat"] as? Double ?? 0.0
                    let Lang = documentData["Lang"] as? Double ?? 0.0
                    let Name = documentData["Name"] as? String ?? ""
                    // Extract and assign other properties as needed
                    return Places(id: id, Lang: Lang ,Lat: Lat, Name: Name)
                }
                        for place in  parent.places {
                            let marker = GMSMarker()
                            marker.position = CLLocationCoordinate2D(latitude: place.Lat, longitude: place.Lang)
                            marker.map = mapView
                            print("I'm for place ")
                        }
                        if parent.places.isEmpty {
                            print("I'm empty")
                        }
                      //  return Places(id: id, Lang: Lang ,Lat: Lat, Name: Name)
                    }
            

        }
    }
}
    
       
//    var coordinates: [CLLocationCoordinate2D]
    func makeUIView(context: Context) -> GMSMapView {
        mapView.delegate = context.coordinator
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.mapView.settings.compassButton = true
        self.mapView.settings.rotateGestures = true
        self.mapView.settings.scrollGestures = true
        self.mapView.settings.tiltGestures = true
        self.mapView.settings.zoomGestures = true
        self.mapView.isIndoorEnabled = true
        self.mapView.settings.indoorPicker = true
        self.mapView.delegate = context.coordinator as? GMSMapViewDelegate
      //  context.coordinator.updateMarkers(mapView: mapView)
        context.coordinator.updateMarkers2(mapView: mapView)
//        if let locationcoordinate =  locationManager.lastKnownLocation?.coordinate{
//            print("locationcoordinate\(locationcoordinate)")
//            getRouteSteps(from: locationcoordinate, to: destination2)
//        }
//
        return mapView
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        //mapView.clear()
     
            if let selectedPlace = locationViewModel.selectedPlace {
                locationHandler.searchLocation(selectedPlace)
            }
            //        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleMapTap(_:)))
            //            mapView.addGestureRecognizer(tapGesture)
          //  getRouteSteps(from: destination1, to: destination2)
            // vmMapRouteTasks.calculateTotalDistanceAndDuration()
        
    }
    func getRouteSteps(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
//        mapView.clear()
        let session = URLSession.shared
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=walking&alternatives=true&key=\(googleApiKey)")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
                
                print("error in JSONSerialization")
                return
                
            }
            print("jsonResult :\(jsonResult)")
            
            
            guard let routes = jsonResult["routes"] as? [Any] else {
                return
            }
            
            guard let route = routes[0] as? [String: Any] else {
                return
            }
            
            guard let legs = route["legs"] as? [Any] else {
                return
            }
            
            guard let leg = legs[0] as? [String: Any] else {
                return
            }
            
            guard let steps = leg["steps"] as? [Any] else {
                return
            }
            for item in steps {
                
                guard let step = item as? [String: Any] else {
                    return
                }
                
                guard let polyline = step["polyline"] as? [String: Any] else {
                    return
                }
                
                guard let polyLineString = polyline["points"] as? String else {
                    return
                }
                
                //Call this method to draw path on map
                DispatchQueue.main.async {
                    self.drawPath(from: polyLineString)
                }
                
            }
        })
        task.resume()
    }
    //MARK:- Draw Path line
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 4.0
        polyline.strokeColor = .green
        polyline.map = mapView // Google MapView
   //     let cameraUpdate = GMSCameraUpdate.fit(GMSCoordinateBounds(coordinate: destination1, coordinate: destination2))
        //mapView.moveCamera(cameraUpdate)
        let currentZoom = mapView.camera.zoom
        mapView.animate(toZoom: currentZoom)
    }
    func getTotalDistance(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let session = URLSession.shared
        
        guard let encodedSource = "\(source.latitude),\(source.longitude)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let encodedDestination = "\(destination.latitude),\(destination.longitude)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Invalid coordinate encoding")
            return
        }
        
        let urlString = "https://maps.googleapis.com/maps/api/distancematrix/json"
        let parameters: [String: String] = [
            "origins": encodedSource,
            "destinations": encodedDestination,
            "units": "imperial",
            "mode": "walking",
            "language": "en-EN",
            "sensor": "false",
            "key": googleApiKey
        ]
        
        guard var urlComponents = URLComponents(string: urlString) else {
            print("Invalid URL")
            return
        }
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        
        guard let url = urlComponents.url else {
            print("Invalid URL")
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    if let rows = jsonResult["rows"] as? [[String: Any]], let row = rows.first,
                       let elements = row["elements"] as? [[String: Any]], let element = elements.first,
                       let distance = element["distance"] as? [String: Any], let distanceText = distance["text"] as? String,
                       let duration = element["duration"] as? [String: Any], let durationText = duration["text"] as? String {
                        DispatchQueue.main.async {
                            self.tDistance = distanceText.replacingOccurrences(of: "mi", with: "")
                            print("Distance here: \(self.tDistance)")
                            self.time = durationText
                            print("Time: \(self.time)")
                        }
                    }
                }
            } catch {
                print("Error parsing JSON response: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }

    
    func addSourceDestinationMarkers(){
        let markerSource = GMSMarker()
        /*
         let orgigin = "\(24.861191),\(46.725490)"
         let destination = "\(24.861762),\(46.724032)"
         */
        //markerSource.position = CLLocationCoordinate2D(latitude: 24.9216774, longitude: 67.0914983)
        markerSource.position = CLLocationCoordinate2D(latitude: 24.861191, longitude: 46.725490)
        markerSource.icon = UIImage(named: "Pin")
        markerSource.title = "Point A"
        //markerSource.snippet = "Desti"
        
        markerSource.map = mapView
        
        let markertDestination = GMSMarker()
        //markertDestination.position = CLLocationCoordinate2D(latitude: 24.9623483, longitude: 67.0463966)
        markertDestination.position = CLLocationCoordinate2D(latitude: 24.861762, longitude: 46.724032)
        markertDestination.icon = UIImage(named: "Pin")
        markertDestination.title = "Point B"
        //markertDestination.snippet = "General Store"
        markertDestination.map = mapView
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    // Publish the user's location so subscribers can react to updates
    @Published var lastKnownLocation: CLLocation? = nil
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Notify listeners that the user has a new location
        self.lastKnownLocation = locations.last
    }
}

