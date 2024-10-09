//
//  BeaconViewModel.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 08/10/24.
//

import Combine
import SwiftUI

/// `BeaconViewModel` manages the state and logic for the beacon scanning view.
class BeaconViewModel: ObservableObject {
    
    // MARK: - Properties
    
    /// The instance of `ObservableCoreLocationManager` that handles beacon scanning.
    private let locationManager: ObservableCoreLocationManager
    
    /// A published property that reflects the list of detected `Beacon` structs.
    @Published var beacons: [Beacon] = []
    
    // MARK: - Initialization
    
    /// Initializes the `BeaconViewModel` with an instance of `ObservableCoreLocationManager`.
    ///
    /// - Parameter locationManager: The manager responsible for beacon ranging and location services.
    init(locationManager: ObservableCoreLocationManager = ObservableCoreLocationManager()) {
        self.locationManager = locationManager
        self.bindBeacons()
    }
    
    // MARK: - Binding
    
    /// Binds the beacons from the `ObservableCoreLocationManager` to the `BeaconViewModel`.
    private func bindBeacons() {
        // Subscribe to the published `beacons` property from `ObservableCoreLocationManager`
        locationManager.$beacons
            .receive(on: DispatchQueue.main)
            .assign(to: &$beacons)
    }
    
    // MARK: - Methods
    
    /// Starts ranging beacons with the provided UUID string.
    ///
    /// - Parameter uuidString: The UUID string to start scanning for beacons.
    func startRangingBeacons(with uuidString: String) {
        locationManager.startRangingBeacons(with: uuidString)
    }
    
    /// Requests location permissions from the user.
    ///
    /// - Parameter always: Determines whether to request "always" authorization (default is `true`).
    func requestLocationPermissions(always: Bool = true) {
        locationManager.requestLocationPermissions(always: always)
    }
}
