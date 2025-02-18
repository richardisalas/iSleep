import Foundation

struct SleepSession: Identifiable, Codable {
    let id: UUID
    let startTime: Date
    let endTime: Date?
    var snoringEvents: [SnoringEvent]
    var breathingRecords: [BreathingRecord]
    
    struct SnoringEvent: Identifiable, Codable {
        let id: UUID
        let timestamp: Date
        let duration: TimeInterval
        let intensity: Double // 0.0 to 1.0
    }
    
    struct BreathingRecord: Identifiable, Codable {
        let id: UUID
        let timestamp: Date
        let breathingRate: Double // breaths per minute
    }
    
    init(id: UUID = UUID(), startTime: Date = Date()) {
        self.id = id
        self.startTime = startTime
        self.endTime = nil
        self.snoringEvents = []
        self.breathingRecords = []
    }
} 