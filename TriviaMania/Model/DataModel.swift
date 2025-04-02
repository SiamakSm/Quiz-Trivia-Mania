//
//  DataModel.swift
//  TriviaMania
//
//  Created by Siamak Moloudi on 28/03/2025.
//

import Foundation

struct DataModel: Codable {
    var question: String
    var correct_answer: String
    var incorrect_answers: [String]
    
    var allAnswers: [String] {
        return (incorrect_answers + [correct_answer]).shuffled()
    }
}

