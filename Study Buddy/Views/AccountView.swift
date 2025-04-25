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

    private var fetchRequest: FetchRequest<User>
    private var user: User? { fetchRequest.wrappedValue.first }

    init() {
        let predicate = NSPredicate(format: "id == %@", UserDefaults.standard.string(forKey: "loggedInUserId") ?? "")
        self.fetchRequest = FetchRequest<User>(
            entity: User.entity(),
            sortDescriptors: [],
            predicate: predicate
        )
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer().frame(height: 40)

                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)

                Text(user?.firstName ?? "Unknown User")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(user?.email ?? "No email available")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()

                Button(action: logoutUser) {
                    Text("Log Out")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                NavigationLink(destination: OnBoardView(hasCompletedFocusSetup: $hasCompletedFocusSetup), isActive: $navigateToOnboard) {
                    EmptyView()
                }
                .hidden()

                Spacer().frame(height: 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Account")
        }
    }

    private func logoutUser() {
        currentUserId = nil
        print("Logged out: user session cleared.")
    }
}
