//
//  ObservableCoreLocationManager.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 09/10/24.
//

import Combine
import CoreLocation

/// `ObservableCoreLocationManager` is responsible for managing the beacon ranging and location services in an observable, Combine-compatible way.
class ObservableCoreLocationManager: CoreLocationManager, ObservableObject {
    
    /// A published property that holds the currently detected beacons.
    @Published var beacons: [Beacon] = []
    
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
