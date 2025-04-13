//
//  HomeView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-13.
//

import SwiftUI
import CoreData
import AuthenticationServices

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            Text("Study Buddy")
                .font(.system(size: 34, weight: .bold, design: .default))
                .foregroundColor(.black)
        }
        .onAppear {
            fetchUsers()
        }
        Button("Clear Users") {
            clearAllUsers()
        }
        .navigationBarBackButtonHidden(true)
    }

    private func fetchUsers() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

        do {
            let users = try viewContext.fetch(fetchRequest)
            for user in users {
                print("==================================")
                print("Saved User:")
                print("• ID: \(user.id ?? "")")
                print("• Email: \(user.email ?? "N/A")")
                print("• Name: \((user.firstName ?? "") + " " + (user.lastName ?? ""))")
                print("==================================")
            }
        } catch {
            print("Failed to fetch users: \(error.localizedDescription)")
        }
    }
    
    func clearAllUsers() {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("All users deleted successfully.")
        } catch {
            print("Failed to delete users: \(error.localizedDescription)")
        }
    }

}

#Preview {
    HomeView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
