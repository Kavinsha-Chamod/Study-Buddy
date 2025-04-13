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
                Color.white
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("Study Buddy")
                        .font(.system(size: 34, weight: .bold, design: .default))
                        .foregroundColor(.black)

                    Text("Your AI-Powered Study Companion")
                        .font(.system(size: 17, weight: .regular, design: .default))
                        .foregroundColor(.black)
                        .padding(.top, -10)

                    Image("OnBoardIcon")
                        .resizable()
                        .frame(width: 300, height: 300)

                    // Guest Button
                    ButtonView(
                        title: "Continue as a Guest",
                        backgroundColor: Color(red: 74 / 255, green: 144 / 255, blue: 226 / 255),
                        foregroundColor: .white,
                        borderColor: Color(red: 74 / 255, green: 144 / 255, blue: 226 / 255)
                    ) {
                        navigateToHome = true
                    }
                    .padding(.top, 30)

                    // Apple Sign-In Button
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

                                    // Save to Core Data
                                    saveUserToCoreData(id: userId, email: email, fullName: fullName)

                                    // Navigate after success
                                    navigateToHome = true
                                }
                            case .failure(let error):
                                print("Error:", error.localizedDescription)
                            }
                        }
                    )
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 45)
                    .cornerRadius(10)
                    .padding(.top, 10)
                    .padding(.horizontal, 30)

                    // NavigationLink to Home
                    NavigationLink(
                        destination: HomeView(),
                        isActive: $navigateToHome,
                        label: {
                            EmptyView()
                        })
                        .hidden()
                }
            }.navigationBarBackButtonHidden(true)
        }
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
}
