
# iOS iBeacon Demo

This iOS app demonstrates how to use iBeacons with CoreLocation on iOS devices, focusing on monitoring and ranging beacons.

## Overview

iBeacons are devices that transmit Bluetooth signals. With CoreLocation, this app detects the proximity of iBeacons and provides actions based on their distance. This demo app serves as a foundation for developers looking to integrate iBeacons into their apps.

## Features

- **Beacon Monitoring**: Detects the presence of iBeacons within a defined region.
- **Beacon Ranging**: Measures the proximity to detected beacons.

## Requirements

- iOS 16.0 or later
- Xcode 11.2 or later
- A device with Bluetooth Low Energy (BLE) support

## Getting Started

### Clone the repository:

```bash
git clone https://github.com/YourUsername/iOS-iBeacon-Demo.git
cd iOS-iBeacon-Demo
```

### Running the App

1. Open the project in Xcode.
2. Ensure you have added the correct UUID, Major, and Minor values for the iBeacons in `CoreLocationManager.swift`.
3. Build and run the app on a real device with Bluetooth capabilities.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
