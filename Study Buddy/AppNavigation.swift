//
//  AppNavigation.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-24.
//

import SwiftUI

enum NavigationRoute: Hashable {
    case studyPlan
}

class AppNavigation: ObservableObject {
    @Published var path = NavigationPath()
}
