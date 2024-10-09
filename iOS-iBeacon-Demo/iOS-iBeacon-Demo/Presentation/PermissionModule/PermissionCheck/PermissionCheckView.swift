//
//  PermissionCheckView.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 08/10/24.
//

import SwiftUI

struct PermissionCheckView: View {
    @ObservedObject var viewModel: PermissionCheckViewModel
    
    var body: some View {
        VStack {
            Text("Permissions Required")
                .font(.title)
            Text("Please grant the necessary permissions to continue.")
                .padding()

            Button(action: viewModel.requestLocationPermissions) {
                Text("Grant Location Permissions")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}
