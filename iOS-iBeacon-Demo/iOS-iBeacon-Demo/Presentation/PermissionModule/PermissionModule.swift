//
//  PermissionModule.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 09/10/24.
//

import Foundation

final class PermissionModule: ObservableObject {
    private weak var moduleCoordinator: AnyPermissionModuleCoordinator?
    
    // MARK: - Services
    private let coreLocationManager: CoreLocationManager
    
    // MARK: - Init
    
    init(
        moduleCoordinator: AnyPermissionModuleCoordinator,
        coreLocationManager: CoreLocationManager
    ) {
        self.moduleCoordinator = moduleCoordinator
        self.coreLocationManager = coreLocationManager
    }
    
    // MARK: - ViewModels
    var permissionCheckViewModel: PermissionCheckViewModel {
        .init(
            coordinator: self,
            coreLocationManager: coreLocationManager
        )
    }
    
    // MARK: - Navigation Properties
    
    
}

// MARK: - PermissionCheck

extension PermissionModule: AnyPermissionCheckVMCoordinator {
    
}
