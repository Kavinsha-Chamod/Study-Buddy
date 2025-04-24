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
    @AppStorage("loggedInUserId") private var currentUserId: String = ""
    @Binding var hasCompletedFocusSetup: Bool
    
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
                        destination: SmartQuizzesView()
                    )
                    DashboardTitlesView(
                        title: "Import PDF Files",
                        imageName: "OnBoardIcon",
                        description: "Import the pdf files and summarize contents.",
                        destination: FilesView(currentUserId: currentUserId)
                    )
                    DashboardTitlesView(
                        title: "Focus Mode",
                        imageName: "OnBoardIcon",
                        description: "Set a timer for distraction-free study sessions.",
                        destination: hasCompletedFocusSetup
                                ? AnyView(FocusModeView())
                                : AnyView(FocusSetupView(hasCompletedFocusSetup: $hasCompletedFocusSetup))
                    )
                }
            }.frame(maxWidth: .infinity)
            .padding(.top, 140)
            .padding(.vertical, 40)
        }
        .navigationBarBackButtonHidden(true)
    }
    private func loadFocusSetupState() {
            let fetchRequest: NSFetchRequest<Settings> = Settings.fetchRequest()
            if let settings = try? viewContext.fetch(fetchRequest).first {
                hasCompletedFocusSetup = settings.hasCompletedFocusSetup
                print("HomeView loaded: hasCompletedFocusSetup = \(hasCompletedFocusSetup)")
            } else {
                print("HomeView: No Settings entity found")
            }
        }
}
