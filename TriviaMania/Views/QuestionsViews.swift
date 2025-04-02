//
//  QuestionsViews.swift
//  TriviaMania
//
//  Created by Siamak Moloudi on 29/03/2025.
//
// This SwiftUI view QuestionsViews implements a quiz interface with questions fetched from an API, a score tracker, and functionality for showing hints and submitting answers.

import SwiftUI

struct QuestionsViews: View {
    @Environment(\.presentationMode) var presentationMode // Allows control over the current view's presentation
    @State var questionCount = 1 // Tracks the current question number
    @State var score: Int = 0 // Keeps track of the user's score
    @State var randomTrivia: [DataModel] = [] // Holds the trivia data for the current question
    @State var showHint: Bool = false // Determines if the hint should be shown
    @State var input : String = "" // Stores the user's answer input
    @State var finished = false // Indicates whether the quiz is finished
    @State var submitEnable: Bool = false // Enables or disables the submit button
    @State var isAnswerCorrect: Bool? = nil // Indicates if the user's answer is correct
    @State var correctAnswer: String = "" // Stores the correct answer for feedback
    var numQuestions: Int // The total number of questions in the quiz
    var diffQuestions: String // The difficulty level of the questions

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all) // Ensures gradient covers the whole screen
            
            VStack {
                if !finished {
                    // If the quiz is not finished, display the question
                    if !randomTrivia.isEmpty {
                        VStack {
                            // Display the current question count and score at the top
                            HStack {
                                Text("Question: \(questionCount)/\(numQuestions)")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                Spacer()
                                Text("Score: \(score)/\(numQuestions)")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                            .padding()

                            // Display the question text
                            Text(randomTrivia[0].question)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding()
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                            
                            // Hint button, toggles the visibility of possible answers
                            Button(action: {
                                withAnimation {
                                    showHint.toggle()
                                }
                            }) {
                                Image(systemName: "lightbulb")
                                Text(showHint ? "Hide Hint" : "Show Hint")
                            }
                            
                            // Display possible answers as hints when showHint is true
                            if showHint {
                                VStack(alignment: .leading) {
                                    Text("Possible answers:")
                                    ForEach(randomTrivia[0].incorrect_answers + [randomTrivia[0].correct_answer], id: \.self) {answer in
                                        Text("• \(answer)")
                                    }
                                }
                            }
                            
                            // TextField for user to type their answer
                            TextField("Type your answer here", text: $input)
                                .padding()
                                .background(isAnswerCorrect == nil ? Color.white : (isAnswerCorrect! ? Color.green : Color.red))
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .disableAutocorrection(true)
                                .padding(.bottom, 20)
                                .animation(.easeInOut, value: isAnswerCorrect) // Animates the color change based on correctness

                            // Submit button, checks if the answer is correct
                            Button {
                                withAnimation {
                                    if input.lowercased() == randomTrivia[0].correct_answer.lowercased() {
                                        score += 1 // Increment score if the answer is correct
                                        isAnswerCorrect = true
                                        correctAnswer = "" // Clear correct answer display
                                    } else {
                                        isAnswerCorrect = false
                                        correctAnswer = randomTrivia[0].correct_answer // Show the correct answer if wrong
                                    }
                                    submitEnable = true // Enable the submit button after an answer is given
                                }
                            } label: {
                                Text("Submit")
                                    .padding()
                                    .background(submitEnable ? Color.green : Color.gray) // Change button color based on submit enable state
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .scaleEffect(submitEnable ? 1.1 : 1.0)
                                    .animation(.spring(), value: submitEnable) // Button scaling animation
                            }
                            .disabled(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || submitEnable) // Disable if input is empty or submit is already enabled

                            // Display the correct answer if the user's answer is incorrect
                            if !correctAnswer.isEmpty && isAnswerCorrect == false {
                                Text("Correct Answer: \(correctAnswer)")
                                    .foregroundColor(.green)
                                    .font(.headline)
                                    .padding(.top, 12)
                                    .transition(.slide) // Slide transition for showing the correct answer
                            }

                            // Navigation buttons for restarting or moving to the next question
                            HStack {
                                // Restart button
                                Button {
                                    withAnimation {
                                        getNewQuestion() // Fetch new question when restarting
                                        score = 0 // Reset score
                                        input = "" // Clear input
                                        questionCount = 1 // Reset question count
                                        showHint = false // Hide the hint
                                    }
                                } label: {
                                    VStack {
                                        Image(systemName: "arrow.counterclockwise.circle.fill")
                                            .font(.system(size: 40))
                                        Text("Restart")
                                            .foregroundColor(.black)
                                    }
                                }.padding()

                                // Next/Finish button
                                Button {
                                    withAnimation {
                                        getNewQuestion() // Get next question or finish if it's the last
                                        input = "" // Clear input
                                        showHint = false // Hide the hint
                                        submitEnable = false // Reset submit state
                                        isAnswerCorrect = nil // Reset correctness state
                                        correctAnswer = "" // Clear correct answer
                                    }
                                } label: {
                                    VStack {
                                        Image(systemName: "chevron.forward.circle.fill")
                                            .font(.system(size: 40))
                                        Text(questionCount == numQuestions ? "Finish" : "Next")
                                            .foregroundColor(.black)
                                    }
                                }
                                .padding()
                                .disabled(submitEnable == false) // Disable the button if submit is not enabled
                            }
                            .padding(.top, 20)
                        }
                        .padding(.horizontal)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(15)
                        .shadow(radius: 10)
                    }
                } else {
                    final // Show final view if the quiz is finished
                }
            }
        }
        .onAppear {
            // Fetch the trivia data when the view appears
            withAnimation {
                Api.getData(difficulty: diffQuestions) { randomTrivia in
                    self.randomTrivia = randomTrivia // Assign the trivia data to randomTrivia
                }
            }
        }
    }
    
    // Final view that shows the score and gives the user options to retry or finish
    var final: some View {
        VStack(spacing: 24) {
            Text("Trivia Completed!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("Score: \(score)")
                .font(.title2)
                .foregroundColor(.white)

            // Retry button, resets the quiz
            Button {
                input = ""
                isAnswerCorrect = nil
                submitEnable = false
                finished = false
                questionCount = 0
                score = 0
                getNewQuestion() // Get new question when retrying
                showHint = false // Reset hint visibility
            } label: {
                Text("Try again?")
                    .foregroundColor(.blue)
                    .font(.title2)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }

            // Finish button, dismiss the view
            Button {
                self.presentationMode.wrappedValue.dismiss() // Dismiss the current view
            } label: {
                Text("Finish")
                    .foregroundColor(.blue)
                    .font(.title2)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.black.opacity(0.8)) // Dark background for final view
        .cornerRadius(20)
        .shadow(radius: 15) // Shadow effect for final view
    }
    
    // Function to get a new question from the API
    func getNewQuestion() {
        Api.getData(difficulty: diffQuestions) { randomTrivia in
            if questionCount == numQuestions {
                finished = true // Mark quiz as finished when the last question is reached
            } else {
                questionCount += 1 // Increment question count
            }
            self.randomTrivia = randomTrivia // Update trivia with the new question
        }
    }
}

#Preview {
    QuestionsViews(numQuestions: 7, diffQuestions: "easy")
}
