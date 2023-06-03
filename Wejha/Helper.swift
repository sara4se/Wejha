//
//
//extension ViewControllerOfMap: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            // Use the current location
//            print("Current Location: \(location.coordinate)")
//            
//            // Stop updating the location once obtained
//            manager.stopUpdatingLocation()
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            // Permission granted, start updating location
//            manager.startUpdatingLocation()
//        }
//    }
//}
//struct MapViewController: UIViewControllerRepresentable {
//    let viewControllerOfMap = ViewControllerOfMap()
//    func makeUIViewController(context: Context) -> ViewControllerOfMap {
//        
//        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(ViewControllerOfMap.Coordinator.handleMapTap(_:)))
//        viewControllerOfMap.mapView.addGestureRecognizer(tapGesture)
//        return ViewControllerOfMap()
//    }
//    
//    func updateUIViewController(_ uiViewController: ViewControllerOfMap, context: Context) {
//        // Update the view controller if needed
//    }
//   
//    
//}
//
//class ViewControllerOfMap: UIViewController , GMSMapViewDelegate{
//    let mapView = GMSMapView()
//    override func viewDidLoad() {
//        mapView.delegate = self
//        super.viewDidLoad()
//        setupMapView()
//    }
//    
//    private func setupMapView() {
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
//        self.view.addSubview(mapView)
//
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
//    }
//    class Coordinator: NSObject, CLLocationManagerDelegate, GMSMapViewDelegate {
//        var mapView: GMSMapView?
//        //        @Binding var currentLocation : CLLocationCoordinate2D
//        var parent: ViewControllerOfMap
//        
//        init(_ parent: ViewControllerOfMap) {
//            self.parent = parent
//        }
//        func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
//    
//             let marker = GMSMarker(position: coordinate)
//            
//             let decoder = CLGeocoder()
//
//             //This method is used to get location details from coordinates
//             decoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { placemarks, err in
//                if let placeMark = placemarks?.first {
//
//                    let placeName = placeMark.name ?? placeMark.subThoroughfare ?? placeMark.thoroughfare!   ///Title of Marker
//                    //Formatting for Marker Snippet/Subtitle
//                    var address : String! = ""
//                    if let subLocality = placeMark.subLocality ?? placeMark.name {
//                        address.append(subLocality)
//                        address.append(", ")
//                    }
//                    if let city = placeMark.locality ?? placeMark.subAdministrativeArea {
//                        address.append(city)
//                        address.append(", ")
//                    }
//                    if let state = placeMark.administrativeArea, let country = placeMark.country {
//                        address.append(state)
//                        address.append(", ")
//                        address.append(country)
//                    }
//
//                    // Adding Marker Details
//                    marker.title = placeName
//                    marker.snippet = address
//                    marker.appearAnimation = .pop
//                    marker.map = mapView
//                }
//            }
//        }
//
//        @objc func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
//            let mapView = gestureRecognizer.view as! GMSMapView
//            let coordinate = mapView.projection.coordinate(for: gestureRecognizer.location(in: mapView))
//            
//            // Get the current user's location
//            if let userLocation = mapView.myLocation?.coordinate {
//                // Draw the route from userLocation to the tapped coordinate
//              //  parent.getRouteSteps(from: userLocation, to: coordinate)
//            }
//            
//            // Add a marker at the tapped coordinate
//        //    parent.addMarker(position: coordinate, markers: parent.$markers)
//        }
//        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            if let location = locations.first {
//                //                currentLocation = location.coordinate
//                mapView?.animate(toLocation: location.coordinate)
//                let cameraUpdate = GMSCameraPosition(target: location.coordinate, zoom: 10)
//                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
//                                                                longitude: location.coordinate.longitude,
//                                                                zoom: 12.0)
//                mapView?.animate(to: camera)
//             
//            }
//        }
//        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//            if status == .authorizedWhenInUse {
//                manager.startUpdatingLocation()
//                mapView?.isMyLocationEnabled = true
//                mapView?.settings.myLocationButton = true
//                mapView?.settings.compassButton = true
//                mapView?.settings.rotateGestures = true
//                mapView?.settings.scrollGestures = true
//                mapView?.settings.tiltGestures = true
//                mapView?.settings.zoomGestures = true
//                //                mapView?.camera = GMSCameraPosition(target: manager.location!.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//            }
//        }
//    }
//}

