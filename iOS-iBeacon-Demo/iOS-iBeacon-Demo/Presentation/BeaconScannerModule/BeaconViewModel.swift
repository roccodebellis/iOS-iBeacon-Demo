//
//  BeaconViewModel.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 08/10/24.
//

import Combine
import SwiftUI

/// `BeaconViewModel` manages the state and logic for the beacon scanning view, interfacing with the `ObservableCoreLocationManager`.
class BeaconViewModel: ObservableObject {
    
    // MARK: - Properties
    
    /// The instance of `ObservableCoreLocationManager` that handles beacon scanning and location updates.
    private let locationManager: ObservableCoreLocationManager
    
    /// A published property that reflects the list of detected `Beacon` structs.
    @Published var beacons: [Beacon] = []
    
    /// A string representing the UUID for beacon scanning input from the user.
    @Published var inputUUID: String = ""
    
    // MARK: - Initialization
    
    /// Initializes the `BeaconViewModel` with a given `ObservableCoreLocationManager`.
    ///
    /// - Parameter locationManager: An instance of `ObservableCoreLocationManager`. Defaults to a new instance.
    init(locationManager: ObservableCoreLocationManager) {
        self.locationManager = locationManager
        AppLog.info("BeaconViewModel initialized")
        self.setupBeaconMonitoring()
    }
    
    // MARK: - Beacon Monitoring
    
    /// Sets up beacon monitoring by observing the beacons published from `ObservableCoreLocationManager`.
    private func setupBeaconMonitoring() {
        locationManager.$beacons
            .receive(on: DispatchQueue.main)
            .assign(to: &$beacons)
        AppLog.debug("Beacon monitoring set up in BeaconViewModel")
    }
    
    // MARK: - Permissions and Beacon Ranging
    
    /// Requests the necessary location permissions from the user.
    func requestLocationPermissions() {
        AppLog.info("Requesting location permissions")
        locationManager.requestLocationPermissions(always: true)
    }
    
    /// Updates the UUID used for beacon ranging.
    ///
    /// - Parameter uuid: The UUID string entered by the user.
    func updateUUID(_ uuid: String) {
        inputUUID = uuid
        AppLog.info("UUID updated to \(uuid)")
    }

    /// Starts ranging for beacons based on the current `inputUUID`.
    ///
    /// If the UUID string is invalid, a log will indicate the issue.
    func startRangingBeacons() {
        guard !inputUUID.isEmpty else {
            AppLog.warning("Cannot start ranging: UUID is empty")
            return
        }
        AppLog.info("Starting beacon ranging with UUID \(inputUUID)")
        locationManager.startRangingBeacons(with: inputUUID)
    }
    
    /// Stops ranging for beacons based on the current `inputUUID`.
    func stopRangingBeacons() {
        guard !inputUUID.isEmpty else {
            AppLog.warning("Cannot stop ranging: UUID is empty")
            return
        }
        AppLog.info("Stopping beacon ranging with UUID \(inputUUID)")
        locationManager.stopRangingBeacons(with: inputUUID)
    }
}
