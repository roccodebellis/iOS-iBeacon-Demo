
# iOS Beacon Documentation

## Overview

This document provides an overview of the usage of iBeacons in iOS apps, including limitations encountered during development, as well as background execution constraints.

### iBeacon Overview

iBeacons are Bluetooth Low Energy (BLE) devices that broadcast their presence to nearby iOS devices. The iOS device can monitor for the proximity of these iBeacons using the CoreLocation framework.

### Core Frameworks:
- **CoreLocation**: Used for monitoring and ranging iBeacons in foreground and background modes.
- **CoreBluetooth**: Used for general Bluetooth communication (i.e., non-iBeacon devices), but restricted in background mode for beacon detection.

## Implementation

### Starting Beacon Ranging
To range for beacons, you can use `CLLocationManager` to detect beacons and get proximity updates.

```swift
let constraint = CLBeaconIdentityConstraint(uuid: uuid)
locationManager.startRangingBeacons(satisfying: constraint)
```

## Background Execution

### Limitations:

- *Short background execution time*: When an iOS app is sent to the background, it can only run for a few seconds (30 seconds to 3 minutes depending on the case). After this period, beacon ranging stops unless specific steps are taken【13†source】.
- *Beacon ranging timeout*: Ranging for beacons in the background is subject to a 10-minute limit by iOS, after which the app will stop scanning for beacons unless it is brought to the foreground【14†source】.
  
### Extending Background Time:

To extend background execution time, you can use a combination of CoreLocation and background tasks:

1. **Enable Location Background Mode**:
In your Info.plist, add the location mode to UIBackgroundModes to allow the app to run location services in the background.

```xml
<key>UIBackgroundModes</key>
<array>
    <string>location</string>
</array>
```

2. **Request Always Authorization for Location**:
Request the NSLocationAlwaysUsageDescription permission to ensure your app can access location data at all times.

3. **Start Major Location Updates**:
Even if you don’t need precise location data, starting location updates ensures the app stays alive in the background:

```swift
locationManager.startUpdatingLocation()
```

4. **Start a Background Task**:
Use a background task to extend the life of your app when entering the background.

```swift
var backgroundTask: UIBackgroundTaskIdentifier = .invalid
backgroundTask = UIApplication.shared.beginBackgroundTask {
    UIApplication.shared.endBackgroundTask(backgroundTask)
    backgroundTask = .invalid
}
```

5. **Keep the Location Manager in the App Delegate**:
To ensure continuous background execution, the `CLLocationManager` should be managed in the App Delegate rather than in a view controller.

```swift
locationManager.allowsBackgroundLocationUpdates = true
locationManager.pausesLocationUpdatesAutomatically = false
```

### Battery Drain

Running beacon scanning in the background will cause significant battery drain, especially if scanning frequently (e.g., every 15 seconds) over long periods (1-2 hours).

### User Experience Considerations

- **App Store Approval**: To be approved by Apple, your app must provide a location-specific benefit that is obvious to the user, otherwise, Apple may reject the app for using location services unnecessarily.
- **Location Permissions**: iOS will periodically present a dialog to users (every 3 days) warning them that the app is using location in the background. This may discourage users from keeping the app running in the background.

## Limitations and Challenges

1. **Beacon Detection in Background**: After approximately 10 minutes of background execution, beacon detection and ranging will stop【14†source】【13†source】. This can be mitigated by:
    - Using CoreLocation with background location updates.
    - Starting significant location changes to keep the app alive.

2. **Battery Consumption**: Continuous ranging and location updates in the background will significantly reduce the battery life of the user’s device.

## Additional Information: iBeacons and Background Modes

