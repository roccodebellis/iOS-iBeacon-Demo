//
//  CoreLocationManager.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 06/10/24.
//

import Foundation
import CoreLocation

class CoreLocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager
    var rangedBeacons: [CLBeacon] = []

    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startRangingBeacons(
            in: CLBeaconRegion(
                uuid: UUID(uuidString: "YOUR_UUID")!,
                identifier: "MyBeaconRegion"
            )
        )
    }

    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        rangedBeacons = beacons
    }
}
