//
//  ContentView.swift
//  iSleep Watch App
//
//  Created by Richard Salas on 2025-02-18.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var audioService = AudioRecordingService()
    @State private var isTracking = false
    @State private var currentSession: SleepSession?
    @State private var showSettings = false
    
    // Settings
    @AppStorage("hapticFeedbackEnabled") private var hapticFeedbackEnabled = false
    @AppStorage("snoringThreshold") private var snoringThreshold = 0.5
    
    var body: some View {
        NavigationView {
            VStack {
                if isTracking {
                    // Sleep tracking view
                    VStack {
                        Text("Sleep Tracking Active")
                            .font(.headline)
                        
                        if let startTime = currentSession?.startTime {
                            Text("Started: \(startTime, style: .time)")
                                .font(.subheadline)
                        }
                        
                        Button(action: stopTracking) {
                            Text("Stop Tracking")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    // Start tracking view
                    Button(action: startTracking) {
                        Text("Start Sleep Tracking")
                    }
                    .buttonStyle(.bordered)
                }
                
                Button(action: { showSettings.toggle() }) {
                    Image(systemName: "gear")
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(
                    hapticFeedbackEnabled: $hapticFeedbackEnabled,
                    snoringThreshold: $snoringThreshold
                )
            }
        }
        .onAppear {
            setupAudioService()
        }
    }
    
    private func setupAudioService() {
        audioService.onSnoringDetected = { intensity in
            if hapticFeedbackEnabled && intensity > snoringThreshold {
                WKInterfaceDevice.current().play(.notification)
            }
        }
    }
    
    private func startTracking() {
        currentSession = SleepSession()
        audioService.startRecording()
        isTracking = true
    }
    
    private func stopTracking() {
        audioService.stopRecording()
        isTracking = false
        // Save session data
    }
}

struct SettingsView: View {
    @Binding var hapticFeedbackEnabled: Bool
    @Binding var snoringThreshold: Double
    
    var body: some View {
        Form {
            Toggle("Haptic Feedback", isOn: $hapticFeedbackEnabled)
            
            VStack(alignment: .leading) {
                Text("Snoring Sensitivity")
                Slider(value: $snoringThreshold, in: 0...1) {
                    Text("Threshold")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
