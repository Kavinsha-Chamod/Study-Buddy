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
            Image("Ellipse")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 300)
                .padding(.bottom, 650)
            VStack{
                Text("Study Buddy")
                    .font(.system(size: 34, weight: .bold, design: .default))
                    .foregroundColor(.white)
                    .padding(.top, 132)
                    .padding(.leading, 20)
                Spacer()
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            ScrollView(showsIndicators: false){
                VStack {
                    DashboardTitlesView(
                        title: "Todays's Study Plan",
                        imageName: "OnBoardIcon",
                        description: "Personalized plans based on your learning style and schedule.",
                        destination: StudyPlanView()
                    )
                    DashboardTitlesView(
                        title: "Smart Quizzes",
                        imageName: "OnBoardIcon",
                        description: "Test your knowledge with AI-generated quizzes.",
                        destination: ScanDocView()
                    )
                    DashboardTitlesView(
                        title: "Import PDF Files",
                        imageName: "OnBoardIcon",
                        description: "Import the pdf files and summarize contents.",
                        destination: ScanDocView()
                    )
                    DashboardTitlesView(
                        title: "Focus Mode",
                        imageName: "OnBoardIcon",
                        description: "Set a timer for distraction-free study sessions.",
                        destination: ScanDocView()
                    )
                }
            }.frame(maxWidth: .infinity)
            .padding(.top, 140)
            .padding(.vertical, 40)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
