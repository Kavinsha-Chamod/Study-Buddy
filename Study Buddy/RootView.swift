//
//  RootView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-19.
//

import SwiftUI

struct RootView: View {
    @AppStorage("loggedInUserId") var currentUserId: String?
    @Binding var hasCompletedFocusSetup: Bool
    @EnvironmentObject var appNavigation: AppNavigation

    var body: some View {
        NavigationStack(path: $appNavigation.path) {
            VStack {
                if let userId = currentUserId {
                    MainTabView(currentUserId: userId, hasCompletedFocusSetup: $hasCompletedFocusSetup)
                } else {
                    OnBoardView(hasCompletedFocusSetup: $hasCompletedFocusSetup)
                }
            }
            .navigationDestination(for: NavigationRoute.self) { route in
                switch route {
                case .studyPlan:
                    if let userId = currentUserId {
                        StudyPlanView()
                    } else {
                        Text("User not logged in")
                    }
                }
            }
        }
    }
}
