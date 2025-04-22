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

    var body: some View {
        if let userId = currentUserId {
            MainTabView(currentUserId: userId, hasCompletedFocusSetup: $hasCompletedFocusSetup)
        } else {
            OnBoardView(hasCompletedFocusSetup: $hasCompletedFocusSetup)
        }
    }
}
