//
//  QuizSeriveces.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-23.
//

import Foundation

struct QuizAPI {
    static func sendSummaryForQuiz(noteId: String, title: String, content: String, userId: String, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        let url = URL(string: "http://192.168.8.173:5001/api/quizzes/generate")!
        
        let payload: [String: Any] = [
            "noteId": noteId,
            "title": title,
            "content": content,
            "userId": userId
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            print("Failed to encode JSON: \(error)")
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API call failed: \(error)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data returned")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                return
            }
            
            // Print the raw response data as a string before handling it
            if let responseString = String(data: data, encoding: .utf8) {
                print("API Response: \(responseString)")
            }

            do {
                // Directly parse the response as an array of dictionaries
                if let responseArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    completion(.success(responseArray))
                } else {
                    print("Failed to parse JSON response as an array of dictionaries.")
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                }
            } catch {
                print("Failed to parse JSON response: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
