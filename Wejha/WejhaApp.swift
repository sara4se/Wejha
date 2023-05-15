//
//  WejhaApp.swift
//  Wejha
//
//  Created by Sara Alhumidi on 20/10/1444 AH.
//

import SwiftUI

import GoogleMaps
@main
struct WejhaApp: App {
    var body: some Scene {
        WindowGroup {
            ARUIView()
        }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyDgXEpiATw1IAcW1T2gYLcwhM8S1v0IHOI")
        //AIzaSyCP4TRMYUvFilsluvQnRZGV1mWFJHBoGT8
        return true
    }
     
}
