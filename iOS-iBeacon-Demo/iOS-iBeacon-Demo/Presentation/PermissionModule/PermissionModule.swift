//
//  PermissionModule.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 09/10/24.
//

import Foundation

/// `PermissionModule` handles checking and requesting necessary permissions, such as location, for the app to function correctly.
final class PermissionModule: ObservableObject {
    
    /// A weak reference to the module coordinator, which handles app-level coordination.
    private weak var moduleCoordinator: AnyPermissionModuleCoordinator?
    
    // MARK: - Services
    
    /// The `ObservableCoreLocationManager` used for managing location services and permissions.
    private let locationManager: ObservableCoreLocationManager
    
    // MARK: - Initialization
    
    /// Initializes the `PermissionModule` with the required services and coordinator.
    ///
    /// - Parameters:
    ///   - moduleCoordinator: The module coordinator responsible for app-wide coordination.
    ///   - locationManager: The `ObservableCoreLocationManager` instance to manage location-related tasks.
    init(
        moduleCoordinator: AnyPermissionModuleCoordinator,
        locationManager: ObservableCoreLocationManager
    ) {
        self.moduleCoordinator = moduleCoordinator
        self.locationManager = locationManager
    }
    
    // MARK: - ViewModels
    
    /// Creates and returns the `PermissionCheckViewModel`, passing the necessary services.
    ///
    /// - Returns: A configured `PermissionCheckViewModel` instance.
    var permissionCheckViewModel: PermissionCheckViewModel {
        .init(
            coordinator: self,
            locationManager: locationManager
        )
    }
    
    // MARK: - Navigation Properties
    // Any additional navigation properties can be added here.
    
}

// MARK: - PermissionCheck

/// Extension to conform to the `AnyPermissionCheckVMCoordinator` protocol.
extension PermissionModule: AnyPermissionCheckVMCoordinator {
    
}
