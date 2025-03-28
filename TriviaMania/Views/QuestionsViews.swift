//
//  aaaa.swift
//  TriviaManiaS
//
//  Created by Siamak Moloudi on 29/03/2025.
//

import SwiftUI

struct QuestionsViews: View {
    @Environment(\.presentationMode) var presentationMode
    @State var questionCount = 1
    @State var score: Int = 0
    @State var randomTrivia: [DataModel] = []
    @State var showHint: Bool = false
    @State var input : String = ""
    @State var finished = false
    @State var submitEnable: Bool = false
    @State var isAnswerCorrect: Bool? = nil
    @State var correctAnswer: String = ""

    var body: some View {
        ZStack {
            // Fond de l'écran avec un dégradé doux
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if !finished {
                    if !randomTrivia.isEmpty {
                        VStack {
                            HStack {
                                Text("Question: \(questionCount)/5")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                Spacer()
                                Text("Score: \(score)/5")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                            .padding()

                            // Affiche la question
                            Text(randomTrivia[0].question)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding()
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                            
                            Button(action: {
                                withAnimation {
                                    showHint.toggle()
                                }
                            }) {
                                Image(systemName: "lightbulb")
                                Text(showHint ? "Hide Hint" : "Show Hint")
                            }
                            if showHint {
                                VStack(alignment: .leading) {
                                    Text("Possible answers:")
                                    ForEach(randomTrivia[0].incorrect_answers + [randomTrivia[0].correct_answer], id: \.self) {answer in Text("• \(answer)")
                                    }
                                }
                            }
                            
                            // Champ de saisie pour la réponse
                            TextField("Type your answer here", text: $input)
                                .padding()
                                .background(isAnswerCorrect == nil ? Color.white : (isAnswerCorrect! ? Color.green : Color.red))
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .disableAutocorrection(true)
                                .padding(.bottom, 20)
                                .animation(.easeInOut, value: isAnswerCorrect) // Correction : avec 'animation(_:value:)'

                            // Bouton pour soumettre la réponse
                            Button {
                                withAnimation {
                                    if input.lowercased() == randomTrivia[0].correct_answer.lowercased() {
                                        score += 1
                                        isAnswerCorrect = true
                                        correctAnswer = "" // Clear if answer is correct
                                    } else {
                                        isAnswerCorrect = false
                                        correctAnswer = randomTrivia[0].correct_answer
                                    }
                                    submitEnable = true
                                }
                            } label: {
                                Text("Submit")
                                    .padding()
                                    .background(submitEnable ? Color.green : Color.gray)
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .scaleEffect(submitEnable ? 1.1 : 1.0)
                                    .animation(.spring(), value: submitEnable) // Correction : avec 'animation(_:value:)'
                            }
                            .disabled(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || submitEnable)

                            // Affichage de la réponse correcte si l'utilisateur se trompe
                            if !correctAnswer.isEmpty && isAnswerCorrect == false {
                                Text("Correct Answer: \(correctAnswer)")
                                    .foregroundColor(.green)
                                    .font(.headline)
                                    .padding(.top, 12)
                                    .transition(.slide) // Transition pour la réponse correcte
                            }

                            // Réinitialiser et passer à la question suivante
                            HStack {
                                Button {
                                    withAnimation {
                                        getNewQuestion()
                                        score = 0
                                        input = ""
                                        questionCount = 0
                                        showHint = false
                                    }
                                } label: {
                                    VStack {
                                        Image(systemName: "arrow.counterclockwise.circle.fill")
                                            .font(.system(size: 40))
                                        Text("Restart")
                                            .foregroundColor(.black)
                                    }
                                }
                                .padding()

                                Button {
                                    withAnimation {
                                        getNewQuestion()
                                        input = ""
                                        showHint = false
                                        submitEnable = false
                                        isAnswerCorrect = nil
                                        correctAnswer = ""
                                    }
                                } label: {
                                    VStack {
                                        Image(systemName: "chevron.forward.circle.fill")
                                            .font(.system(size: 40))
                                        Text(questionCount == 5 ? "Finish" : "Next")
                                            .foregroundColor(.black)
                                    }
                                }
                                .padding()
                                .disabled(submitEnable == false)
                            }
                            .padding(.top, 20)
                        }
                        .padding(.horizontal)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(15)
                        .shadow(radius: 10)
                    }
                } else { // Affiche le score final
                    final
                }
            }
        }
        .onAppear {
            withAnimation {
                Api().getData { randomTrivia in
                    self.randomTrivia = randomTrivia
                }
            }
        }
    }
    
    var final: some View {
        VStack(spacing: 24) {
            Text("Trivia Completed!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("Score: \(score)")
                .font(.title2)
                .foregroundColor(.white)

            Button {
                input = ""
                isAnswerCorrect = nil
                submitEnable = false
                finished = false
                questionCount = 0
                score = 0
                getNewQuestion()
                showHint = false
            } label: {
                Text("Try again?")
                    .foregroundColor(.blue)
                    .font(.title2)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }

            Button {
                self.presentationMode.wrappedValue.dismiss()
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
        .background(Color.black.opacity(0.8))
        .cornerRadius(20)
        .shadow(radius: 15)
    }
    
    func getNewQuestion() {
        Api().getData { randomTrivia in
            if questionCount == 5 {
                finished = true
            } else {
                questionCount += 1
            }
            self.randomTrivia = randomTrivia
        }
    }
}

#Preview {
    QuestionsViews()
}
