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

class MockBeaconViewModel: BeaconViewModel {
    override init(monitorBeacons: MonitorBeacons = MockMonitorBeacons()) {
        super.init(monitorBeacons: monitorBeacons)
        // Sovrascriviamo fetchBeacons per evitare di eseguire logica reale durante la preview
        self.beacons = [
            Beacon(uuid: UUID(), major: 1, minor: 1, proximity: .near),
            Beacon(uuid: UUID(), major: 2, minor: 2, proximity: .immediate),
            Beacon(uuid: UUID(), major: 3, minor: 3, proximity: .far)
        ]
    }

    override func fetchBeacons() {
        // Mocking data, non fare nulla
    }
}
