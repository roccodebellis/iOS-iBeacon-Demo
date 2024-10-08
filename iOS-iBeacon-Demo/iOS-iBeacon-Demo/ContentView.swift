//
//  ContentView.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 05/10/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: BeaconViewModel

    var body: some View {
        List(viewModel.beacons, id: \.uuid) { beacon in
            VStack(alignment: .leading) {
                Text("UUID: \(beacon.uuid)")
                Text("Major: \(beacon.major), Minor: \(beacon.minor)")
                Text("Proximity: \(beacon.proximity.rawValue)")
            }
        }
        .onAppear {
            viewModel.fetchBeacons()
        }
    }
}

#Preview {
    ContentView(viewModel: MockBeaconViewModel())
}
