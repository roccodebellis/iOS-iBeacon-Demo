//
//  CoreLocationManager.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 06/10/24.
//

import CoreLocation

/// `CoreLocationManager` handles CoreLocation-related tasks and conforms to `AnyCoreLocationManager`.
class CoreLocationManager: NSObject, CLLocationManagerDelegate, AnyCoreLocationManager {
    
    /// The CoreLocation manager instance.
    private let locationManager = CLLocationManager()
    
    /// A closure that is called whenever beacons are updated.
    var onBeaconsUpdate: (([CLBeacon]) -> Void)?
    
    /// Initializes the `CoreLocationManager` and sets the delegate.
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    /// Checks if the necessary location permissions have been granted.
    ///
    /// - Returns: `true` if permissions are granted (`authorizedAlways` or `authorizedWhenInUse`), otherwise `false`.
    func arePermissionsGranted() -> Bool {
        let authorizationStatus = locationManager.authorizationStatus
        return authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse
    }
    
    
    /// Requests the necessary location permissions from the user.
    ///
    /// - Parameter always: A boolean indicating whether the app should request "Always" or "When In Use" permissions.
    func requestLocationPermissions(always: Bool = true) {
        if always {
            locationManager.requestAlwaysAuthorization()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    /// Starts ranging beacons that match the provided UUID string.
    ///
    /// - Parameter uuidString: The UUID string of the beacons to range.
    func startRangingBeacons(with uuidString: String) {
        guard let uuid = UUID(uuidString: uuidString) else {
            AppLog.error("Invalid UUID string: \(uuidString)")
            return
        }
        let constraint = CLBeaconIdentityConstraint(uuid: uuid)
        locationManager.startRangingBeacons(satisfying: constraint)
    }
    
    /// Stops ranging beacons that match the provided UUID string.
    ///
    /// - Parameter uuidString: The UUID string of the beacons to stop ranging.
    func stopRangingBeacons(with uuidString: String) {
        guard let uuid = UUID(uuidString: uuidString) else {
            AppLog.error("Invalid UUID string: \(uuidString)")
            return
        }
        let constraint = CLBeaconIdentityConstraint(uuid: uuid)
        locationManager.stopRangingBeacons(satisfying: constraint)
    }
    
    /// Called whenever the `CLLocationManager` receives an update on ranged beacons.
    ///
    /// This method must be internal as it conforms to the `CLLocationManagerDelegate` protocol.
    ///
    /// - Parameters:
    ///   - manager: The location manager sending the update.
    ///   - beacons: An array of `CLBeacon` objects representing the detected beacons.
    ///   - constraint: The constraint that triggered the ranging update.
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying constraint: CLBeaconIdentityConstraint) {
        onBeaconsUpdate?(beacons)
        AppLog.debug("Ranged \(beacons.count) beacons for constraint: \(constraint.uuid)")
    }
}

/// A mock implementation of `AnyCoreLocationManager` for SwiftUI previews and unit tests.
class MockCoreLocationManager: AnyCoreLocationManager {
    
    func requestLocationPermissions(always: Bool) {
        AppLog.debug("MockCoreLocationManager: requestLocationPermissions called")
    }
    
    func arePermissionsGranted() -> Bool {
        return true
    }
    
    func startRangingBeacons(with uuidString: String) {
        AppLog.debug("MockCoreLocationManager: startRangingBeacons called with UUID: \(uuidString)")
    }
    
    func stopRangingBeacons(with uuidString: String) {
        AppLog.debug("MockCoreLocationManager: stopRangingBeacons called with UUID: \(uuidString)")
    }
}
