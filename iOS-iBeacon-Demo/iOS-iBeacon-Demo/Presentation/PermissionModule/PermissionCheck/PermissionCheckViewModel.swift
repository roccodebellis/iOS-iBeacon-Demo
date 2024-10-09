//
//  PermissionCheckViewModel.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 09/10/24.
//

import Foundation

/// `PermissionCheckViewModel` manages the state and logic for checking the app's permissions.
final class PermissionCheckViewModel: ObservableObject {
    
    /// A reference to the coordinator that manages the permission check view model's flow.
    private weak var coordinator: AnyPermissionCheckVMCoordinator?
    
    /// The `ObservableCoreLocationManager` responsible for managing location permissions.
    private let locationManager: AnyObservableCoreLocationManager
    
    // MARK: - Initialization
    
    /// Initializes the `PermissionCheckViewModel` with the required coordinator and location manager.
    ///
    /// - Parameters:
    ///   - coordinator: The coordinator responsible for navigating after the permission check.
    ///   - locationManager: The `ObservableCoreLocationManager` used for checking and requesting location permissions.
    init(
        coordinator: AnyPermissionCheckVMCoordinator,
        locationManager: AnyObservableCoreLocationManager
    ) {
        self.coordinator = coordinator
        self.locationManager = locationManager
    }
    
    func requestLocationPermissions() {
        locationManager.requestLocationPermissions(always: true)
    }
}
