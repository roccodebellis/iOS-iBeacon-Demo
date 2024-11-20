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
    
    var body: some View {
        VStack {
            HStack {
                TextField(
                    "Enter UUID",
                    text: $viewModel.inputUUID
                )
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

                if !viewModel.inputUUID.isEmpty {
                    Button(action: {
                        viewModel.inputUUID = "" // Cancella il contenuto
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 8)
                }
            }

            Button(action: {
                viewModel.addUUIDToMonitor()
            }) {
                Text("Start Ranging")
            }
            //.disabled(!viewModel.isUUIDValid)
            
            List(viewModel.uuids, id: \.self) { uuid in
                HStack {
                    Text(uuid)
                    Spacer()
                    Button(action: {
                        viewModel.removeUUIDFromMonitor(uuid)
                    }) {
                        Text("Remove").foregroundColor(.red)
                    }
                }
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
