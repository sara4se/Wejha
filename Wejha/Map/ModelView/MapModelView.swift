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


struct MapViewRepresentable: UIViewRepresentable {
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject private var locationViewModel = LocationViewModel()
    let mapView = GMSMapView(frame: .zero)
    @Binding var tDistance: String
    @Binding var time: String
    let googleApiKey = "AIzaSyDgXEpiATw1IAcW1T2gYLcwhM8S1v0IHOI"
    //    @Binding var tDistance: String
    //    @Binding var time: String
    //var searchResults: [Place]
    @Binding var markers: [GMSMarker]
    @State var currentLocation = CLLocationCoordinate2D()
    
    let destination1 = CLLocationCoordinate2D(latitude: 24.861762, longitude: 46.724032)
    let destination2 = CLLocationCoordinate2D(latitude: 24.861732, longitude: 46.724052)
    // Method to add a marker to the map
    func addMarker(position: CLLocationCoordinate2D, markers: Binding<[GMSMarker]>) {
        let marker = GMSMarker(position: position)
        marker.map = mapView
        
        // Update the binding array with the new marker
        markers.wrappedValue.append(marker)
    }
    class Coordinator: NSObject, CLLocationManagerDelegate {
        var mapView: GMSMapView?
        @Binding var currentLocation : CLLocationCoordinate2D
        init(currentLocation:  Binding<CLLocationCoordinate2D>) {
            self._currentLocation = currentLocation
        }
        @objc func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
            let tappedPoint = gestureRecognizer.location(in: mapView)
            let tappedCoordinate = mapView?.projection.coordinate(for: tappedPoint)
            currentLocation = tappedCoordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            // Get the current user location
            guard let userLocation = mapView?.myLocation?.coordinate else {
                print("User location not available")
                return
            }
            

        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                mapView?.animate(toLocation: location.coordinate)
            }
        }
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse {
                manager.startUpdatingLocation()
                mapView?.isMyLocationEnabled = true
                mapView?.settings.myLocationButton = true
                mapView?.settings.compassButton = true
                mapView?.settings.rotateGestures = true
                mapView?.settings.scrollGestures = true
                mapView?.settings.tiltGestures = true
                mapView?.settings.zoomGestures = true
                //                mapView?.camera = GMSCameraPosition(target: manager.location!.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            }
        }
    }
    
    func makeUIView(context: Context) -> GMSMapView {
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        self.mapView.settings.compassButton = true
        self.mapView.settings.rotateGestures = true
        self.mapView.settings.scrollGestures = true
        self.mapView.settings.tiltGestures = true
        self.mapView.settings.zoomGestures = true
        self.mapView.isIndoorEnabled = true
        self.mapView.settings.indoorPicker = true
        self.mapView.delegate = context.coordinator as? any GMSMapViewDelegate
//        let currentLocationlatitude = locationManager.lastKnownLocation?.coordinate.latitude ?? 0.0
//        let currentLocationlongitude = locationManager.lastKnownLocation?.coordinate.longitude ?? 0.0

////       drawRoute(from: currentLocation, to: destination)
//        fetchRoute(from: currentLocation, to: destination)
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        return mapView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(currentLocation: $currentLocation)
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.clear()
        
        if let selectedPlace = locationViewModel.selectedPlace {
            let placesClient = GMSPlacesClient()
            
            placesClient.findAutocompletePredictions(fromQuery: selectedPlace , filter: GMSAutocompleteFilter(), sessionToken: nil) { predictions, error in
                guard let prediction = predictions?.first else { return }
                placesClient.fetchPlace(fromPlaceID: prediction.placeID, placeFields: .coordinate, sessionToken: nil) { (fetchedPlace, error) in
                    guard let coordinate = fetchedPlace?.coordinate else { return }
                    let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
                    print("i enter the camera of place")
                    mapView.animate(to: camera)
                }
            }
        }
        
//        print("i am here at drow")
//        let currentLocationlatitude = locationManager.lastKnownLocation?.coordinate.latitude ?? 0.0
//        let currentLocationlongitude = locationManager.lastKnownLocation?.coordinate.longitude ?? 0.0
//        let currentLocation = CLLocationCoordinate2D(latitude: currentLocationlatitude, longitude: currentLocationlongitude)
//        let destination = CLLocationCoordinate2D(latitude: 24.861762, longitude: 46.724032)
//
////       drawRoute(from: currentLocation, to: destination)
        fetchRoute(from: destination1, to: destination2)
//        drawGoogleApiDirection(from: currentLocation, to: destination)
//        getTotalDistance()
    }
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let session = URLSession.shared
        //directions api url
        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=\(googleApiKey)")!
