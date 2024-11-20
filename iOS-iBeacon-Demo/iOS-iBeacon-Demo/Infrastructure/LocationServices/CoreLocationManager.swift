//
//  CoreLocationManager.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 06/10/24.
//

import CoreLocation
import UserNotifications

/// `CoreLocationManager` handles CoreLocation-related tasks and conforms to `AnyCoreLocationManager`.
class CoreLocationManager: NSObject, CLLocationManagerDelegate, AnyCoreLocationManager {
    
    /// The CoreLocation manager instance.
    private let locationManager = CLLocationManager()
    
//    private let uuidStorageManager = UUIDStorageManager()
    
    /// A closure that is called whenever beacons are updated.
    var onBeaconsUpdate: (([CLBeacon]) -> Void)?
    
    /// Initializes the `CoreLocationManager` and sets the delegate.
    override init() {
        super.init()
        locationManager.delegate = self
        // Load and monitor stored UUIDs on init
//           let trackedUUIDs = uuidStorageManager.fetchUUIDs()
//           trackedUUIDs.forEach { startRangingBeacons(with: $0) }
    }
    
    /// Checks if the necessary location permissions have been granted.
    ///
    /// - Returns: `true` if permissions are granted (`authorizedAlways` or `authorizedWhenInUse`), otherwise `false`.
    func arePermissionsGranted() -> Bool {
        let authorizationStatus = locationManager.authorizationStatus
        return authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse
    }
    
    
    /// Requests the necessary location permissions from the user.
    ///
    /// - Parameter always: A boolean indicating whether the app should request "Always" or "When In Use" permissions.
    func requestLocationPermissions(always: Bool = true) {
        if always {
            locationManager.requestAlwaysAuthorization()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    /// Starts ranging beacons that match the provided UUID string.
    ///
    /// - Parameter uuidString: The UUID string of the beacons to range.
    func startRangingBeacons(with uuidString: String) {
        guard let uuid = UUID(uuidString: uuidString) else {
            AppLog.error("Invalid UUID string: \(uuidString)")
            return
        }
//        let constraint = CLBeaconIdentityConstraint(uuid: uuid)
//        locationManager.startRangingBeacons(satisfying: constraint)
        let region = CLBeaconRegion(uuid: uuid, identifier: "MonitoredBeacon")
        region.notifyEntryStateOnDisplay = true
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        locationManager.startMonitoring(for: region)
//        monitoredBeacons.append(region)
        AppLog.info("Started monitoring beacons with UUID: \(uuidString)")
    }
    
    // CLLocationManagerDelegate - Rilevamento dell'ingresso in un'area di un beacon
     func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
         if let beaconRegion = region as? CLBeaconRegion {
             AppLog.info("Entered beacon region with UUID: \(beaconRegion.uuid.uuidString)")
             sendLocalNotification(title: "Beacon Entered", body: "UUID: \(beaconRegion.uuid.uuidString)")
         }
     }
    // CLLocationManagerDelegate - Uscita da un'area di un beacon
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            AppLog.info("Exited beacon region with UUID: \(beaconRegion.uuid.uuidString)")
            sendLocalNotification(title: "Beacon Exited", body: "UUID: \(beaconRegion.uuid.uuidString)")
        }
    }
    
    func startMonitoringMultipleUUIDs(_ uuids: [String]) {
        uuids.forEach { startRangingBeacons(with: $0) }
    }
    
    // Invia una notifica locale
    private func sendLocalNotification(for beacon: CLBeacon) {
        let content = UNMutableNotificationContent()
        content.title = "Beacon Detected"
        content.body = "UUID: \(beacon.uuid.uuidString), Major: \(beacon.major), Minor: \(beacon.minor)"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                AppLog.error("Failed to schedule local notification: \(error)")
            } else {
                AppLog.info("Local notification scheduled for beacon \(beacon.uuid.uuidString)")
            }
        }
    }
    
    // Invia una notifica locale
      private func sendLocalNotification(title: String, body: String) {
          let content = UNMutableNotificationContent()
          content.title = title
          content.body = body
          content.sound = .default

          let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
          UNUserNotificationCenter.current().add(request) { error in
              if let error = error {
                  AppLog.error("Failed to send notification: \(error.localizedDescription)")
              } else {
                  AppLog.info("Notification sent: \(title)")
              }
          }
      }
    
    /// Stops ranging beacons that match the provided UUID string.
    ///
    /// - Parameter uuidString: The UUID string of the beacons to stop ranging.
    func stopRangingBeacons(with uuidString: String) {
        guard let uuid = UUID(uuidString: uuidString) else {
            AppLog.error("Invalid UUID string: \(uuidString)")
            return
        }
        let constraint = CLBeaconIdentityConstraint(uuid: uuid)
        locationManager.stopRangingBeacons(satisfying: constraint)
    }
    
    func stopMonitoringMultipleUUIDs(_ uuids: [String]) {
        uuids.forEach { stopRangingBeacons(with: $0) }
    }
    
    /// Called whenever the `CLLocationManager` receives an update on ranged beacons.
    ///
    /// This method must be internal as it conforms to the `CLLocationManagerDelegate` protocol.
    ///
    /// - Parameters:
    ///   - manager: The location manager sending the update.
    ///   - beacons: An array of `CLBeacon` objects representing the detected beacons.
    ///   - constraint: The constraint that triggered the ranging update.
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying constraint: CLBeaconIdentityConstraint) {
        onBeaconsUpdate?(beacons)
        AppLog.debug("Ranged \(beacons.count) beacons for constraint: \(constraint.uuid)")
        
        for beacon in beacons {
            // Verifica se il beacon è uno dei beacon salvati e invia una notifica
            sendLocalNotification(for: beacon)
            
        }
    }
}

/// A mock implementation of `AnyCoreLocationManager` for SwiftUI previews and unit tests.
class MockCoreLocationManager: AnyCoreLocationManager {
    
    func requestLocationPermissions(always: Bool) {
        AppLog.debug("MockCoreLocationManager: requestLocationPermissions called")
    }
    
    func arePermissionsGranted() -> Bool {
        return true
    }
    
    func startRangingBeacons(with uuidString: String) {
        AppLog.debug("MockCoreLocationManager: startRangingBeacons called with UUID: \(uuidString)")
    }
    
    func stopRangingBeacons(with uuidString: String) {
        AppLog.debug("MockCoreLocationManager: stopRangingBeacons called with UUID: \(uuidString)")
    }
}
