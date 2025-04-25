//
//  DashboardTitlesView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-15.
//

import SwiftUI

struct DashboardTitlesView<Destination: View>: View {
    var title: String
    var imageName: String
    var description: String
    var destination: Destination

    @Environment(\.colorScheme) var colorScheme

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
    }

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(alignment: .center, spacing: 12) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .padding(.horizontal, 12)
                    .foregroundColor(colorScheme == .dark ? .white : .primary)

                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .white : .primary)

                    Text(description)
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : .primary.opacity(0.7))
                        .lineLimit(3)

                    HStack {
                        Spacer()
                        Text("→")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                    }
                }
                Spacer()
            }
            .padding()
            .background(cardBackground)
            .frame(maxWidth: .infinity, minHeight: 150)
            .scaleEffect(1.0)
            .animation(.easeInOut(duration: 0.2), value: 1.0)
        }
        .padding(.horizontal, 20)
        .padding(.top, 2)
        .buttonStyle(PlainButtonStyle())
    }
}

//#Preview {
//    DashboardTitlesView(
//        title: "Today's Study Plan",
//        imageName: "studying",
//        description: "Personalized plans based on your learning style and schedule.",
//        destination: StudyPlanView()
//    )
//    .padding()
//    .background(Color(.systemBackground)) }
