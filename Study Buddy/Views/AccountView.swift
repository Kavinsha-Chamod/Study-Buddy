//
//  ScanDocView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-13.
//

import SwiftUI
import CoreData

import SwiftUI

struct AccountView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("loggedInUserId") var currentUserId: String?
    @State private var navigateToOnboard = false
    @State private var hasCompletedFocusSetup: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading) {
                    Spacer()

                    Button(action: logoutUser) {
                        Text("Log Out")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)

                    // Navigation trigger
                    NavigationLink(destination: OnBoardView(hasCompletedFocusSetup: $hasCompletedFocusSetup), isActive: $navigateToOnboard) {
                        EmptyView()
                    }
                    .hidden()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .navigationTitle("Account")
        }
    }

    private func logoutUser() {
        currentUserId = nil
        print("Logged out: user session cleared.")
    }
}
