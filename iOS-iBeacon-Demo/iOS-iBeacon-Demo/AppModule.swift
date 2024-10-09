//
//  AppModule.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 08/10/24.
//

import Foundation

enum AppSection: Equatable {
    case launchScreen
    case permission
    case beaconManagement
}

final class AppModule: ObservableObject {
    // MARK: - Services
    private let coreLocationManager = CoreLocationManager() // TODO: add AnyCoreLocationManager()
    
    // MARK: - Child Modules
    
    var permissionModule: PermissionModule {
        .init(
            moduleCoordinator: self,
            coreLocationManager: coreLocationManager
        )
    }
     
    
    // MARK: - Navigation Properties
    
    @Published private(set) var presentedSection: AppSection = .launchScreen
    
    // MARK: - Launch Screen
    private var launchScreenTask: Task<Void, Error>?
    private var hasLaunchScreenCompleted: Bool = false
    private var postLaunchScreenSection: AppSection = .permission
    
    // MARK: - Launch Error
    enum LaunchError: LocalizedError {
        case unknownError
    }
    
    @Published var launchError: LaunchError?
    
    func handleLaunchScreenAppear() {
        launchScreenTask = Task { @MainActor in
            let permissionsGranted = checkPermissions()
            if permissionsGranted {
                presentedSection = .beaconManagement
            } else {
                presentedSection = .permission
            }
        }
    }
    
    @MainActor
    func handleLaunchScreenAnimationCompletion() async {
        do {
            try await launchScreenTask?.value
        } catch let error as LaunchError {
            launchError = error
        } catch {
            launchError = .unknownError
        }
        
        hasLaunchScreenCompleted = true
        guard launchError == nil else {
            return
        }
    }
    
    // Controlla se i permessi necessari sono stati concessi
    private func checkPermissions() -> Bool {
        // Utilizza il CoreLocationManager per verificare lo stato di autorizzazione
        return coreLocationManager.arePermissionsGranted()
    }
}

// MARK: - Permission Module Coordinator

extension AppModule: AnyPermissionModuleCoordinator {
    
}
