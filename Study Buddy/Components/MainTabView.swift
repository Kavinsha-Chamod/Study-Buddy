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

                    NewNoteView(currentUserId: currentUserId)
                        .tabItem {
                            Image(systemName: "document.badge.plus.fill")
                            Text("New Note")
                        }
                        .tag(2)
                    
                    FilesView(currentUserId: currentUserId)
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
            }.onAppear {
                console()
            }
        }.navigationBarBackButtonHidden(true)
    }
    func console(){
        print("User Id", currentUserId);
    }
}

#Preview {
    MainTabView(currentUserId:"000433.2b8f204455454466b29789a0266b3139.0742")
//    MainTabView(currentUserId: "000433.0742")
}
