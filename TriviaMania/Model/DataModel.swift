//
//  DataModel.swift
//  TriviaMania
//
//  Created by Siamak Moloudi on 28/03/2025.
//
// DataModel.swift defines the structure for quiz questions fetched from the API.

import Foundation

struct DataModel: Codable {
    
    var question: String // The quiz question text
    var correct_answer: String // The correct answer to the question
    var incorrect_answers: [String] // A list of incorrect answers for the question
    
    // A computed property that combines correct and incorrect answers in a randomized order
    var allAnswers: [String] {
        return (incorrect_answers + [correct_answer]).shuffled()
    }
}
