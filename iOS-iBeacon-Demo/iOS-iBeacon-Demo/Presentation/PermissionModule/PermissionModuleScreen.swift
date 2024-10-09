//
//  PermissionModuleScreen.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 09/10/24.
//

import SwiftUI

struct PermissionModuleScreen: View {
    @ObservedObject var module: PermissionModule
    
    var body: some View {
        PermissionCheckView(viewModel: module.permissionCheckViewModel)
    }
}
