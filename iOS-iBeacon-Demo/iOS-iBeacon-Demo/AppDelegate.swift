//
//  AppDelegate.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 09/10/24.
//

import UIKit
import SwiftUI
import CoreLocation

class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: CLLocationManagerDelegate
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // Log app launch status
        AppLog.info("Application did finish launching.")

        return true
    }
}
