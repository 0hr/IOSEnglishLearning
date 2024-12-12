import SwiftUI
import AVFoundation

struct SpeakingPracticeView: View {
    @State private var messages: [ChatMessage] = []
    @State private var newMessage: String = ""
    @State private var isRecording = false
    @State private var showingPrompt = false
    @State private var selectedTopic: String?
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioFileURL: URL?
    @State private var audioPlayer: AVPlayer?
    private var audioSession = AVAudioSession.sharedInstance()
    var body: some View {
        VStack(spacing: 0) {
            // Chat Messages
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(messages) { message in
                        ChatBubble(message: message)
                    }
                }
                .padding()
            }
            
            // Input Area
            VStack(spacing: 16) {
                // Recording indicator
 
                
                HStack(spacing: 12) {
                    Spacer()
                    
                    // Voice Recording Button
                    Button(action: {
                        isRecording.toggle()
                        if (isRecording) {
                            self.startRecording()
                        } else {
                            audioRecorder?.stop()
                            uploadAudio(fileURL: audioFileURL!)
                        }
                    }) {
                        Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                            .font(.system(size: 64))
                            .foregroundColor(isRecording ? .red : Theme.purple)
                    }
                    
          
                    Spacer()
                }.padding()
                
                
            }
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.05), radius: 10)
        }
    }
    
    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
            print("Audio session configured successfully.")
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
        }
    }
    
    private func playAudio(audioUrl: String) {
        guard let url = URL(string: audioUrl) else {
            print("Invalid URL")
            return
        }
        
        audioPlayer = AVPlayer(url: url)
        
        // Observe for playback errors
        NotificationCenter.default.addObserver(forName: .AVPlayerItemFailedToPlayToEndTime, object: audioPlayer?.currentItem, queue: .main) { notification in
            if let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error {
                print("Playback failed: \(error.localizedDescription)")
            }
        }
        
        audioPlayer?.play()
    }
    
    func startRecording() {
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let fileName = UUID().uuidString + ".wav"
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            audioFileURL = fileURL
            
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 16000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
                AVLinearPCMBitDepthKey: 16,
                AVLinearPCMIsBigEndianKey: false,
                AVLinearPCMIsFloatKey: false
            ]
            
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            
        } catch {
            print("Failed to start recording: \(error)")
        }
    }
    
    func uploadAudio(fileURL: URL) {
        let boundary = "Boundary-\(UUID().uuidString)"
        let url = URL(string: "http://localhost:8000/chat")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(UUID().uuidString).wav\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/wav\r\n\r\n".data(using: .utf8)!)
        
        do {
            let audioData = try Data(contentsOf: fileURL)
            body.append(audioData)
        } catch {
            print("Failed to read audio file: \(error)")
            return
        }
        
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        let task = URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
            if let error = error {
                print("Failed to upload audio: \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("Server responded with status code: \(response.statusCode)")
            }
            if let data = data {
                print("Server responded with data: \(String(data: data, encoding: .utf8) ?? "No Response")")
                let decoder = JSONDecoder()
                if let chatResponse = try? decoder.decode(ChatResponse.self, from: data) {
                    let messageUser = ChatMessage(
                        content: chatResponse.transcription,
                        isUser:true,
                        timestamp: Date(),
                        audioURL: nil
                    )
                    
                    
                    let messageAi = ChatMessage(
                        content: chatResponse.response,
                        isUser:false,
                        timestamp: Date(),
                        audioURL: URL(string: "http://localhost:8000\( chatResponse.audioURL)")
                    )
                    
                    playAudio(audioUrl: "http://localhost:8000\( chatResponse.audioURL)")
               
                    messages.append(messageUser)
                    messages.append(messageAi)
                }
            }
        }
        task.resume()
    }
}

// Chat Bubble View
struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                // Message content
                Text(message.content)
                    .padding(12)
                    .background(message.isUser ? Theme.purple : Color.white)
                    .foregroundColor(message.isUser ? .white : .primary)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 5)
        
                
                // Timestamp
                Text(formatTimestamp(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            if !message.isUser { Spacer() }
        }
    }
    
    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


// Recording Indicator View
struct RecordingIndicator: View {
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.red)
                .frame(width: 8, height: 8)
                .scaleEffect(scale)
                .animation(Animation.easeInOut(duration: 1).repeatForever(), value: scale)
                .onAppear {
                    scale = 1.2
                }
            
            Text("Recording...")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

// Message model for chat
struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
    let audioURL: URL?
}

struct ChatResponse: Codable {
    let transcription: String
    let response: String
    let audioURL: URL
    
    enum CodingKeys: String, CodingKey {
        case audioURL = "audio_file_url"
        case response, transcription
    }
}

#Preview {
    SpeakingPracticeView()
}
