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
