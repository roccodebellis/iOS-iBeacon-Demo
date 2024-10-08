//
//  BeaconViewModel.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 08/10/24.
//

import SwiftUI
import Combine

class BeaconViewModel: ObservableObject {
    private let locationManager: CoreLocationManager
    @Published var beacons: [Beacon] = []

    init(locationManager: CoreLocationManager) {
        self.locationManager = locationManager
    }

    func startRangingWithUUID(uuidString: String) {
        locationManager.startRangingBeacons(with: uuidString)
        self.beacons = locationManager.rangedBeacons.map { clBeacon in
            Beacon(
                uuid: clBeacon.uuid,
                major: clBeacon.major.intValue,
                minor: clBeacon.minor.intValue,
                proximity: clBeacon.proximity
            )
        }
    }
}
