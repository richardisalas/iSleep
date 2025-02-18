import Foundation
import AVFoundation

class AudioRecordingService: NSObject, ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var audioEngine: AVAudioEngine?
    private var inputNode: AVAudioInputNode?
    
    @Published var isRecording = false
    @Published var currentAmplitude: Double = 0
    
    private var timer: Timer?
    var onSnoringDetected: ((Double) -> Void)?
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func startRecording() {
        guard !isRecording else { return }
        
        audioEngine = AVAudioEngine()
        guard let audioEngine = audioEngine else { return }
        
        inputNode = audioEngine.inputNode
        let recordingFormat = inputNode?.outputFormat(forBus: 0)
        
        inputNode?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.processAudioBuffer(buffer)
        }
        
        do {
            try audioEngine.start()
            isRecording = true
            
            // Start amplitude monitoring timer
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                self?.updateAmplitude()
            }
        } catch {
            print("Failed to start audio engine: \(error)")
        }
    }
    
    func stopRecording() {
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        timer?.invalidate()
        isRecording = false
    }
    
    private func processAudioBuffer(_ buffer: AVAudioPCMBuffer) {
        // Implement snoring detection algorithm here
        // This is a simplified example - you'd want more sophisticated detection
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let frameCount = UInt32(buffer.frameLength)
        
        var sum: Float = 0
        for frame in 0..<Int(frameCount) {
            sum += abs(channelData[frame])
        }
        
        let average = sum / Float(frameCount)
        if average > 0.1 { // Threshold for snoring detection
            DispatchQueue.main.async {
                self.onSnoringDetected?(Double(average))
            }
        }
    }
    
    private func updateAmplitude() {
        // Update current amplitude for UI feedback
        // Implementation would depend on your specific needs
    }
} 