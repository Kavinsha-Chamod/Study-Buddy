//
//  SummaryView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-23.
//

import SwiftUI
import AVFoundation

struct SummaryView: View {
    var title: String
    var summary: String
    @State private var synthesizer = AVSpeechSynthesizer()
    @State private var isSpeaking = false
    @State private var isPaused = false

    var body: some View {
        NavigationView {
            ScrollView {
                Text(summary)
                    .padding()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        if isSpeaking {
                            stopSpeech()
                        } else {
                            speakSummary(summary)
                        }
                    }) {
                        Text(isSpeaking ? "Stop Reading" : "Read Summary")
                    }

                    Spacer()

                    Button("Next") {
                        print("Next tapped")
                        // Add action here
                    }
                }
            }
        }
        .onAppear {
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
            try? AVAudioSession.sharedInstance().setActive(true)
        }
    }

    private func speakSummary(_ text: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
        isSpeaking = true
        isPaused = false
    }

    private func stopSpeech() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
        isPaused = false
    }
}
