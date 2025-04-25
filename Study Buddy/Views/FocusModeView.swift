//
//  FocusModeView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-22.
//

import SwiftUI
import CoreData
import UserNotifications

struct FocusModeView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.scenePhase) private var scenePhase

    @State private var selectedDuration: Int? = nil
    @State private var totalDuration: Int = 0
    @State private var timeRemaining: Int = 0
    @State private var isCounting = false
    @State private var showEndFocusPrompt = false
    @State private var customDuration: Int = 15
    @State private var showSlider: Bool = false
    @State private var focusStartDate: Date? = nil

    let presetDurations = [1, 30, 50]

    var body: some View {
        VStack(spacing: 30) {
            if !isCounting {
                Text("How long do you want to focus?")
                    .font(.system(size: 17, weight: .medium))
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ScrollView(.horizontal, showsIndicators: false) {
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
                    .padding(.horizontal)
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
                Text(isCounting ? "Stop Focus" : "Start Focus")
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black)

                    ScrollView(.horizontal, showsIndicators: false) {
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
                        .padding(.horizontal)
                    }
                }
                .transition(.slide)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            requestNotificationPermission()
            loadOngoingTimer()
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            guard isCounting, let start = focusStartDate else { return }
            let elapsed = Int(Date().timeIntervalSince(start))
            let remaining = totalDuration - elapsed
            if remaining > 0 {
                timeRemaining = remaining
            } else {
                timeRemaining = 0
                isCounting = false
                showEndFocusPrompt = true
                updateFocusSession()
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["FocusEnd"])
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                loadOngoingTimer()
            }
        }
        .navigationTitle("Focus Mode")
    }

    // MARK: - Timer Logic

    private func setTime(minutes: Int) {
        totalDuration = minutes * 60
        timeRemaining = totalDuration
        isCounting = false
        focusStartDate = nil
    }

    private func toggleTimer() {
        if !isCounting {
            focusStartDate = Date()
            saveFocusSession()
            sendStartNotification()
            scheduleEndNotification(after: timeRemaining)
        } else {
            focusStartDate = nil
            timeRemaining = totalDuration
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["FocusEnd"])
        }
        isCounting.toggle()
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

    // MARK: - Core Data

    private func saveFocusSession() {
        let session = CountdownSession(context: context)
        session.startDate = Date()
        session.duration = Int32(totalDuration)
        session.completed = false
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

    private func loadOngoingTimer() {
        let fetchRequest: NSFetchRequest<CountdownSession> = CountdownSession.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]

        if let session = try? context.fetch(fetchRequest).first,
           let startDate = session.startDate,
           !session.completed {

            let elapsed = Int(Date().timeIntervalSince(startDate))
            if elapsed < session.duration {
                totalDuration = Int(session.duration)
                timeRemaining = totalDuration - elapsed
                focusStartDate = startDate
                isCounting = true
            } else {
                session.completed = true
                try? context.save()
            }
        }
    }

    // MARK: - Notifications

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }

    private func sendStartNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🎯 Focus Session Started"
        content.body = "Stay focused and do your best!"
        content.sound = .default

        let request = UNNotificationRequest(identifier: "FocusStart", content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to send start notification: \(error.localizedDescription)")
            } else {
                print("Start notification sent")
            }
        }
    }

    private func scheduleEndNotification(after seconds: Int) {
        let content = UNMutableNotificationContent()
        content.title = "⏰ Focus Session Complete"
        content.body = "Your focus session has ended. Great job!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
        let request = UNNotificationRequest(identifier: "FocusEnd", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule end notification: \(error.localizedDescription)")
            } else {
                print("End notification scheduled")
            }
        }
    }
}

#Preview {
    FocusModeView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
