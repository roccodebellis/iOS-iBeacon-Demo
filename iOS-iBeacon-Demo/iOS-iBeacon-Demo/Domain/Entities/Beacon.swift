//
//  Beacon.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 05/10/24.
//

import Foundation

struct Beacon {
    let uuid: UUID
    let major: Int
    let minor: Int
    let proximity: CLProximity
}
