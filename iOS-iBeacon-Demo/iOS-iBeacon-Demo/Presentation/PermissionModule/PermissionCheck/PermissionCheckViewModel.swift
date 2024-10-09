//
//  PermissionCheckViewModel.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 09/10/24.
//

import Foundation

final class PermissionCheckViewModel: ObservableObject {
    private unowned let coordinator: AnyPermissionCheckVMCoordinator
    
    // MARK: - Services
    private let coreLocationManager: CoreLocationManager
    
    // MARK: - Init
    init(
        coordinator: AnyPermissionCheckVMCoordinator,
        coreLocationManager: CoreLocationManager
    ) {
        self.coordinator = coordinator
        self.coreLocationManager = coreLocationManager
    }
    
    func requestLocationPermissions() {
        coreLocationManager.requestLocationPermissions()
    }
}
