//
//  NavigationTile.swift
//  Campus Navigator
//
//  Created by Kavinsha Chamod on 2025-04-12.
//
import SwiftUI

struct NavigationTile<Destination: View>: View {
    let title: String
    let image: String
    let color: Color
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(1))
                
                VStack {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)

                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
                .padding()
            }
            .frame(width: UIScreen.main.bounds.width * 0.45, height: 185)
        }
    }
}
