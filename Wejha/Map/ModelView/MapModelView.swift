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
    @ObservedObject var focusPlace : FocusPlace = FocusPlace()
    @ObservedObject private var vmMapRouteTasks = MapRouteTasks()
    @ObservedObject var locationHandler = PlaceSearch()
    @StateObject private var viewModels = FirebaseModel()
//    @Binding var directions: [String]
    let mapView = GMSMapView(frame: .zero)
    @Binding var tDistance: String
    @Binding var time: String
    @Binding var places: [Spical]
    let googleApiKey = "AIzaSyDgXEpiATw1IAcW1T2gYLcwhM8S1v0IHOI"
   // @State var plasesArray = [Places]()
    var db = Firestore.firestore()
    //24.814339, 46.720124
    //24.729377, 46.716325
    //24.741268, 46.749721
    //24.726353, 46.773846
    
    //24.8707681,46.7227661
    //24.849621, 46.739755
    let destination1 = CLLocationCoordinate2D(latitude: 24.741268, longitude: 46.749721)
    let destination2 = CLLocationCoordinate2D(latitude: 24.726353, longitude: 46.773846)

   
class Coordinator: NSObject, CLLocationManagerDelegate, GMSMapViewDelegate {
    var mapView: GMSMapView
    var parent: MapViewRepresentable
    var listenerRegistration: ListenerRegistration?
    //@Binding var currentLocation : CLLocationCoordinate2D
  
       init(_ parent: MapViewRepresentable,mapView: GMSMapView) {
           self.mapView = mapView
           self.parent = parent
           super.init()
           mapView.delegate = self
           parent.locationManager.startUpdatingHeading()
        
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
        // Calculate the heading between the points using HeadingCalculator
        let heading = HeadingCalculator.calculateHeading(cor: currentLocation, cor2: coordinate)
        // Use the heading value to move the arrow in AR (pass it to ARViewController)
        let arViewController = ARViewController()
        
//        arViewController.moveRightAction(angle: Float(heading))
//        print("angel :\(heading)")
    }
//    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
//
//    }
    func takePlaces(lat: CLLocationCoordinate2D, lang:CLLocationCoordinate2D) {
        for place in self.parent.places {
            print("Markers from documents\(place)")
            let marker = GMSMarker(position: place.coordinates)
            print("Marker position \(place.coordinates.latitude) and \(place.coordinates.longitude)")
            marker.title = "Marker Title"
               marker.snippet = "Marker Snippet"
               marker.icon = UIImage(named: "marker_icon")
               marker.opacity = 0.8
            marker.map = self.mapView
            print("Processing place")
        }
        
        if self.parent.places.isEmpty {
            print("Empty")
        }
    }
    
    
    func updateMarkers2() {
        // mapView.clear()
        // Add a subscriber to the lastKnownLocation property
        self.parent.locationManager.$lastKnownLocation.sink { location in
            if let heading = location?.course {
             //   print("Current heading: \(heading) degrees")
            } else {
                print("Heading information not available")
            }
        }
        if listenerRegistration == nil {
            listenerRegistration = parent.db.collection("BusStation").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.parent.places = documents.compactMap { queryDocumentSnapshot in
                    let documentData = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    let latitude = documentData["Lat"] as? Double ?? 0.0
                    let longitude = documentData["Lang"] as? Double ?? 0.0
                    print("Found documents")
                    return Spical(id: id, coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                }
                for place in self.parent.places {
                    print("Markers from documents\(place)")
                    let marker = GMSMarker(position: place.coordinates)
                    print("Marker position \(place.coordinates.latitude) and \(place.coordinates.longitude)")
                    marker.title = "Marker Title"
                       marker.snippet = "Marker Snippet"
                       marker.icon = UIImage(named: "marker_icon")
                       marker.opacity = 0.8
                    marker.map = self.mapView
                    print("Processing place")
                }
                
                if self.parent.places.isEmpty {
                    print("Empty")
                }
            }
        }
    }
}       
//    var coordinates: [CLLocationCoordinate2D]
    func makeUIView(context: Context) -> GMSMapView {
        mapView.delegate = context.coordinator
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 170, right: 0)
        self.mapView.settings.compassButton = true
        self.mapView.settings.rotateGestures = true
        self.mapView.settings.scrollGestures = true
        self.mapView.settings.tiltGestures = true
        self.mapView.settings.zoomGestures = true
        self.mapView.isIndoorEnabled = true
        self.mapView.settings.indoorPicker = true
        self.mapView.delegate = context.coordinator as? GMSMapViewDelegate
      //  context.coordinator.updateMarkers(mapView: mapView)
      context.coordinator.updateMarkers2()
      
        return mapView
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self, mapView: mapView)
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        //mapView.clear()
        context.coordinator.updateMarkers2()
  }
    func getRouteSteps(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
//        mapView.clea r()
        let session = URLSession.shared
        
    
//        arViewController.moveArrowWithHeading(heading: heading)
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
          //  print("jsonResult :\(jsonResult)")
            
            guard let routes = jsonResult["routes"] as? [Any], !routes.isEmpty else {
                print("No routes found.")
                return
            }

            guard routes[0] is [String: Any] else {
                print("Invalid route data.")
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
        let taskIdentifier: UIBackgroundTaskIdentifier
        taskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
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
            UIApplication.shared.endBackgroundTask(taskIdentifier)
        }
        
        task.resume()
    }

}
class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    // Publish the user's location so subscribers can react to updates
    @Published var lastKnownLocation: CLLocation? = nil
    let manager = CLLocationManager()
    let heading = CLLocationDirection()
    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.startUpdatingLocation()
        manager.delegate = self
        manager.startUpdatingHeading()
    }
    
    func startUpdatingHeading() {
        manager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let heading = newHeading.trueHeading
         //print("Current heading in map: \(heading) degrees")
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
 
/**
 func updateArrowRotation(withHeading heading: Double) {
     let headingInRadians = heading.degreesToRadians
     let rotation = SCNVector3(0, headingInRadians, 0) // Adjust the axis and values based on your arrow's orientation
     arrowNode.eulerAngles = rotation
 }
 */

 
struct HeadingCalculator {
    static func calculateHeading(cor: CLLocationCoordinate2D, cor2: CLLocationCoordinate2D) -> Double {
        let lat1 = cor.latitude
        let lon1 = cor.longitude
        let lat2 = cor2.latitude
        let lon2 = cor2.longitude
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        
        let heading = atan2(y, x)
        
        // Convert heading from radians to degrees
        let headingDegrees = heading * 180 / .pi
        
        return headingDegrees
    }
}