//        "http://maps.googleapis.com/maps/api/directions/json?origin=&destination=&sensor=false&mode=driving&key="
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
                guard let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("Error in JSONSerialization")
                    return
                }
                
                guard let routes = jsonResponse["routes"] as? [[String: Any]], !routes.isEmpty else {
                    print("No routes found")
                    return
                }
                
                guard let route = routes[0] as? [String: Any] else {
                    print("Invalid route format")
                    return
                }
                
                guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                    print("No overview polyline found")
                    return
                }
                
                guard let polyLineString = overview_polyline["points"] as? String else {
                    print("No polyline points found")
                    return
                }
                
                // Call this method to draw path on map
                self.drawPath(from: polyLineString)
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        
        task.resume()
    }

//    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
//
//        let session = URLSession.shared
//
//        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=\(googleApiKey)")!
//
////         let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin.latitude),\(origin.longitude)&destination=\(destination.latitude),\(destination.longitude)&mode=driving&key=\(googleApiKey)"
//
//        let task = session.dataTask(with: url, completionHandler: {
//            (data, response, error) in
//
//            guard error == nil else {
//                print(error!.localizedDescription)
//                return
//            }
//
//            guard let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
//                print("error in JSONSerialization")
//                return
//            }
//
//            guard let routes = jsonResponse["routes"] as? [Any] else {
//                return
//            }
//
//            guard let route = routes[0] as? [String: Any] else {
//                return
//            }
//
//            guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
//                return
//            }
//
//            guard let polyLineString = overview_polyline["points"] as? String else {
//                return
//            }
//
//            //Call this method to draw path on map
//            self.drawPath(from: polyLineString)
//        })
//        task.resume()
//    }
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapView // Google MapView
    }
    func drawGoogleApiDirection(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        //google direction api
//        let originString = "\(origin.latitude),\(origin.longitude)"
//        let destinationString = "\(destination.latitude),\(destination.longitude)"
//        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(originString)&destination=\(destinationString)&mode=driving&key=\(googleApiKey)"
//
       
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin.latitude),\(origin.longitude)&destination=\(destination.latitude),\(destination.longitude)&mode=driving&key=\(googleApiKey)"
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                
                DispatchQueue.main.async {
                    self.mapView.clear()
                    self.addSourceDestinationMarkers()
                }
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let routes = json["routes"] as! NSArray
                    print("i am here at do")
                    //self.mapView.clear()
                    
                    
                    DispatchQueue.main.async {
                        
                        for route in routes {
                            let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                            print("i drow route")
                            let points = routeOverviewPolyline.object(forKey: "points")
                            let path = GMSPath.init(fromEncodedPath: points! as! String)
                            let polyline = GMSPolyline.init(path: path)
                            
                            polyline.strokeWidth = 3
                            polyline.strokeColor = UIColor(red: 50/255, green: 165/255, blue: 102/255, alpha: 1.0)
                            let bounds = GMSCoordinateBounds(path: path!)
                            self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                            print("i drow route after")
                            polyline.map = self.mapView
                        
                        }
                    }
                }catch let error as NSError{
                    print("error drow route :\(error)")
                }
            }
        }).resume()
    }
