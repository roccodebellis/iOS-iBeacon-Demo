//
//  AnyCoreLocationManager.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 09/10/24.
//

import CoreLocation
import Combine

/// Protocol that defines the basic functionalities for location management.
protocol AnyCoreLocationManager {
    
    /// Requests location permissions from the user.
    ///
    /// - Parameter always: A boolean indicating whether to request "Always" or "When In Use" permissions.
    func requestLocationPermissions(always: Bool)
    
    /// Checks if the necessary location permissions have been granted.
    ///
    /// - Returns: `true` if permissions are granted, otherwise `false`.
    func arePermissionsGranted() -> Bool
    
    /// Starts ranging beacons with the specified UUID string.
    ///
    /// - Parameter uuidString: The UUID string of the beacons to range.
    func startRangingBeacons(with uuidString: String)
    
    /// Stops ranging beacons with the specified UUID string.
    ///
    /// - Parameter uuidString: The UUID string of the beacons to stop ranging.
    func stopRangingBeacons(with uuidString: String)
}

/// Protocol that extends `AnyCoreLocationManager` and adds Combine-based observability for beacons.
protocol AnyObservableCoreLocationManager: AnyCoreLocationManager {
    
    /// A Combine publisher that emits an array of detected beacons.
    var beaconsPublisher: AnyPublisher<[Beacon], Never> { get }
}
