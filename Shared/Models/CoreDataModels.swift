import Foundation
import CoreData

@objc(SleepSessionEntity)
public class SleepSessionEntity: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var startTime: Date?
    @NSManaged public var endTime: Date?
    @NSManaged public var breathingRecords: NSSet?
    @NSManaged public var snoringEvents: NSSet?
}

@objc(BreathingRecordEntity)
public class BreathingRecordEntity: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var breathingRate: Double
    @NSManaged public var session: SleepSessionEntity?
}

@objc(SnoringEventEntity)
public class SnoringEventEntity: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var duration: Double
    @NSManaged public var intensity: Double
    @NSManaged public var audioData: Data?
    @NSManaged public var session: SleepSessionEntity?
} 