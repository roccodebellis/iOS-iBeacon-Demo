//
//  iOS_iBeacon_DemoApp.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 05/10/24.
//

import SwiftUI

@main
struct iOS_iBeacon_DemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    @Environment(\.scenePhase) private var scenePhase: ScenePhase
    
    @StateObject private var appModule: AppModule = .init()
    
    @State private var appWasInBackground: Bool = true
    
    var body: some Scene {
        WindowGroup {
            AppModuleView(module: appModule)
                .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .active:
                        AppLog.shared.log("App became active", level: .viewCycle)
                        if appWasInBackground {
                            AppLog.shared.log("App transitioning from background to active", level: .viewCycle)
                            appWasInBackground = false
                        }
                    case .inactive:
                        AppLog.shared.log("App became inactive", level: .viewCycle)
                    case .background:
                        AppLog.shared.log("App entered background", level: .viewCycle)
                        appWasInBackground = true
                    @unknown default:
                        AppLog.shared.log("Unknown app state", level: .warning)
                    }
                }
        }
    }
}
