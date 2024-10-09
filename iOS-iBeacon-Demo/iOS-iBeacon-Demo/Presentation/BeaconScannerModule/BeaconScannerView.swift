//
//  BeaconScannerView.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 05/10/24.
//

import SwiftUI

/// `BeaconScannerView` is responsible for displaying the list of detected beacons.
struct BeaconScannerView: View {
    @ObservedObject var viewModel: BeaconViewModel
    @State private var inputUUID: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter UUID", text: $inputUUID)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: inputUUID) { newUUID in
                    viewModel.updateUUID(newUUID)
                }

            Button(action: {
                viewModel.startRangingBeacons()
            }) {
                Text("Start Ranging")
            }

            List(Array(viewModel.beacons.enumerated()), id: \.offset) { offset, beacon in
                BeaconRow(beacon: beacon)
            }
        }
        .padding()
    }
}

struct BeaconRow: View {
    let beacon: Beacon

    var body: some View {
        VStack(alignment: .leading) {
            Text("UUID: \(beacon.uuid)")
            Text("Major: \(beacon.major), Minor: \(beacon.minor)")
            Text("Proximity: \(beacon.proximity.rawValue)")
        }
    }
}

#Preview {
    BeaconScannerView(viewModel: BeaconViewModel(locationManager: MockObservableCoreLocationManager()))
}
