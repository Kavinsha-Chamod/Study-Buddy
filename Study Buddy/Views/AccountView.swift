//
//  ScanDocView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-13.
//

import SwiftUI
import CoreData

struct AccountView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("loggedInUserId") var currentUserId: String?
    @State private var navigateToOnboard = false
    @State private var hasCompletedFocusSetup: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                VStack(alignment: .leading) {
                    Text("Account")
                        .font(.system(size: 34, weight: .bold))
                        .padding(.top, 20)

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
        }
    }

    private func logoutUser() {
        currentUserId = nil
        print("Logged out: user session cleared.")
    }
}
