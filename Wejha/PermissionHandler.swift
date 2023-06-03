//
//  PermissionHandler.swift
//  Wejha
//
//  Created by Sara Alhumidi on 14/11/1444 AH.
//

import Foundation
import CoreLocation
import AVFoundation
import SwiftUI

class PermissionHandler {
    @Binding var cantOpenCamera : Bool
    init(cantOpenCamera: Binding<Bool>) {
        self._cantOpenCamera = cantOpenCamera
    } 
    func requestCameraPermission() {
        
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                // Camera permission granted
                print("Camera permission granted")
            } else {
                // Camera permission denied
                self.cantOpenCamera.toggle()
                
          }
        }
    }
    
    func requestLocationPermission() {
        let locationManager = CLLocationManager()
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            // Location permission already granted
            print("Location permission granted")
        case .denied, .restricted:
            // Location permission denied
            print("Location permission denied")
        @unknown default:
            break
        }
    }
}
