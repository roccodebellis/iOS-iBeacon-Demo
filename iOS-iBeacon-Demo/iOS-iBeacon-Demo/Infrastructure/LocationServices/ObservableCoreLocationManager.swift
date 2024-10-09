//
//  ObservableCoreLocationManager.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 09/10/24.
//

import Combine
import CoreLocation

/// `ObservableCoreLocationManager` extends `CoreLocationManager` and conforms to `AnyObservableCoreLocationManager`.
class ObservableCoreLocationManager: CoreLocationManager, ObservableObject, AnyObservableCoreLocationManager {
    
    /// The published array of detected beacons.
    @Published private(set) var beacons: [Beacon] = []
    
    /// The Combine publisher that emits updates to the `beacons` array.
    var beaconsPublisher: AnyPublisher<[Beacon], Never> {
        $beacons.eraseToAnyPublisher()
    }
    
    /// Initializes the `ObservableCoreLocationManager` and sets up the beacon monitoring.
    override init() {
        super.init()
        AppLog.info("Initializing ObservableCoreLocationManager")
        
        self.onBeaconsUpdate = { [weak self] clBeacons in
            guard let self = self else {
                AppLog.error("ObservableCoreLocationManager deallocated while updating beacons")
                return
            }
            self.beacons = clBeacons.map { clBeacon in
                Beacon(
                    uuid: clBeacon.uuid,
                    major: clBeacon.major.intValue,
                    minor: clBeacon.minor.intValue,
                    proximity: clBeacon.proximity
                )
            }
            AppLog.debug("Updated beacons: \(self.beacons.count) beacons detected")
        }
    }
}

/// A mock implementation of `AnyObservableCoreLocationManager` for Combine-based reactive behavior.
class MockObservableCoreLocationManager: AnyObservableCoreLocationManager, ObservableObject {
    
    /// The mock list of beacons.
    @Published private var mockBeacons: [Beacon] = []
    
    /// The Combine publisher that emits updates to the `mockBeacons` array.
    var beaconsPublisher: AnyPublisher<[Beacon], Never> {
        $mockBeacons.eraseToAnyPublisher()
    }
    
    /// Requests location permissions (mock implementation).
    ///
    /// - Parameter always: A boolean indicating whether to request "Always" or "When In Use" permissions.
    func requestLocationPermissions(always: Bool) {
        AppLog.debug("MockObservableCoreLocationManager: requestLocationPermissions called")
    }
    
    /// Checks if location permissions have been granted (mock implementation).
    ///
    /// - Returns: `true` to simulate permissions being granted.
    func arePermissionsGranted() -> Bool {
        return true
    }
    
    /// Starts ranging beacons with the specified UUID string (mock implementation).
    ///
    /// - Parameter uuidString: The UUID string of the beacons to range.
    func startRangingBeacons(with uuidString: String) {
        AppLog.debug("MockObservableCoreLocationManager: startRangingBeacons called with UUID: \(uuidString)")
        // Simulate beacons detection.
        mockBeacons = [
            Beacon(uuid: UUID(), major: 100, minor: 1, proximity: .near),
            Beacon(uuid: UUID(), major: 101, minor: 2, proximity: .far)
        ]
    }
    
    /// Stops ranging beacons with the specified UUID string (mock implementation).
    ///
    /// - Parameter uuidString: The UUID string of the beacons to stop ranging.
    func stopRangingBeacons(with uuidString: String) {
        AppLog.debug("MockObservableCoreLocationManager: stopRangingBeacons called with UUID: \(uuidString)")
        // Clear the mock beacons array to simulate stopping ranging.
        mockBeacons = []
    }
}
