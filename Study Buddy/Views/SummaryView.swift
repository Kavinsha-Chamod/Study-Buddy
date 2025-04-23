//
//  SummaryView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-23.
//

import SwiftUI

struct SummaryView: View {
    var title: String
    var summary: String

    var body: some View {
        NavigationView {
            ScrollView {
                Text(summary)
                    .padding()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
