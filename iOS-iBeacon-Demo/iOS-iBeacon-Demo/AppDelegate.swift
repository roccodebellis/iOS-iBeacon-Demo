//
//  AppDelegate.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 09/10/24.
//

import UIKit
import SwiftUI
import CoreLocation
import BackgroundTasks
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate {
    static var dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .short
      formatter.timeStyle = .long
      return formatter
    }()

    var window: UIWindow?
    
    // MARK: CLLocationManagerDelegate
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        BGTaskScheduler.shared.register(
          forTaskWithIdentifier: AppConstants.backgroundTaskIdentifier,
          using: nil) { task in
            self.refresh()
            task.setTaskCompleted(success: true)
            self.scheduleAppRefresh()
        }

        scheduleAppRefresh()
        
        // Log app launch status
        requestNotificationPermission()
        AppLog.info("Application did finish launching.")
        return true
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                AppLog.error("Notification permission request failed: \(error)")
            }
            if granted {
                AppLog.info("Notification permission granted.")
            } else {
                AppLog.warning("Notification permission denied.")
            }
        }
    }
    
    func scheduleAppRefresh() {
      let request = BGAppRefreshTaskRequest(identifier: AppConstants.backgroundTaskIdentifier)
      request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60)
      do {
        try BGTaskScheduler.shared.submit(request)
        AppLog.info("background refresh scheduled")
      } catch {
        AppLog.info("Couldn't schedule app refresh \(error.localizedDescription)")
      }
    }

    func refresh() {
      // to simulate a refresh, just update the last refresh date to current date/time
      let formattedDate = Self.dateFormatter.string(from: Date())
      UserDefaults.standard.set(formattedDate, forKey: UserDefaultsKeys.lastRefreshDateKey)
    AppLog.info("refresh occurred")
    }
}
