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
 

struct MapViewRepresentable: UIViewRepresentable  {
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject private var locationViewModel = LocationViewModel()
    @ObservedObject var locationHandler = PlaceSearch()
    @StateObject private var viewModels = FirebaseModel()
    let mapView = GMSMapView(frame: .zero)
    @Binding var tDistance: String
    @Binding var time: String
    @Binding var places: [Places]
    let googleApiKey = "AIzaSyDgXEpiATw1IAcW1T2gYLcwhM8S1v0IHOI"

    
//    var coordinates: [CLLocationCoordinate2D]

    //24.814339, 46.720124
    //24.729377, 46.716325
    //24.741268, 46.749721
    //24.726353, 46.773846
    let destination1 = CLLocationCoordinate2D(latitude: 24.741268, longitude: 46.749721)
    let destination2 = CLLocationCoordinate2D(latitude: 24.726353, longitude: 46.773846)
    // Method to add a marker to the map
    func addMarker(position: CLLocationCoordinate2D, markers: Binding<[GMSMarker]>) {
        let marker = GMSMarker(position: position)
        markers.wrappedValue.append(marker)
        marker.map = mapView
    }
//    init(firebaseViewModel: FirebaseModel) {
//            self.viewModels = firebaseViewModel
//        }
        
    private func updateMarkers(mapView: GMSMapView) {
           mapView.clear()
        if (viewModels.places.isEmpty){
            print("i'm empty")
        }
        for place in viewModels.places {
               let marker = GMSMarker()
               marker.position = CLLocationCoordinate2D(latitude: place.Lat, longitude: place.Lang)
               marker.map = mapView
           }
       }
class Coordinator: NSObject, CLLocationManagerDelegate, GMSMapViewDelegate {
    var mapView: GMSMapView?
    //@Binding var currentLocation : CLLocationCoordinate2D
    var parent: MapViewRepresentable
    init(_ parent: MapViewRepresentable){
        self.parent = parent
    }
}
    
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
        self.mapView.delegate = context.coordinator as? any GMSMapViewDelegate
      
            updateMarkers(mapView: mapView)
      
        // Observe the changes in the receivedData property
            
        if let locationcoordinate =  locationManager.lastKnownLocation?.coordinate{
            print("locationcoordinate\(locationcoordinate)")
            getRouteSteps(from: locationcoordinate, to: destination2)
        }
       
        return mapView
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        //mapView.clear()
        DispatchQueue.main.async {
            updateMarkers(mapView: mapView)}
        mapView.clear() // Clear any existing markers

           // Iterate through each coordinate in the list
//        ForEach(viewModels.places) { place in
//
//
////            CLLocationCoordinate2D(latitude: place.Lat, longitude: place.Lang)
//
//            var marker = GMSMarker().position
////            marker.latitude = CLLocationDegrees(place.Lat)
////            marker.longitude = CLLocationDegrees(place.Lang)
////            CLLocationCoordinate2DMake(CLLocationDegrees(place.Lat) , CLLocationDegrees(place.Lang))
////               marker.map = mapView
//           }
        
       
        if let selectedPlace = locationViewModel.selectedPlace {
            locationHandler.searchLocation(selectedPlace)
        }
//        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleMapTap(_:)))
//            mapView.addGestureRecognizer(tapGesture)
      //  getRouteSteps(from: destination1, to: destination2)
            
            

    }

    func getRouteSteps(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
        let session = URLSession.shared
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=walking&key=\(googleApiKey)")!
        
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
        polyline.strokeWidth = 3.0
        polyline.map = mapView // Google MapView
        let cameraUpdate = GMSCameraUpdate.fit(GMSCoordinateBounds(coordinate: destination1, coordinate: destination2))
        mapView.moveCamera(cameraUpdate)
        let currentZoom = mapView.camera.zoom
        mapView.animate(toZoom: currentZoom - 1.4)
    }
    func getTotalDistance(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {        //google Distanse api
        
//        let orgigin = "\(24.861191),\(46.725490)"
//        let destination = "\(24.861762),\(46.724032)"
//
        let session = URLSession.shared
        let urlString = URL(string: "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=\(destination)&origins=\(source)&units=imperial&mode=driving&language=en-EN&sensor=false&key=\(googleApiKey)")!
        
        let task = session.dataTask(with: urlString , completionHandler: {
            (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let data = data {
                do {
                    let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    if let json = jsonResult,
                       let url = json["url"],
                       let explanation = json["explanation"] {
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
            }  else if let error = error {
                    print(error.localizedDescription)
                }
                
                print("error in JSONSerialization")
                return
                
            })
    
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

