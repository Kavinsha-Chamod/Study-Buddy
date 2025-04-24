//
//  MainTabView.swift
//  Campus Navigator
//
//  Created by Kavinsha Chamod on 2025-02-24.
//

import SwiftUI
import UIKit

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct MainTabView: View {
    @State private var selectedTab = 0
    var currentUserId: String
    @Binding var hasCompletedFocusSetup: Bool

    var body: some View {
        ZStack {
            BlurView(style: .systemUltraThinMaterial)
                .ignoresSafeArea()

            TabView(selection: $selectedTab) {
                NavigationStack {
                    HomeView(hasCompletedFocusSetup: $hasCompletedFocusSetup)
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

                NavigationStack {
                    ScanDocView()
                }
                .tabItem {
                    Image(systemName: "document.viewfinder")
                    Text("Scan Doc")
                }
                .tag(1)

                NavigationStack {
                    NewNoteView(currentUserId: currentUserId)
                }
                .tabItem {
                    Image(systemName: "document.badge.plus.fill")
                    Text("New Note")
                }
                .tag(2)

                NavigationStack {
                    FilesView(currentUserId: currentUserId)
                }
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Notes")
                }
                .tag(3)

                NavigationStack {
                    AccountView()
                }
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Account")
                }
                .tag(4)
            }
            .accentColor(.blue)
        }
        .onAppear {
            console()
        }
        .navigationBarBackButtonHidden(true)
    }

    func console() {
        print("User Id: currentUserId =", currentUserId)
    }
}
