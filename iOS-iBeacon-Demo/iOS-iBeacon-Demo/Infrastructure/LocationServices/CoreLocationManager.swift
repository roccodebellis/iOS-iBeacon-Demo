//
//  CoreLocationManager.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 06/10/24.
//

import CoreLocation

/// `CoreLocationManager` handles interactions with the CoreLocation framework,
/// including requesting location permissions and ranging for beacons.
class CoreLocationManager: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    /// The `CLLocationManager` instance responsible for managing location services.
    private let locationManager: CLLocationManager
    
    /// Closure that will be called when beacons are updated.
    var onBeaconsUpdate: (([CLBeacon]) -> Void)?
    
    // MARK: - Initialization
    
    /// Initializes the `CoreLocationManager` and sets itself as the delegate.
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
    }
    
    // MARK: - Authorization
    
    /// Checks whether the app has the necessary location permissions.
    ///
    /// - Returns: `true` if the app has `authorizedAlways` or `authorizedWhenInUse` status, `false` otherwise.
    func arePermissionsGranted() -> Bool {
        let status = locationManager.authorizationStatus
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
    
    /// Requests location permissions from the user.
    ///
    /// - Parameter always: Determines whether to request "always" authorization (default is `true`).
    func requestLocationPermissions(always: Bool = true) {
        AppLog.info("Requesting location permissions.")
        if always {
            locationManager.requestAlwaysAuthorization()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: - Beacon Ranging
    
    /// Starts ranging for beacons that match the specified UUID string.
    ///
    /// - Parameter uuidString: The UUID string used to identify the beacon.
    func startRangingBeacons(with uuidString: String) {
        guard let uuid = UUID(uuidString: uuidString.uppercased()) else {
            AppLog.error("Invalid UUID string.")
            return
        }
        
        let constraint = CLBeaconIdentityConstraint(uuid: uuid)
        locationManager.startRangingBeacons(satisfying: constraint)
        AppLog.info("Started ranging beacons with UUID: \(uuidString)")
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    
    /// Handles changes in location authorization status.
    ///
    /// This method is called when the authorization status changes, allowing
    /// the app to handle location access grants or denials.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            AppLog.info("Location access already granted.")
        case .denied, .restricted:
            AppLog.error("Location access denied or restricted.")
        default:
            AppLog.warning("Unknown authorization status.")
        }
    }
    
    /// Handles the detection of beacons within range.
    ///
    /// This method updates the `rangedBeacons` array when beacons are detected.
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying constraint: CLBeaconIdentityConstraint) {
        onBeaconsUpdate?(beacons)
        AppLog.debug("Ranged \(beacons.count) beacons.")
    }
}
