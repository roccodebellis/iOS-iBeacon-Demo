//
//  Beacon.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 05/10/24.
//

import Foundation
import CoreLocation

/// A struct representing a simplified beacon with its UUID, major, minor, and proximity.
struct Beacon: Hashable, Sendable {
    let uuid: UUID
    let major: Int
    let minor: Int
    let proximity: CLProximity

    // Conformance to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        hasher.combine(major)
        hasher.combine(minor)
        hasher.combine(proximity)
    }

    // Conformance to Equatable (Hashable implies Equatable)
    static func == (lhs: Beacon, rhs: Beacon) -> Bool {
        return lhs.uuid == rhs.uuid &&
               lhs.major == rhs.major &&
               lhs.minor == rhs.minor &&
               lhs.proximity == rhs.proximity
    }
}