import SwiftUI
import Foundation

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








//        print("i am here at drow")
//        let currentLocationlatitude = locationManager.lastKnownLocation?.coordinate.latitude ?? 0.0
//        let currentLocationlongitude = locationManager.lastKnownLocation?.coordinate.longitude ?? 0.0
//        let currentLocation = CLLocationCoordinate2D(latitude: currentLocationlatitude, longitude: currentLocationlongitude)
//        let destination = CLLocationCoordinate2D(latitude: 24.861762, longitude: 46.724032)
//
////       drawRoute(from: currentLocation, to: destination)
//   fetchRoute(from: destination1, to: destination2)
//        drawGoogleApiDirection(from: currentLocation, to: destination)
//        getTotalDistance()

//    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
//        let session = URLSession.shared
//        //directions api url
//        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=\(googleApiKey)")!
////        "http://maps.googleapis.com/maps/api/directions/json?origin=&destination=&sensor=false&mode=driving&key="
//        let task = session.dataTask(with: url) { (data, response, error) in
//            guard error == nil else {
//                print(error!.localizedDescription)
//                return
//            }
//
//            guard let data = data else {
//                print("No data received")
//                return
//            }
//
//            do {
//                guard let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
//                    print("Error in JSONSerialization")
//                    return
//                }
//
//                guard let routes = jsonResponse["routes"] as? [[String: Any]], !routes.isEmpty else {
//                    print("No routes found")
//                    return
//                }
//
//                guard let route = routes[0] as? [String: Any] else {
//                    print("Invalid route format")
//                    return
//                }
//
//                guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
//                    print("No overview polyline found")
//                    return
//                }
//
//                guard let polyLineString = overview_polyline["points"] as? String else {
//                    print("No polyline points found")
//                    return
//                }
//
//                // Call this method to draw path on map
//                self.drawPath(from: polyLineString)
//            } catch {
//                print("Error parsing JSON: \(error)")
//            }
//        }
//
//        task.resume()
//    }
/*   if let selectedPlace = locationViewModel.selectedPlace {
 let placesClient = GMSPlacesClient()
 
 placesClient.findAutocompletePredictions(fromQuery: selectedPlace , filter: GMSAutocompleteFilter(), sessionToken: nil) { predictions, error in
 guard let prediction = predictions?.first else { return }
 placesClient.fetchPlace(fromPlaceID: prediction.placeID, placeFields: .coordinate, sessionToken: nil) { (fetchedPlace, error) in
 guard let coordinate = fetchedPlace?.coordinate else { return }
 print("coordinate:\(String(describing: fetchedPlace?.coordinate))")
 let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 5)
 print("i enter the camera of place")
 self.mapView.animate(to: camera)
 }
 }
 
 }*/


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
//    func drawPath(from polyStr: String){
//        let path = GMSPath(fromEncodedPath: polyStr)
//        let polyline = GMSPolyline(path: path)
//        polyline.strokeWidth = 3.0
//        polyline.map = mapView // Google MapView
//    }
//    func drawGoogleApiDirection(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
//        //google direction api
////        let originString = "\(origin.latitude),\(origin.longitude)"
////        let destinationString = "\(destination.latitude),\(destination.longitude)"
////        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(originString)&destination=\(destinationString)&mode=driving&key=\(googleApiKey)"
////
//
//        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin.latitude),\(origin.longitude)&destination=\(destination.latitude),\(destination.longitude)&mode=driving&key=\(googleApiKey)"
//
//        let url = URL(string: urlString)
//        URLSession.shared.dataTask(with: url!, completionHandler: {
//            (data, response, error) in
//            if(error != nil){
//                print("error")
//            }else{
//
//                DispatchQueue.main.async {
//                    self.mapView.clear()
//                    self.addSourceDestinationMarkers()
//                }
//
//                do{
//                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
//                    let routes = json["routes"] as! NSArray
//                    print("i am here at do")
//                    //self.mapView.clear()
//
//
//                    DispatchQueue.main.async {
//
//                        for route in routes {
//                            let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
//                            print("i drow route")
//                            let points = routeOverviewPolyline.object(forKey: "points")
//                            let path = GMSPath.init(fromEncodedPath: points! as! String)
//                            let polyline = GMSPolyline.init(path: path)
//
//                            polyline.strokeWidth = 3
//                            polyline.strokeColor = UIColor(red: 50/255, green: 165/255, blue: 102/255, alpha: 1.0)
//                            let bounds = GMSCoordinateBounds(path: path!)
//                            self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
//                            print("i drow route after")
//                            polyline.map = self.mapView
//
//                        }
//                    }
//                }catch let error as NSError{
//                    print("error drow route :\(error)")
//                }
//            }
//        }).resume()
//    }
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


struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> some UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //
    }
}
struct categoryContent: View {
    @StateObject private var viewModels = FirebaseModel()
    var body: some View{
        VStack{
            
            Text("this is category content")}
        .onAppear() {
            print("PostsListView appears. and data updates.")
            // self.viewModels.subscribeFireAblutionW()
            //   self.viewModels.FireGate()}
        }
    }
}








//        func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
//             //Creating Marker
//             let marker = GMSMarker(position: coordinate)
//             let decoder = CLGeocoder()
//            //This method is used to get location details from coordinates
////             decoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)){ placemarks, err in
////                if let placeMark = placemarks?.first {
////                    let placeName = placeMark.name ?? placeMark.subThoroughfare ?? placeMark.thoroughfare!   ///Title of Marker
////                    //Formatting for Marker Snippet/Subtitle
////                    var address : String! = ""
////                    if let subLocality = placeMark.subLocality ?? placeMark.name {
////                        address.append(subLocality)
////                        address.append(", ")
////                    }
////                    if let city = placeMark.locality ?? placeMark.subAdministrativeArea {
////                        address.append(city)
////                        address.append(", ")
////                    }
////                    if let state = placeMark.administrativeArea, let country = placeMark.country {
////                        address.append(state)
////                        address.append(", ")
////                        address.append(country)
////                    }
////                    // Adding Marker Details
////                    marker.title = placeName
////                    marker.snippet = address
////                    marker.appearAnimation = .pop
////                    marker.map = mapView
////                }
////            }
//        }
//        @objc func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
//            let mapView = gestureRecognizer.view as! GMSMapView
//            let coordinate = mapView.projection.coordinate(for: gestureRecognizer.location(in: mapView))
//
//            // Get the current user's location
//            if let userLocation = mapView.myLocation?.coordinate {
//                // Draw the route from userLocation to the tapped coordinate
//                parent.getRouteSteps(from: userLocation, to: coordinate)
//            }
//
//            // Add a marker at the tapped coordinate
//            parent.addMarker(position: coordinate, markers: parent.$markers)
//        }
//        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            if let location = locations.first {
//                //                currentLocation = location.coordinate
//                mapView?.animate(toLocation: location.coordinate)
//                let cameraUpdate = GMSCameraPosition(target: location.coordinate, zoom: 10)
//                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
//                                                                longitude: location.coordinate.longitude,
//                                                                zoom: 12.0)
//                mapView?.animate(to: camera)
//
//            }
//        }
//        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//            if status == .authorizedWhenInUse {
//                manager.startUpdatingLocation()
//                mapView?.isMyLocationEnabled = true
//                mapView?.settings.myLocationButton = true
//                mapView?.settings.compassButton = true
//                mapView?.settings.rotateGestures = true
//                mapView?.settings.scrollGestures = true
//                mapView?.settings.tiltGestures = true
//                mapView?.settings.zoomGestures = true
//                //                mapView?.camera = GMSCameraPosition(target: manager.location!.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//            }
//        }

