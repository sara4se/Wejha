//
//  WejhaApp.swift
//  Wejha
//
//  Created by Sara Alhumidi on 20/10/1444 AH.
//

import SwiftUI
import GooglePlaces

@main
struct WejhaApp: App {
    var body: some Scene {
        WindowGroup {
            GetStartedView()
        }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey("AIzaSyDgXEpiATw1IAcW1T2gYLcwhM8S1v0IHOI") // Replace with your actual API key

        //AIzaSyCP4TRMYUvFilsluvQnRZGV1mWFJHBoGT8
        return true
    }
     
}