### Forum Discussion Summary
In a discussion on the [Apple Developer Forum](https://forums.developer.apple.com/forums/thread/100550), a developer shared their experience of creating an app that needs to work in foreground, background, and even after being deliberately killed by the user. Their main goal was to monitor iBeacons and react to Bluetooth events such as the switching on/off of Bluetooth, and region enter/exit events.

#### Key points from the discussion:
1.	App Functionality: The app needed to work in all states (foreground, background, and after being killed), monitor a potentially unlimited number of iBeacon regions using the same UUID, and handle Bluetooth events.
2.	Challenges and Solutions:
    - To overcome the limitation of monitoring only 20 iBeacon regions, the developer decided not to specify minor and major values, and instead used ranging to retrieve them.
	- After adding location and bluetooth-central background modes, the app was able to monitor regions and handle Bluetooth switch events, even after being closed by the user.
3.	Concerns About Apple’s Guidelines:
    - The developer asked if using these background modes would violate Apple’s guidelines. An Apple engineer responded that according to the [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/), background modes can only be used for their intended purposes (e.g., location, task completion, VoIP, etc.). The engineer mentioned that App Review would make the final decision based on the justifications provided by the developer.
4.	Intermittent Issues:
    - Another developer commented that sometimes their app did not wake up reliably when an iBeacon came into range, while it worked fine for most users. This issue was intermittent, and the exact cause was unclear.
    
## iOS 17 and Beacon Region Monitoring: Known Issues

While transitioning to iOS 17 and the new `CLMonitor.BeaconIdentityCondition` for beacon monitoring, there are some known issues with background region monitoring.

### Background on Region Monitoring with `startMonitoring(for: region)`:
The `startMonitoring(for: region)` API is still valid in iOS 17. It is designed to work in the background as long as the app has **Always Allow** location permissions. However, developers have reported increased failures with this API since iOS 17. Specifically, apps may not always wake up when a beacon region is entered or exited, particularly after the app has been running for several hours in the background.

### iOS 17's Optimization and Suspended State:
It appears that iOS optimizations for battery life may be suspending apps after a period of inactivity. These optimizations mean that region entry/exit events may not always trigger as expected. While some apps resume functionality when CoreLocation is engaged by other apps or when users manually open the app, relying on this behavior undermines the reliability of background beacon monitoring.

### Using `CLMonitor.BeaconIdentityCondition`:
As of iOS 17, developers can use the new `CLMonitor.BeaconIdentityCondition` for beacon monitoring. This API provides event-based monitoring and includes states like:
- `CLMonitoringStateSatisfied`: Indicates that the beacon is in range.
- `CLMonitoringStateUnsatisfied`: Indicates that the beacon is no longer in range.
- `CLMonitoringStateUnknown`: The state of the beacon is not currently known.

The transition between these states can serve as a replacement for the traditional entry/exit events, but reliability concerns similar to those seen with `startMonitoring(for: region)` remain.

### Suggested Solutions:
- Ensure that your app has **Always Allow** location permission and background location updates enabled.
- Consider combining `CLMonitor.BeaconIdentityCondition` with more frequent location updates to ensure your app stays active.
- Monitor for a state transition from `Satisfied` to `Unsatisfied` to detect when the user exits a beacon region.

For more information, check the discussion on StackOverflow: [StackOverflow Post on iOS 17 Beacon Monitoring](https://stackoverflow.com/questions/78439506/2024-beacon-app-startmonitoringfor-region-or).

#### Conclusion:

The use of background modes to monitor iBeacons and handle Bluetooth events can work, but developers must ensure that the use of these modes is justified according to Apple’s guidelines. Additionally, developers should be prepared to handle possible intermittent issues related to beacon detection in the background.

## Sources
- [Apple CoreLocation Documentation](https://developer.apple.com/documentation/corelocation)
- [AltBeacon iOS Beacon Tools](https://github.com/AltBeacon/ios-beacon-tools)
- [StackOverflow Discussion on Background Scanning](https://stackoverflow.com/questions/59784388/ios-extending-background-time-for-beacon-monitoring)
- [StackOverflow Beacon Ranging Timeout](https://stackoverflow.com/questions/35243224/beacon-ranging-in-the-background-on-ios)

