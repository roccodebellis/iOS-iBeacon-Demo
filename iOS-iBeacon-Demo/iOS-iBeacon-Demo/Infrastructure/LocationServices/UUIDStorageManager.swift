//
//  UUIDStorageManager.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 11/10/24.
//

import Foundation

class UUIDStorageManager {
    private let uuidKey = "trackedUUIDs"

    // Store a list of UUIDs in UserDefaults (or replace with CoreData)
    func saveUUIDs(_ uuids: [String]) {
        UserDefaults.standard.set(uuids, forKey: uuidKey)
    }

    // Retrieve the list of tracked UUIDs
    func fetchUUIDs() -> [String] {
        return UserDefaults.standard.stringArray(forKey: uuidKey) ?? []
    }

    // Add a UUID to the list
    func addUUID(_ uuid: String) {
        var currentUUIDs = fetchUUIDs()
        if !currentUUIDs.contains(uuid) {
            currentUUIDs.append(uuid)
            saveUUIDs(currentUUIDs)
        }
    }

    // Remove a UUID from the list
    func removeUUID(_ uuid: String) {
        var currentUUIDs = fetchUUIDs()
        currentUUIDs.removeAll { $0 == uuid }
        saveUUIDs(currentUUIDs)
    }
}
