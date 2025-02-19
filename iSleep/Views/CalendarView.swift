import SwiftUI

struct CalendarView: View {
    @StateObject private var store = SleepSessionStore()
    @State private var selectedDate: Date = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                // Calendar strip
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(-6...0, id: \.self) { offset in
                            let date = calendar.date(byAdding: .day, value: offset, to: Date())!
                            DateButton(date: date,
                                     isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                                     sessions: sessionsForDate(date)) {
                                selectedDate = date
                            }
                        }
                    }
                    .padding()
                }
                
                // Session list for selected date
                if let sessions = store.sessions.filter({
                    calendar.isDate($0.startTime, inSameDayAs: selectedDate)
                }) {
                    List(sessions) { session in
                        NavigationLink(destination: SessionDetailView(session: session)) {
                            SessionRow(session: session)
                        }
                    }
                } else {
                    Text("No sleep sessions recorded")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Sleep Records")
        }
        .onAppear {
            store.fetchLastSevenSessions()
        }
    }
    
    private func sessionsForDate(_ date: Date) -> [SleepSession] {
        store.sessions.filter {
            calendar.isDate($0.startTime, inSameDayAs: date)
        }
    }
}

struct DateButton: View {
    let date: Date
    let isSelected: Bool
    let sessions: [SleepSession]
    let action: () -> Void
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    private let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(weekdayFormatter.string(from: date))
                    .font(.caption)
                Text(dateFormatter.string(from: date))
                    .font(.title2)
                    .bold()
                
                // Session indicators
                HStack(spacing: 2) {
                    ForEach(sessions.prefix(3)) { _ in
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 4, height: 4)
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(isSelected ? Color.blue.opacity(0.2) : Color.clear)
            .cornerRadius(10)
        }
    }
}

struct SessionRow: View {
    let session: SleepSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(session.startTime.formatted(date: .omitted, time: .shortened))
                .font(.headline)
            
            if let endTime = session.endTime {
                Text("Duration: \(formatDuration(from: session.startTime, to: endTime))")
                    .font(.subheadline)
            }
            
            HStack {
                Label("\(session.snoringEvents.count)", systemImage: "waveform")
                Spacer()
                Label("\(Int(averageBreathingRate))", systemImage: "lungs.fill")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    private var averageBreathingRate: Double {
        let rates = session.breathingRecords.map { $0.breathingRate }
        return rates.reduce(0, +) / Double(rates.count)
    }
    
    private func formatDuration(from start: Date, to end: Date) -> String {
        let duration = end.timeIntervalSince(start)
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        return String(format: "%dh %02dm", hours, minutes)
    }
} 