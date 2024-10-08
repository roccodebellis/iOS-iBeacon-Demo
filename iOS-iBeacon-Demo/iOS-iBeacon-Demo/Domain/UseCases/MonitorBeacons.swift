//
//  MonitorBeacons.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 08/10/24.
//

import Foundation

protocol MonitorBeacons {
    func execute() -> [Beacon]
}

final class MonitorBeaconsImpl: MonitorBeacons {
    private let beaconRepository: BeaconRepository

    init(beaconRepository: BeaconRepository) {
        self.beaconRepository = beaconRepository
    }

    func execute() -> [Beacon] {
        return beaconRepository.getBeacons()
    }
}

class MockMonitorBeacons: MonitorBeacons {
    func execute() -> [Beacon] {
        return [
            Beacon(uuid: UUID(), major: 1, minor: 1, proximity: .near),
            Beacon(uuid: UUID(), major: 2, minor: 2, proximity: .immediate),
            Beacon(uuid: UUID(), major: 3, minor: 3, proximity: .far)
        ]
    }
}
