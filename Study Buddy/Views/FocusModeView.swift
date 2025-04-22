//
//  FocusModeView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-22.
//

import SwiftUI
import CoreData

struct FocusModeView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.scenePhase) private var scenePhase
    @State private var selectedDuration: Int? = nil

    @State private var timeRemaining: Int = 0
    @State private var totalDuration: Int = 0
    @State private var isCounting = false
    @State private var showEndFocusPrompt = false

    @State private var customDuration: Int = 15
    @State private var showSlider: Bool = false

    let presetDurations = [15, 30, 50]

    var body: some View {
        VStack(spacing: 30) {
            if !isCounting {
                Text("How long do you want to focus?")
                    .font(.system(size: 17, weight: .medium))
                    .padding(.trailing, 100)
                    .padding(.top)

                HStack(spacing: 15) {
                    ForEach(presetDurations, id: \.self) { min in
                        Button("\(min) min") {
                            setTime(minutes: min)
                            selectedDuration = min
                        }
                        .buttonStyle(.bordered)
                        .tint(selectedDuration == min ? .blue : .gray)
                    }

                    Button("Custom") {
                        showSlider.toggle()
                        if !showSlider {
                            selectedDuration = nil
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(!presetDurations.contains(selectedDuration ?? 0) ? .blue : .gray)
                }

                if showSlider {
                    HStack(spacing: 10) {
                        Slider(value: Binding(
                            get: { Double(customDuration) },
                            set: {
                                customDuration = Int($0)
                                selectedDuration = customDuration
                                setTime(minutes: customDuration)
                            }
                        ), in: 5...60, step: 5)
                        .accentColor(.blue)
                        .padding(.horizontal)

                        Text("\(customDuration) min")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.trailing)
                    }
                    .transition(.opacity)
                }
            }

            Spacer()

            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: progress)

                Text(formattedTime)
                    .font(.system(size: 48, weight: .regular, design: .rounded))
                    .foregroundColor(.blue)
            }
            .frame(width: 250, height: 250)

            Button(action: toggleTimer) {
                Text(isCounting ? "Pause" : "Start Focus")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            .disabled(totalDuration == 0)

            if isCounting {
                VStack(spacing: 15) {
                    Text("Want more time?")
                        .font(.system(size: 17, weight: .medium))
                        .padding(.trailing, 210)
                        .foregroundColor(.black)

                    HStack(spacing: 15) {
                        ForEach(presetDurations, id: \.self) { min in
                            Button("\(min) min") {
                                extendTime(by: min)
                            }
                            .buttonStyle(.bordered)
                            .tint(.blue)
                        }
                        Button("Custom") {
                            showSlider.toggle()
                            if !showSlider {
                                selectedDuration = nil
                            }
                        }
                        .buttonStyle(.bordered)
                        .tint(!presetDurations.contains(selectedDuration ?? 0) ? .blue : .gray)
                        
                    }
                }
                .transition(.slide)
            }

            Spacer()
        }
        .padding()
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            guard isCounting else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else if isCounting {
                isCounting = false
                showEndFocusPrompt = true
                updateFocusSession()
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background {
                let session = CountdownSession(context: context)
                session.remainingTime = Int32(timeRemaining)
                try? context.save()
            } else if phase == .active {
                let fetchRequest: NSFetchRequest<CountdownSession> = CountdownSession.fetchRequest()
                if let session = try? context.fetch(fetchRequest).last, session.remainingTime > 0 {
                    timeRemaining = Int(session.remainingTime)
                }
            }
        }
        .alert("Focus Ended", isPresented: $showEndFocusPrompt) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your focus session has ended.")
        }
        .navigationTitle("Focus Mode")
    }

    // MARK: - Helpers

    private func setTime(minutes: Int) {
        totalDuration = minutes * 60
        timeRemaining = totalDuration
        isCounting = false
    }

    private func toggleTimer() {
        isCounting.toggle()
        if isCounting {
            saveFocusSession()
        }
    }

    private func extendTime(by minutes: Int) {
        totalDuration += minutes * 60
        timeRemaining += minutes * 60
    }

    private var progress: CGFloat {
        guard totalDuration > 0 else { return 0 }
        return CGFloat(totalDuration - timeRemaining) / CGFloat(totalDuration)
    }

    private var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func saveFocusSession() {
        let session = CountdownSession(context: context)
        session.startDate = Date()
        session.duration = Int32(totalDuration)
        session.completed = false
        session.remainingTime = Int32(timeRemaining)
        try? context.save()
    }

    private func updateFocusSession() {
        let fetchRequest: NSFetchRequest<CountdownSession> = CountdownSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "completed == false")
        if let session = try? context.fetch(fetchRequest).first {
            session.completed = true
            try? context.save()
        }
    }
}


#Preview {
    FocusModeView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
