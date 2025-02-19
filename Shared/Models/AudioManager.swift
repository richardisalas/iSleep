import Foundation
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    
    private let fileManager = FileManager.default
    
    private var documentsDirectory: URL {
        #if os(watchOS)
        // Use watch app group container for watch
        return fileManager.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.yourdomain.iSleep"
        )!
        #else
        // Use documents directory for iOS
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        #endif
    }
    
    func saveSnoreAudio(_ data: Data, for eventId: UUID) throws {
        let audioUrl = documentsDirectory.appendingPathComponent("\(eventId.uuidString).m4a")
        try data.write(to: audioUrl)
    }
    
    func loadSnoreAudio(for eventId: UUID) throws -> Data {
        let audioUrl = documentsDirectory.appendingPathComponent("\(eventId.uuidString).m4a")
        return try Data(contentsOf: audioUrl)
    }
    
    func deleteSnoreAudio(for eventId: UUID) {
        let audioUrl = documentsDirectory.appendingPathComponent("\(eventId.uuidString).m4a")
        try? fileManager.removeItem(at: audioUrl)
    }
} 