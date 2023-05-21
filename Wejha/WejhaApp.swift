//
//  WejhaApp.swift
//  Wejha
//
//  Created by Sara Alhumidi on 20/10/1444 AH.
//

import SwiftUI
import GooglePlaces
import GoogleMaps
import FirebaseCore
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      GMSPlacesClient.provideAPIKey("AIzaSyDgXEpiATw1IAcW1T2gYLcwhM8S1v0IHOI")
      GMSServices.provideAPIKey("AIzaSyDgXEpiATw1IAcW1T2gYLcwhM8S1v0IHOI")
    return true
  }
}
@main
struct WejhaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            MapView()
        }
    }
     
}
