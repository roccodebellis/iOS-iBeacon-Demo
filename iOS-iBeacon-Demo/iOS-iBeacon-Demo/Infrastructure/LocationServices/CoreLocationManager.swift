//
//  CoreLocationManager.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 06/10/24.
//

import CoreLocation

class CoreLocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager
    var rangedBeacons: [CLBeacon] = []

    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
    }

    func startRangingBeacons(with uuidString: String) {
        guard let uuid = UUID(uuidString: uuidString) else {
            print("Invalid UUID string.")
            return
        }

        let constraint = CLBeaconIdentityConstraint(uuid: uuid)
        locationManager.startRangingBeacons(satisfying: constraint)
    }

    func locationManager(
        _ manager: CLLocationManager,
        didRange beacons: [CLBeacon],
        satisfying beaconConstraint: CLBeaconIdentityConstraint
    ) {
        rangedBeacons = beacons
    }
}
