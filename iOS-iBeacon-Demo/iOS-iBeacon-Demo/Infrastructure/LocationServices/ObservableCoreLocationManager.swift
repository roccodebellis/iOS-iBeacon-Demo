//
//  ObservableCoreLocationManager.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 09/10/24.
//

import CoreLocation
import Combine
import SwiftUI

import Combine
import CoreLocation

/// `ObservableCoreLocationManager` provides an observable interface to interact with
/// the `CoreLocationManager`, exposing the state for SwiftUI views to react to changes.
class ObservableCoreLocationManager: ObservableObject {
    
    // MARK: - Properties
    
    /// The instance of `CoreLocationManager` used for handling core location functionality.
    private let coreLocationManager: CoreLocationManager
    
    /// A published property to track the list of `Beacon` structs (mapped from `CLBeacon`).
    @Published var beacons: [Beacon] = []
    
    // MARK: - Initialization
    
    /// Initializes an `ObservableCoreLocationManager` by wrapping an instance of `CoreLocationManager`.
    init(coreLocationManager: CoreLocationManager = CoreLocationManager()) {
        self.coreLocationManager = coreLocationManager
        self.setupBeaconMonitoring()
    }
    
    // MARK: - Setup
    
    /// Sets up the monitoring for beacons, observing changes in `rangedBeacons` from `CoreLocationManager`.
    private func setupBeaconMonitoring() {
        coreLocationManager.onBeaconsUpdate = { [weak self] beacons in
            DispatchQueue.main.async {
                self?.beacons = beacons.map { clBeacon in
                    Beacon(
                        uuid: clBeacon.uuid,
                        major: clBeacon.major.intValue,
                        minor: clBeacon.minor.intValue,
                        proximity: clBeacon.proximity
                    )
                }
            }
        }
    }
    
    // MARK: - Permissions and Beacon Ranging
    
    /// Requests the necessary location permissions.
    ///
    /// This method checks and, if necessary, requests the location permissions required for beacon ranging.
    func requestLocationPermissions(always: Bool = true) {
        coreLocationManager.requestLocationPermissions(always: always)
    }
    
    /// Starts ranging for beacons that match the specified UUID string.
    ///
    /// - Parameter uuidString: The UUID string used to identify the beacons.
    func startRangingBeacons(with uuidString: String) {
        coreLocationManager.startRangingBeacons(with: uuidString)
    }
}
