//
//  BeaconScannerView.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 05/10/24.
//

import SwiftUI

/// `BeaconScannerView` is responsible for displaying the list of detected beacons.
/// It provides a user interface for starting beacon ranging and displaying relevant data.
struct BeaconScannerView: View {
    @ObservedObject var viewModel: BeaconViewModel
    @State private var inputUUID: String = ""

    var body: some View {
        VStack {
            TextField("Enter UUID", text: $inputUUID)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                // Start ranging with a fixed UUID for testing
                viewModel.startRangingBeacons(with: inputUUID)
            }) {
                Text("Start Ranging")
            }
            
            List(viewModel.beacons, id: \.self) { beacon in
                VStack(alignment: .leading) {
                    Text("UUID: \(beacon.uuid)")
                    Text("Major: \(beacon.major), Minor: \(beacon.minor)")
                    Text("Proximity: \(beacon.proximity.rawValue)")
                }
            }
        }
        .padding()
    }
}

//#Preview {
//    BeaconScannerView(viewModel: BeaconViewModel(monitorBeacons: MockMonitorBeacons()))
//}
