//
//  CoreLocationManager.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 06/10/24.
//

import CoreLocation

/// `CoreLocationManager` handles CoreLocation tasks such as requesting location permissions and ranging iBeacons.
///
/// This class is responsible for managing the location services and beacon ranging, using Apple's modern API introduced in iOS 13.0.
class CoreLocationManager: NSObject, CLLocationManagerDelegate {
    
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
    /// - Returns: `true` if permissions are granted; otherwise, `false`.
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
    
    /// Starts ranging beacons that match the given UUID string.
    ///
    /// This function uses `CLBeaconIdentityConstraint` to specify the beacons to monitor.
    ///
    /// - Parameter uuidString: A string representation of the UUID used to identify the beacons to range.
    func startRangingBeacons(with uuidString: String) {
        guard let uuid = UUID(uuidString: uuidString) else {
            AppLog.error("Invalid UUID string: \(uuidString)")
            return
        }
        let constraint = CLBeaconIdentityConstraint(uuid: uuid)
        locationManager.startRangingBeacons(satisfying: constraint)
    }
    
    /// Stops ranging beacons that match the given UUID string.
    ///
    /// This function uses `CLBeaconIdentityConstraint` to stop monitoring specific beacons.
    ///
    /// - Parameter uuidString: A string representation of the UUID used to identify the beacons to stop ranging.
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