//import LocationBasedAR
import ARKit
import RealityKit
//24.793416, 46.746357
//import ARCL

//struct ARViewContainer: UIViewControllerRepresentable {
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//
//    }
//
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let arView = LBARView(frame: .zero)
//        let configuration: ARWorldTrackingConfiguration = LBARView.defaultConfiguration()
//        let options: ARSession.RunOptions = [
//        ]
//        let location = CLLocation(latitude: 24.793416, longitude: 46.746357)
//        arView.add(location: location)
//
//        let coordinate = CLLocationCoordinate2D(latitude: 24.793416, longitude: 46.746357)
//        let accuracy = CLLocationAccuracy(10) // Set the accuracy to 10 meters
//        let placemark = Placemark(coordinate: coordinate, accuracy: accuracy)
//        let altitude = CLLocationDistance(0)
//        arView.add(placemark: placemark)
//        let transform = simd_float4x4.distanceTransform(Float(2))
//        let name = "My Anchor"
//        let anchor = LBAnchor(name: name, transform: transform, coordinate: coordinate, accuracy: accuracy, altitude: altitude)
//        arView.add(anchor: anchor)
//        let anchorEntity = AnchorEntity(world: SIMD3<Float>(0, 0, -1))
//        arView.scene.addAnchor(anchorEntity)
//
//
//        arView.session.run(configuration, options: options)
//
//        // perform view's configuration
//
////        return arView
//
//
//        let viewController = UIViewController()
//        viewController.view = arView
//        return viewController
//    }
//
//}
////
//struct ContentView: View {
//
//  // options to run session
//
//
//    var body: some View {
//        VStack{
//          //  ARViewContainer()
//            HStack{
//                Text("hi")
//            }
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View
//    {
//        ContentView()
//    }
//}
//
// here with sheet and button
/*
 
 //
 //  MapUIView.swift
 //  Wejha
 //@State var userLocation: CLLocationCoordinate2D?
 //  Created by Sara Alhumidi on 04/11/1444 AH.
 //
 import GoogleMaps

 import SwiftUI
 class LocationViewModel: ObservableObject {
     @Published var selectedPlace: String?
 }

 struct MapUIView: View {
     @State var offset: CGFloat = 0
     @State var locationQuery : String = ""
     @State var startLocationY: CGFloat = 0
     @State var translationHeight: CGFloat = 0
     @State var translationWidth: CGFloat = 0
     @State var sheetShowing: Bool = true
     @State var selectedPlace: String? = ""
     @StateObject private var viewModels = FirebaseModel()
    @ObservedObject private var locationViewModel = LocationViewModel()
     @ObservedObject var locationHandler = PlaceSearch()
     @State var isARViewActive = false // New state variable
     @State var isMapActive = false
     @State var presentSheet = true
     @State private var searchText :String? = ""
     @State private var tDistance: String = ""
     @State private var time: String = ""
     @State private var markers: [GMSMarker] = []
     @State private var placesView: [Places] = []
     
 //    init() {
 //        _mapViewModel = StateObject(wrappedValue:MapViewRepresentable(firebaseViewModel: viewModels))
 //    }
     //    @ObservedObject
     //    @State var MVR = MapViewRepresentable( selectedPlace:  .constant(""), tDistance:  .constant(""), time: .constant(""))
     var body: some View {
         NavigationView {
             ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
                 MapViewRepresentable(tDistance: $tDistance, time: $time, places: $placesView ).edgesIgnoringSafeArea(.all)
                 
                 GeometryReader { geo in
                     VStack(spacing: 0){
                         Divider()
                         Button {
                              
                             isMapActive.toggle()
                         } label: {
                             
                             if(isARViewActive){
                                 Image("MapButtonActive").resizable()
                             }else{
                                 Image("MapButtonDisable").resizable()
                             }
                         }.disabled(isMapActive ? false  : true)
                         Divider()
                         Button {
                             sheetShowing.toggle()
                         } label: {
                             ZStack{
                                 Image(systemName: "list.dash").resizable().frame(width: 20,height: 20)
                                     .foregroundColor(.gray)
                             }.frame(width: 50,height: 30)
                                 .background(Color.white)
                                 .aspectRatio(contentMode: .fill)
                         }
                         Divider()
                         Button {
                             isARViewActive.toggle()
                         } label: {
                             
                             //                        Text("width:\(geo.frame(in: .global).width) height:\(geo.frame(in: .global).height) maxX:\(geo.frame(in: .global).maxX) midX:\(geo.frame(in: .global).midX) midY:\(geo.frame(in: .global).midY) maxY:\(geo.frame(in: .global).maxY) startLocation.y:\(startLocationY) translation.width:\(translationWidth) translation.height:\(translationHeight) offset:\(offset)")
 //                            Text(tDistance)
 //                            Text(time)
                             if(isARViewActive){
                              Image("ArButtonDisable").resizable()
                             }else{
                              Image("ArButtonActive").resizable()
                             }
                         }
                     }.frame(width: 50,height: 120).padding(.leading, 350)
                         .padding(.top, 50)
                     // to read frame height
                 
                   
                 }.ignoresSafeArea(.all, edges: .bottom)
             }
             .sheet(isPresented: $sheetShowing, content: {
                 GeometryReader { geo in
                     VStack(spacing: 0){
                         BottomSheet(locationQuery: $locationQuery, locationViewModel: locationViewModel, locationHandler: locationHandler)
 //                            .offset(y: geo.frame(in: .global).height - 260)
 //                            .offset(y: offset)
 //                            .gesture(DragGesture().onChanged({ value in
 //                                startLocationY = value.startLocation.y
 //                                translationHeight = value.translation.height
 //                                translationWidth = value.translation.width
 //
 ////                                withAnimation {
 ////                                    if value.startLocation.y > geo.frame(in: .global).midX {
 ////                                        if value.translation.height < 0 && offset > (-geo.frame(in: .global).height + 150) {
 ////                                            offset = value.translation.height
 ////                                        }
 ////                                    }
 ////                                    if value.startLocation.y < geo.frame(in: .global).midX {
 ////                                        if value.translation.height > 0 && offset < 0 {
 ////                                            offset = (-geo.frame(in: .global).height + 150) + value.translation.height
 ////                                        }
 ////                                    }
 ////                                }
 //                            })
 //                                .onEnded({ value in
 //                                    withAnimation {
 //                                        // checking and pulling up the screen
 //                                        if value.startLocation.y > geo.frame(in: .global).midX {
 //                                            if -value.translation.height > geo.frame(in: .global).midX {
 //                                                offset = (-geo.frame(in: .global).height + 150)
 //                                                return
 //                                            }
 //                                            offset = 0
 //                                        }
 //                                        if value.startLocation.y < geo.frame(in: .global).midX {
 //                                            if value.translation.height < geo.frame(in: .global).midX {
 //                                                offset = (-geo.frame(in: .global).height + 150)
 //                                                return
 //                                            }
 //                                            offset = 0
 //                                        }
 //                                    }
 //                                }))
                         
                     }}.presentationDetents([.medium, .fraction(0.7)])
             })
             .onAppear{
                 //placesView = viewModels.places
                 viewModels.FireGate()
             }
             .fullScreenCover(isPresented: $isARViewActive, content: {
                 ARUIView(selectedPlace: $selectedPlace)
             })
             .fullScreenCover(isPresented: $isMapActive, content: {
                 MapUIView()
             })
 //            .sheet(isPresented: $isARViewActive, content: {
 //                ARUIView()
 //            })
 //                .navigationDestination(isPresented: $isARViewActive) {
 //                    let _ = print("hello")
 //                    ARUIView()
 //                }
         }
     }
 }

  

 struct MapUIView_Previews: PreviewProvider {
     static var previews: some View {
         MapUIView()
     }
 }
 //



 */
