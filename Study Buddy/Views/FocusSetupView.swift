//
//  FocusSetupView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-22.
//

import SwiftUI
import CoreData

struct FocusSetupView: View {
    @Environment(\.managedObjectContext) private var context
    @Binding var hasCompletedFocusSetup: Bool
    @State private var navigateToCountdown = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Set Up Countdown Focus")
                .font(.title)
            Text("Create a 'Countdown Focus' mode in Settings to silence notifications during your countdown.")
                .multilineTextAlignment(.center)
                .padding()
            Button("Open Focus Settings") {
                if let url = URL(string: "App-prefs:FOCUS") {
                    UIApplication.shared.open(url)
                }
            }
            .buttonStyle(.borderedProminent)
            Text("Steps:\n1. Tap on Focus.\n2. Tap 'Add New Focus'.\n3. Tap on Custom.\n4. Name it 'Countdown Focus'.\n5. Silence all notifications.\n6. Save and return here.")
                .multilineTextAlignment(.center)
            Button("I’ve Set Up Countdown Focus") {
                            do {
                                try PersistenceController.shared.markFocusSetupComplete(context: context)
                                hasCompletedFocusSetup = true
                                navigateToCountdown = true
                                // Verify Core Data state
                                let fetchRequest: NSFetchRequest<Settings> = Settings.fetchRequest()
                                if let settings = try? context.fetch(fetchRequest).first {
                                    print("Core Data: hasCompletedFocusSetup = \(settings.hasCompletedFocusSetup)")
                                } else {
                                    print("Core Data: No Settings entity found")
                                }
                                print("Binding: hasCompletedFocusSetup = \(hasCompletedFocusSetup)")
                                print("Navigating to FocusModeView")
                            } catch {
                                print("Error saving focus setup: \(error)")
                            }
                        }
                        .buttonStyle(.bordered)
            NavigationLink(destination: FocusModeView(), isActive: $navigateToCountdown) {
                            EmptyView()
                        }
        }
        .padding()
    }
}
