//
//  AppModuleView.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 08/10/24.
//

import SwiftUI

struct AppModuleView: View {
    @ObservedObject var module: AppModule
    
    var body: some View {
        switch module.presentedSection {
        case .launchScreen:
            LaunchScreenView()
                .onAppear {
                    module.handleLaunchScreenAppear()
                    
                    Task {
                        await module.handleLaunchScreenAnimationCompletion()
                    }
                }
        case .permission:
            PermissionModuleScreen(module: module.permissionModule)
        case .beaconManagement:
            BeaconScannerView(
                viewModel: module.beaconVM
            )
        }
    }
}

struct LaunchScreenView: View {
    var body: some View {
        Text("Launching...")
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}
