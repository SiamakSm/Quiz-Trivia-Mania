//
//  Api.swift
//  TriviaMania
//
//  Created by Siamak Moloudi on 28/03/2025.
//

import SwiftUI

class Api {
    static let baseURL = "https://opentdb.com/api.php"
    
    static func getData(difficulty: String, completion: @escaping ([DataModel]) -> ()) {
        guard let url = URL(string: "\(baseURL)?amount=1&type=multiple&difficulty=\(difficulty)") else { return }
        //print("URL appelée: \(url)")
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(" Error  \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print(" No data received from API")
                return
            }
            
            do {
                var decodedData = try JSONDecoder().decode(TriviaResponse.self, from: data)
                
                decodedData.results = decodedData.results.map { trivia in
                    DataModel(
                        question: trivia.question.decodedHTML,
                        correct_answer: trivia.correct_answer.decodedHTML,
                        incorrect_answers: trivia.incorrect_answers.map { $0.decodedHTML }
                    )
                }
                print("Correct answer : \( decodedData.results[0].correct_answer)")
                DispatchQueue.main.async {
                    completion(decodedData.results)
                }
            } catch {
                print("JSON Decoding Error: \(error)")
            }
        }.resume()
    }
}

// Structure pour correspondre à la réponse JSON de l'API
struct TriviaResponse: Codable {
    var results: [DataModel]
}
