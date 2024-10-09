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
    
    /// The instance of `ObservableCoreLocationManager` responsible for managing location and beacon-related services.
    private let locationManager: AnyObservableCoreLocationManager
    
    // MARK: - Init
    
    /// Initializes the `AppModule` with an instance of `ObservableCoreLocationManager`.
    ///
    /// - Parameter locationManager: An instance of `ObservableCoreLocationManager`. Defaults to a singleton instance.
    init(
        locationManager: AnyObservableCoreLocationManager = ObservableCoreLocationManager()
    ) {
        self.locationManager = locationManager
    }
    
    // MARK: - Child Modules
    
    /// Returns the `PermissionModule`, passing in the `ObservableCoreLocationManager`.
    ///
    /// - Returns: A configured `PermissionModule` instance.
    var permissionModule: PermissionModule {
        .init(
            moduleCoordinator: self,
            locationManager: locationManager
        )
    }
    
    var beaconVM: BeaconViewModel {
        .init(locationManager: locationManager)
    }
    
    // MARK: - Navigation Properties
    
    /// The currently presented section of the app, determining which screen is shown to the user.
    @Published private(set) var presentedSection: AppSection = .launchScreen
    
    // MARK: - Launch Screen
    
    private var launchScreenTask: Task<Void, Error>?
    private var hasLaunchScreenCompleted: Bool = false
    private var postLaunchScreenSection: AppSection = .permission
    
    // MARK: - Launch Error
    
    /// Represents errors that can occur during the app launch process.
    enum LaunchError: LocalizedError {
        case unknownError
    }
    
    @Published var launchError: LaunchError?
    
    /// Handles the appearance of the launch screen, determining which section to navigate to next based on permissions.
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
    
    /// Handles the completion of the launch screen animation and transitions to the next section.
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
    
    /// Checks if the necessary permissions (e.g., location) have been granted by the user.
        ///
        /// - Returns: `true` if all required permissions are granted, otherwise `false`.
        
    private func checkPermissions() -> Bool {
        return locationManager.arePermissionsGranted()
    }
}

// MARK: - Permission Module Coordinator

extension AppModule: AnyPermissionModuleCoordinator {
    
}
