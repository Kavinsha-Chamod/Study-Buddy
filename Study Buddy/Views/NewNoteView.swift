//
//  ScanDocView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-13.
//

import SwiftUI
import CoreData

struct NewNoteView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)

            VStack{
                Text("Note")
                    .font(.system(size: 34, weight: .bold, design: .default))
                    .foregroundColor(.black)
                    .padding(.top, 20)
                    .padding(.leading, 20)
                Spacer()
              }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

#Preview {
    NewNoteView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