//    func drawRoute(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
//        let originString = "\(origin.latitude),\(origin.longitude)"
//        let destinationString = "\(destination.latitude),\(destination.longitude)"
////        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(originString)&destination=\(destinationString)&mode=driving&key=\(googleApiKey)"
////
//
//        let urlString = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(origin.latitude),\(origin.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&alternatives=true&key=\(googleApiKey)")!
//
////        guard let url = URL(string: urlString) else {
////            print("Invalid URL")
////            return
////        }
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//        let task = session.dataTask(with: urlString, completionHandler: {
//            (data, response, error) in
//            if error != nil {
//                print(error!.localizedDescription)
//            }else{
//                do {
//                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
//                        print(json)
//                        let routes = json["routes"] as? [Any]
//                        print("i am here at drow")
//                        for  index in (0..<routes!.count){
//                            print("i am here at drow for")
//                            let overview_polyline = routes?[index] as?[String:Any]
//                            let overview_polyline1 = overview_polyline?["overview_polyline"] as?[String:Any]
//                            let polyString = overview_polyline1?["points"] as? String
//
//                            var linecolor = UIColor.blue
//                            if index != 0{
//                                linecolor = UIColor.darkGray
//                            }
//
//                            //Call this method to draw path on map
//                            self.showPath(polyStr: polyString!,lineColor:linecolor)
//                        }
//
//                    }
//
//                }catch{
//                    print("error in JSONSerialization")
//                }
//            }
//        })
//        task.resume()
////        let task = URLSession.shared.dataTask(with: url) {(data:Data?, response:URLResponse?, error:Error?) in
////            if let data2 = data {
////                do {
//////                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
//////
//////                    if let json = jsonSerialized, let url = json["url"], let explanation = json["explanation"] {
////                let json = try JSONSerialization.jsonObject(with: data2, options: [])
////                let routes = json?["routes"].arrayValue
////                for route in routes {
////                    let routeOverviewPolyline = route["overview_polyline"].dictionary
////                    let points = routeOverviewPolyline["points"] as? String
////                    let path = GMSPath.init(fromEncodedPath: points ?? "")
////                    let polyline = GMSPolyline.init(path: path)
////                    polyline.strokeWidth = 3
////                    polyline.strokeColor = UIColor(red: 50/255, green: 165/255, blue: 102/255, alpha: 1.0)
////                    polyline.map = self.mapView
////                }
////            }
////                catch let error{
////                print("Error parsing JSON: \(error.localizedDescription)")
////            }}
////       // URLSession.shared.dataTask(with: url) { data, response, error in
////            if let error = error {
////                print("Error: \(error.localizedDescription)")
////                return
////            }
////
////            else if let error = error {
////               print(error.localizedDescription)
////           }
////        } task.resume()
//    }
//    DispatchQueue.main.async {
//        self.mapView.clear()
//        // Example usage
//        addMarker(position: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), markers: $markers)
//        // Add marker for origin
//        //                    self.addMarker(at: destination) // Add marker for destination
//    }
    
    
  
    func getTotalDistance() {        //google Distanse api
        
        let orgigin = "\(24.861191),\(46.725490)"
        let destination = "\(24.861762),\(46.724032)"
        
        let urlString = "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=\(destination)&origins=\(orgigin)&units=imperial&mode=driving&language=en-EN&sensor=false&key=\(googleApiKey)"
        
        let url = URL(string: urlString)
        print(url)
        let task = URLSession.shared.dataTask(with: url!) { (data:Data?, response:URLResponse?, error:Error?) in
            if let data = data {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
                    
                    if let json = jsonSerialized, let url = json["url"], let explanation = json["explanation"] {
                        let rows = json["rows"] as! NSArray
                        print("rows\(rows)")
                        let dic = rows[0] as! Dictionary<String, Any>
                        let elements = dic["elements"] as! NSArray
                        let dis = elements[0] as! Dictionary<String, Any>
                        let distanceMiles = dis["distance"] as! Dictionary<String, Any>
                        let miles = distanceMiles["text"]! as! String
                        let TimeRide = dis["duration"] as! Dictionary<String, Any>
                        let finalTime = TimeRide["text"]! as! String
                        DispatchQueue.main.async {
                            self.tDistance = miles.replacingOccurrences(of: "mi", with: "")
                            print("Distance: \(tDistance)")
                            self.time = finalTime
                            print("time: \(time)")
                        }
                    }
                }
                catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    //        URLSession.shared.dataTask(with: url!, completionHandler: {
    //            (data, response, error) in
    //            if(error != nil){
    //                print("error")
    //                //showToast(viewControl: self, titleMsg: "", msgTitle: "The Internet connection appears to be offline.")
    //            }else{
    //                do{
    //                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
    //                    let rows = json["rows"] as! NSArray
    //                    print(rows)
    //                    let dic = rows[0] as! Dictionary<String, Any>
    //                    let elements = dic["elements"] as! NSArray
    //                    let dis = elements[0] as! Dictionary<String, Any>
    //                    let distanceMiles = dis["distance"] as! Dictionary<String, Any>
    //                    let miles = distanceMiles["text"]! as! String
    //                    let TimeRide = dis["duration"] as! Dictionary<String, Any>
    //                    let finalTime = TimeRide["text"]! as! String
    //                    DispatchQueue.main.async {
    //                        self.tDistance = miles.replacingOccurrences(of: "mi", with: "")
    //                        self.time = finalTime
    //                    }
    //                }catch let error as NSError{
    //                    print("error:\(error)")
    //                }
    //
    //            }
    //        }).resume()

func addSourceDestinationMarkers(){
    let markerSource = GMSMarker()
    /*
     let orgigin = "\(24.861191),\(46.725490)"
     let destination = "\(24.861762),\(46.724032)"
     */
    //markerSource.position = CLLocationCoordinate2D(latitude: 24.9216774, longitude: 67.0914983)
    markerSource.position = CLLocationCoordinate2D(latitude: 24.861191, longitude: 46.725490)
    markerSource.icon = UIImage(named: "markerb")
    markerSource.title = "Point A"
    //markerSource.snippet = "Desti"
    
    markerSource.map = mapView
    
    let markertDestination = GMSMarker()
    //markertDestination.position = CLLocationCoordinate2D(latitude: 24.9623483, longitude: 67.0463966)
    markertDestination.position = CLLocationCoordinate2D(latitude: 24.861762, longitude: 46.724032)
    markertDestination.icon = UIImage(named: "markerb")
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


///this code will be used never delete it
/*
 
 class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
     var mapView: GMSMapView?
     // Publish the user's location so subscribers can react to updates
     @Published var lastKnownLocation: CLLocation? = nil
     private let manager = CLLocationManager()
     
     override init() {
         super.init()
         self.manager.delegate = self
         self.manager.startUpdatingLocation()
     }
     @objc func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
         let tappedPoint = gestureRecognizer.location(in: mapView)
         let tappedCoordinate = mapView?.projection.coordinate(for: tappedPoint)
         
         // Get the current user location
         guard let userLocation = mapView?.myLocation?.coordinate else {
             print("User location not available")
             return
         }
         
         
     }
     func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         if status == .authorizedWhenInUse {
             self.manager.startUpdatingLocation()
         }
     }
     
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation],status: CLAuthorizationStatus) {
         // Notify listeners that the user has a new location
         self.lastKnownLocation = locations.last
         if status == .authorizedWhenInUse {
             manager.startUpdatingLocation()
             mapView?.isMyLocationEnabled = true
             mapView?.settings.myLocationButton = true
             mapView?.settings.compassButton = true
             mapView?.settings.rotateGestures = true
             mapView?.settings.scrollGestures = true
             mapView?.settings.tiltGestures = true
             mapView?.settings.zoomGestures = true
             //                mapView?.camera = GMSCameraPosition(target: manager.location!.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
         }
     }
     
 }


*/
