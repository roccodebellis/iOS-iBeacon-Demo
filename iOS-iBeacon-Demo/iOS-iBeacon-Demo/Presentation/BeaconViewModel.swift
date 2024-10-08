//
//  BeaconViewModel.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 08/10/24.
//

import SwiftUI
import Combine

class BeaconViewModel: ObservableObject {
    private let monitorBeacons: MonitorBeacons
    @Published var beacons: [Beacon] = []

    init(monitorBeacons: MonitorBeacons) {
        self.monitorBeacons = monitorBeacons
        fetchBeacons()
    }

    func fetchBeacons() {
        self.beacons = monitorBeacons.execute()
    }
}
