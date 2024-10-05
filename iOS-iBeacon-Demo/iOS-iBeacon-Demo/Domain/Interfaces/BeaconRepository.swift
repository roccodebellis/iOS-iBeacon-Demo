//
//  BeaconRepository.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 05/10/24.
//

import Foundation

protocol BeaconRepository {
    func getBeacons() -> [Beacon]
}
