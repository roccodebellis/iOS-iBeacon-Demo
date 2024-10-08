//
//  ContentView.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 05/10/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: BeaconViewModel
    @State private var inputUUID: String = ""

    var body: some View {
        VStack {
            TextField("Enter UUID", text: $inputUUID)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                viewModel.startRangingWithUUID(uuidString: inputUUID)
            }) {
                Text("Start Ranging")
            }

            List(viewModel.beacons, id: \.uuid) { beacon in
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
//    ContentView(viewModel: MockBeaconViewModel())
//}
