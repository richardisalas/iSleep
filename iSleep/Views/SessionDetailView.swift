import SwiftUI
import Charts
import AVFoundation

struct SessionDetailView: View {
    let session: SleepSession
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Breathing Rate Chart
                ChartSection(title: "Breathing Rate") {
                    Chart(session.breathingRecords) { record in
                        LineMark(
                            x: .value("Time", record.timestamp),
                            y: .value("Rate", record.breathingRate)
                        )
                    }
                    .frame(height: 200)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .hour)) { value in
                            AxisGridLine()
                            AxisValueLabel(format: .dateTime.hour())
                        }
                    }
                }
                
                // Snoring Events
                ChartSection(title: "Snoring Events") {
                    ForEach(session.snoringEvents.sorted(by: { $0.timestamp < $1.timestamp })) { event in
                        SnoringEventRow(event: event)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Session Details")
    }
}

struct ChartSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            content
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct SnoringEventRow: View {
    let event: SleepSession.SnoringEvent
    @State private var isPlaying = false
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(event.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.subheadline)
                Text("Duration: \(Int(event.duration))s")
                    .font(.caption)
            }
            
            Spacer()
            
            // Intensity indicator
            CircularProgressView(progress: event.intensity)
                .frame(width: 40, height: 40)
            
            Button(action: togglePlayback) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .disabled(audioPlayer == nil)
        }
        .padding(.vertical, 4)
        .onAppear(perform: loadAudio)
    }
    
    private func loadAudio() {
        do {
            let audioData = try AudioManager.shared.loadSnoreAudio(for: event.id)
            audioPlayer = try AVAudioPlayer(data: audioData)
        } catch {
            print("Failed to load audio: \(error)")
        }
    }
    
    private func togglePlayback() {
        if isPlaying {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
        }
        isPlaying.toggle()
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 4)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(progressColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
    
    private var progressColor: Color {
        switch progress {
        case 0..<0.4: return .green
        case 0.4..<0.7: return .yellow
        default: return .red
        }
    }
} 