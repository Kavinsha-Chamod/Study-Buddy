//
//  StudyPlanServices.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-23.
//

import Foundation
import CoreData

func sendNoteToAPI(note: Note, userId: String, completion: @escaping (String?) -> Void) {
    guard let title = note.title,
          let content = note.content,
          let noteId = note.id?.uuidString else {
        completion(nil)
        return
    }
    let url = URL(string: "http://192.168.8.173:5001/api/summarize")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let payload: [String: Any] = [
        "userId": userId,
        "noteId": noteId,
        "title": title,
        "content": content
    ]

    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
    } catch {
        print("Failed to encode JSON: \(error.localizedDescription)")
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let httpResponse = response as? HTTPURLResponse {
            print("Status code: \(httpResponse.statusCode)")
        }

        guard let data = data, error == nil else {
            print("Network error: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }

        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let summary = json["summary"] as? String {
                completion(summary)
            } else {
                print("Unexpected JSON format: \(String(data: data, encoding: .utf8) ?? "")")
                completion(nil)
            }
        } catch {
            print("JSON decoding error: \(error.localizedDescription)")
            completion(nil)
        }
    }.resume()
}
