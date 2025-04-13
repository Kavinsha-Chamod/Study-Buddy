//
//  HomeView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-13.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            Image("Ellipse")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 300)
                .padding(.bottom, 650)
        VStack{
            Text("Study Buddy")
                .font(.system(size: 34, weight: .bold, design: .default))
                .foregroundColor(.white)
                .padding(.top, 130)
                .padding(.leading, 20)
            Spacer()
          }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
