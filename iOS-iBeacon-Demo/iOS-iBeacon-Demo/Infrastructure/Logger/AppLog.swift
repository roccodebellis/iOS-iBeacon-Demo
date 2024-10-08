//
//  AppLog.swift
//  iOS-iBeacon-Demo
//
//  Created by r.debellis on 08/10/24.
//

import os
import Foundation

class AppLog {
    static let shared = AppLog()

    // Logger instance from os.log
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "iOS-iBeacon-Demo", category: "AppLifecycle")
    
    // File path for saving logs
    private var logFilePath: URL?

    // Minimum log level (used to filter logs based on environment: debug vs release)
    private var minLogLevel: LogLevel

    private init(minLogLevel: LogLevel = .info) {
        self.minLogLevel = minLogLevel
        setupLogFile()
    }

    private func setupLogFile() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            logFilePath = documentsDirectory.appendingPathComponent("app_log.txt")
        }
    }

    // Method to log messages with different levels
    func log(_ message: String, level: LogLevel, file: String = #file, line: Int = #line, function: String = #function) {
        guard level.rawValue >= minLogLevel.rawValue else { return } // Filter logs based on current minLogLevel
        
        let fileName = (file as NSString).lastPathComponent
        let fullMessage = "[\(level.description)] [\(fileName):\(line) \(function)] - \(message)"
        
        // Log to console
        logger.log("\(fullMessage, privacy: .public)")

        // Write to file if file logging is enabled
        if let logFilePath = logFilePath {
            writeToFile(fullMessage)
        }
    }

    private func writeToFile(_ message: String) {
        guard let logFilePath = logFilePath else { return }
        let logMessage = message + "\n"
        if let fileHandle = try? FileHandle(forWritingTo: logFilePath) {
            fileHandle.seekToEndOfFile()
            if let data = logMessage.data(using: .utf8) {
                fileHandle.write(data)
            }
            fileHandle.closeFile()
        } else {
            // Create the file if it doesn't exist
            try? logMessage.write(to: logFilePath, atomically: true, encoding: .utf8)
        }
    }

    // Method to configure log level (e.g., for debugging or release)
    func configure(minLogLevel: LogLevel) {
        self.minLogLevel = minLogLevel
    }
}

// Define the log levels with a rawValue to ensure ordering
enum LogLevel: Int, CustomStringConvertible {
    case debug = 1
    case info = 2
    case viewCycle = 3
    case warning = 4
    case error = 5

    var description: String {
        switch self {
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .viewCycle: return "VIEW CYCLE"
        case .warning: return "WARNING"
        case .error: return "ERROR"
        }
    }
}
