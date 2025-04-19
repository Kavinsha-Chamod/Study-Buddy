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

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 17, weight: .bold, design: .default))
                        .foregroundColor(.black)
                    
                    Text(description)
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .foregroundColor(.black.opacity(0.8))
                        .lineLimit(3)
                    
                    HStack {
                        Spacer()
                        Text("→")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(Color.blue)
                            .cornerRadius(200)
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color(red: 220/255, green: 219/255, blue: 219/255))
            .cornerRadius(20)
            .shadow(radius: 5)
            .frame(maxWidth: .infinity, minHeight: 150)
        }.padding(.horizontal, 20)
        .padding(.top, 2)
        .buttonStyle(PlainButtonStyle())
    }
}

