import Foundation
import CoreData

class SleepSessionStore: ObservableObject {
    private let viewContext: NSManagedObjectContext
    @Published var sessions: [SleepSession] = []
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        
        // Observe CoreData changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(managedObjectContextObjectsDidChange),
            name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
            object: context)
    }
    
    func fetchLastSevenSessions() {
        let fetchRequest: NSFetchRequest<SleepSessionEntity> = SleepSessionEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \SleepSessionEntity.startTime, ascending: false)]
        fetchRequest.fetchLimit = 7
        
        do {
            let entities = try viewContext.fetch(fetchRequest)
            sessions = entities.compactMap { $0.asSleepSession }
        } catch {
            print("Failed to fetch sessions: \(error)")
        }
    }
    
    func saveSleepSession(_ session: SleepSession) {
        let entity = SleepSessionEntity(context: viewContext)
        entity.id = session.id
        entity.startTime = session.startTime
        entity.endTime = session.endTime
        
        // Save breathing records
        session.breathingRecords.forEach { record in
            let recordEntity = BreathingRecordEntity(context: viewContext)
            recordEntity.id = record.id
            recordEntity.timestamp = record.timestamp
            recordEntity.breathingRate = record.breathingRate
            recordEntity.session = entity
        }
        
        // Save snoring events with audio data
        session.snoringEvents.forEach { event in
            let eventEntity = SnoringEventEntity(context: viewContext)
            eventEntity.id = event.id
            eventEntity.timestamp = event.timestamp
            eventEntity.duration = event.duration
            eventEntity.intensity = event.intensity
            eventEntity.session = entity
            
            // Save audio data locally
            if let audioData = try? AudioManager.shared.loadSnoreAudio(for: event.id) {
                eventEntity.audioData = audioData
            }
        }
        
        PersistenceController.shared.save()
    }
    
    @objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
        fetchLastSevenSessions()
    }
}

// Extension to convert CoreData entity to model
extension SleepSessionEntity {
    var asSleepSession: SleepSession {
        var session = SleepSession(id: id ?? UUID(), startTime: startTime ?? Date())
        session.endTime = endTime
        
        session.breathingRecords = (breathingRecords?.allObjects as? [BreathingRecordEntity])?.compactMap { entity in
            guard let id = entity.id,
                  let timestamp = entity.timestamp else { return nil }
            
            return BreathingRecord(id: id,
                                 timestamp: timestamp,
                                 breathingRate: entity.breathingRate)
        } ?? []
        
        session.snoringEvents = (snoringEvents?.allObjects as? [SnoringEventEntity])?.compactMap { entity in
            guard let id = entity.id,
                  let timestamp = entity.timestamp else { return nil }
            
            return SnoringEvent(id: id,
                              timestamp: timestamp,
                              duration: entity.duration,
                              intensity: entity.intensity)
        } ?? []
        
        return session
    }
} 