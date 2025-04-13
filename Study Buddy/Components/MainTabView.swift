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

    var body: some View {
        NavigationStack {
            ZStack {
                // Add a blur effect to mimic polished UI
                BlurView(style: .systemUltraThinMaterial)
                    .ignoresSafeArea()

                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .tag(0)

                    ScanDocView()
                        .tabItem {
                            Image(systemName: "document.viewfinder")
                            Text("Scan Doc")
                        }
                        .tag(1)

                    NewNoteView()
                        .tabItem {
                            Image(systemName: "document.badge.plus.fill")
                            Text("New Note")
                        }
                        .tag(2)
                    
                    FilesView()
                        .tabItem {
                            Image(systemName: "folder.fill")
                            Text("Files")
                        }
                        .tag(3)

                    AccountView()
                        .tabItem {
                            Image(systemName: "person.crop.circle.fill")
                            Text("Account")
                        }
                        .tag(4)
                }
                .accentColor(.blue)
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainTabView()
}
