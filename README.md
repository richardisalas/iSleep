# iSleep - Sleep Tracking Apple Watch App

iSleep is an independent watchOS application designed to help users monitor and improve their sleep quality by tracking snoring patterns and breathing during sleep, without requiring a companion iPhone app.

## Features

- 🎤 Real-time snoring detection using the Apple Watch microphone
- 🫁 Breathing pattern analysis throughout the night
- 📳 Optional haptic feedback to help reduce snoring
- ⚙️ Customizable sensitivity settings for snoring detection
- 🔒 Privacy-focused with all processing done on-device
- 📱 Independent watchOS app - no iPhone required

## Technical Architecture

### Core Components
- **AudioRecordingService**: Handles real-time audio processing using AVFoundation
- **SleepSession**: Data model for tracking sleep metrics and events
- **ContentView**: SwiftUI-based user interface with sleep tracking controls

### Key Technologies
- SwiftUI for the user interface
- AVFoundation for audio processing
- WatchKit for device-specific features
- Background audio mode for continuous tracking

## Privacy & Security

iSleep takes your privacy seriously:
- All audio processing is done locally on your Apple Watch
- No audio is recorded or stored
- No data is sent to external servers
- Microphone access is only used during active sleep tracking sessions
- Required permissions are handled directly on the Watch

## Requirements

- watchOS 8.7 or later
- Xcode 14.0 or later
- Apple Watch Series 4 or later (recommended for optimal performance)

## Installation

1. Clone the repository
2. Open iSleep.xcodeproj in Xcode
3. Select your development team in the project settings
4. Build and run on your Apple Watch

## Usage

1. Open the iSleep app on your Apple Watch
2. Tap "Start Sleep Tracking" before going to bed
3. Place your Apple Watch on your wrist and ensure it's properly fitted
4. The app will automatically monitor your sleep patterns
5. To stop tracking, tap "Stop Tracking"

### Settings

- **Haptic Feedback**: Enable/disable gentle haptic notifications when snoring is detected
- **Snoring Sensitivity**: Adjust the threshold for snoring detection

## Future Plans

- [ ] Implement data persistence using CoreData
- [ ] Add detailed sleep analysis views
- [ ] Integrate with HealthKit for comprehensive health tracking
- [ ] Add sleep quality scoring
- [ ] Implement more sophisticated snoring detection algorithms
- [ ] Add CloudKit integration for optional data backup

## License

This project is licensed under the MIT License - see the LICENSE file for details
