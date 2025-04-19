//
//  OnBoardView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-13.
//

import SwiftUI
import CoreData
import AuthenticationServices

struct OnBoardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack {
                    HeaderView()
                    OnboardImageView()
                    GuestButtonView(navigateToHome: $navigateToHome)
                    AppleSignInButton(navigateToHome: $navigateToHome)
                    NavigationLink(destination: MainTabView(currentUserId: "000433.2b8f204455454466b29789a0266b3139.0742"), isActive: $navigateToHome) {
                        EmptyView()
                    }
                    .hidden()
                }
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

// MARK: - Subviews

private struct HeaderView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Study Buddy")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.black)

            Text("Your AI-Powered Study Companion")
                .font(.system(size: 17))
                .foregroundColor(.black)
        }
    }
}

private struct OnboardImageView: View {
    var body: some View {
        Image("OnBoardIcon")
            .resizable()
            .frame(width: 300, height: 300)
            .padding(.top, 10)
    }
}

private struct GuestButtonView: View {
    @Binding var navigateToHome: Bool

    var body: some View {
        ButtonView(
            title: "Continue as a Guest",
            backgroundColor: Color(red: 74 / 255, green: 144 / 255, blue: 226 / 255),
            foregroundColor: .white,
            borderColor: Color(red: 74 / 255, green: 144 / 255, blue: 226 / 255)
        ) {
            navigateToHome = true
        }
        .padding(.top, 30)
    }
}

private struct AppleSignInButton: View {
    @Binding var navigateToHome: Bool

    var body: some View {
        SignInWithAppleButton(
            .signIn,
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    if let credential = authResults.credential as? ASAuthorizationAppleIDCredential {
                        let userId = credential.user
                        let email = credential.email
                        let fullName = credential.fullName

                        print("User ID: \(userId)")
                        print("Email: \(email ?? "N/A")")
                        print("Full Name: \((fullName?.givenName ?? "") + " " + (fullName?.familyName ?? ""))")

                        saveUserToCoreData(id: userId, email: email, fullName: fullName)
                        navigateToHome = true
                    }
                case .failure(let error):
                    print("Apple Sign-In Error: \(error.localizedDescription)")
                }
            }
        )
        .signInWithAppleButtonStyle(.black)
        .frame(height: 45)
        .cornerRadius(10)
        .padding(.top, 10)
        .padding(.horizontal, 30)
    }

    func saveUserToCoreData(id: String, email: String?, fullName: PersonNameComponents?) {
        let context = PersistenceController.shared.container.viewContext

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let existingUsers = try context.fetch(fetchRequest)
            if existingUsers.isEmpty {
                let newUser = User(context: context)
                newUser.id = id
                newUser.email = email
                newUser.firstName = fullName?.givenName
                newUser.lastName = fullName?.familyName

                try context.save()
                print("User saved to Core Data")
            } else {
                print("User already exists. Skipping save.")
            }
        } catch {
            print("Failed to check/save user: \(error.localizedDescription)")
        }
    }
}

#Preview {
    OnBoardView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
