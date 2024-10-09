//
//  MonitorBeacons.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 08/10/24.
//

import Foundation

protocol MonitorBeacons {
    func execute(uuidString: String) -> [Beacon]
}

final class MonitorBeaconsImpl: MonitorBeacons {
    private let beaconRepository: BeaconRepository

    init(beaconRepository: BeaconRepository) {
        self.beaconRepository = beaconRepository
    }

    func execute(uuidString: String) -> [Beacon] {
        // Qui chiameremo il repository per gestire il monitoraggio e restituire i beacon
        return beaconRepository.getBeacons(for: uuidString)
    }
}

class MockMonitorBeacons: MonitorBeacons {
    func execute(uuidString: String) -> [Beacon] {
        // Returns a simulated array of beacons for testing, using the provided UUID
        return [
            Beacon(uuid: UUID(uuidString: uuidString) ?? UUID(), major: 1, minor: 1, proximity: .near),
            Beacon(uuid: UUID(uuidString: uuidString) ?? UUID(), major: 2, minor: 2, proximity: .immediate),
            Beacon(uuid: UUID(uuidString: uuidString) ?? UUID(), major: 3, minor: 3, proximity: .far)
        ]
    }
}
