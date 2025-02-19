import SwiftUI
import Charts

struct SleepCalendarView: View {
    @StateObject private var store = SleepSessionStore()
    @State private var selectedSession: SleepSession?
    
    var body: some View {
        NavigationView {
            List(store.sessions) { session in
                SleepSessionRow(session: session)
                    .onTapGesture {
                        selectedSession = session
                    }
            }
            .navigationTitle("Sleep Sessions")
            .sheet(item: $selectedSession) { session in
                SessionDetailView(session: session)
            }
        }
        .onAppear {
            store.fetchLastSevenSessions()
        }
    }
}

struct SleepSessionRow: View {
    let session: SleepSession
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(session.startTime.formatted(date: .abbreviated, time: .shortened))
                .font(.headline)
            
            if let endTime = session.endTime {
                Text("Duration: \(formatDuration(from: session.startTime, to: endTime))")
                    .font(.subheadline)
            }
            
            Text("\(session.snoringEvents.count) snoring events")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
    
    private func formatDuration(from start: Date, to end: Date) -> String {
        let duration = end.timeIntervalSince(start)
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        return String(format: "%dh %02dm", hours, minutes)
    }
} 