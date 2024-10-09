//
//  BeaconRepositoryImpl.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 05/10/24.
//

import Foundation

//final class BeaconRepositoryImpl: BeaconRepository {
//    private let locationManager: CoreLocationManager
//
//    init(locationManager: CoreLocationManager) {
//        self.locationManager = locationManager
//    }
//
//    func getBeacons(for uuidString: String) -> [Beacon] {
//        locationManager.startRangingBeacons(with: uuidString)
//        return locationManager.rangedBeacons.map { beacon in
//            return Beacon(
//                uuid: beacon.uuid,
//                major: beacon.major.intValue,
//                minor: beacon.minor.intValue,
//                proximity: beacon.proximity
//            )
//        }
//    }
//}
