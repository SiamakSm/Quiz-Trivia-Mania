//  Api.swift
//  TriviaMania
//
//  Created by Siamak Moloudi on 28/03/2025.
//
// This file, Api.swift, is responsible for fetching trivia questions from an external API and processing the response.

import SwiftUI

// Class responsible for handling API requests
class Api {
    static let baseURL = "https://opentdb.com/api.php"  // Base URL for the trivia API
    
    // Function to fetch trivia data from the API
    static func getData(difficulty: String, completion: @escaping ([DataModel]) -> ()) {
        // Construct the API URL with query parameters
        guard let url = URL(string: "\(baseURL)?amount=1&type=multiple&difficulty=\(difficulty)") else { return }
        
        // Start a data task to fetch data from the API
        URLSession.shared.dataTask(with: url) { data, _, error in
            // Handle any error during the request
            if let error = error {
                print(" Error  \(error.localizedDescription)")
                return
            }
            
            // Ensure that valid data is received
            guard let data = data else {
                print(" No data received from API")
                return
            }
            
            do {
                // Decode the JSON response into TriviaResponse structure
                var decodedData = try JSONDecoder().decode(TriviaResponse.self, from: data)
                
                // Decode any HTML entities in the question and answers
                decodedData.results = decodedData.results.map { trivia in
                    DataModel(
                        question: trivia.question.decodedHTML,
                        correct_answer: trivia.correct_answer.decodedHTML,
                        incorrect_answers: trivia.incorrect_answers.map { $0.decodedHTML }
                    )
                }
                
                // Print the correct answer to the console
                print("Correct answer : \( decodedData.results[0].correct_answer)")
                
                // Update UI on the main thread with the retrieved data
                DispatchQueue.main.async {
                    completion(decodedData.results)
                }
            } catch {
                // Handle JSON decoding errors
                print("JSON Decoding Error: \(error)")
            }
        }.resume() // Start the network request
    }
}

// Structure matching the JSON response from the API
struct TriviaResponse: Codable {
    var results: [DataModel]  // Array of trivia questions
}
