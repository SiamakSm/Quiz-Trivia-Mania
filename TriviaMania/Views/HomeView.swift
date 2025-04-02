//
//  HomeView.swift
//  TriviaMania
//
//  Created by Siamak Moloudi on 27/03/2025.
//
// This file represents the home view for the TriviaMania app where users can choose their quiz settings
// such as the number of questions and difficulty level, and then start the quiz or navigate to more options.

import SwiftUI
import UIKit

struct HomeView: View {
    @State private var difficulty: String = "easy" // State variable to hold the selected difficulty
    let difficulties = ["easy", "medium", "hard"] // List of available difficulty levels
    @State private var qCount: Int = 5 // State variable to store the number of questions selected
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Text("Hello.") // Welcome text
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)

                Text("Welcome to Trivia Mania!") // Subtitle text
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .padding(.bottom, 10)

                Spacer()
                VStack(alignment: .center)
                {
                    Image("Image1") // Image displayed in the view
                        .renderingMode(.none)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                }
                .padding(.bottom, 30)
                
                VStack {
                    Text("Number of Questions : \(qCount)") // Display number of questions selected
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .padding(.bottom,1)
                        
                    Slider(value: Binding(  // Slider to choose the number of questions
                        get: { Double(qCount) },
                        set: { qCount = Int($0) }
                    ), in: 1...30, step: 1)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 5)
                
                VStack {
                    Text("Level of Difficulty") // Display text for the difficulty level
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .padding(.bottom,1)
                    
                    // Picker to choose the difficulty level
                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(difficulties, id: \.self) { level in
                            Text(level.capitalized) // Display difficulty in capital letters
                        }
                    }.padding(.bottom, 30)
                    .pickerStyle(SegmentedPickerStyle())
                }.padding(.horizontal, 30)
                    
                // NavigationLink to navigate to the QuestionsViews
                NavigationLink {
                    QuestionsViews(numQuestions: qCount , diffQuestions: difficulty)
                } label: {
                    Text("Start Challenging...") // Start button text
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(25)
                        .shadow(radius: 10)
                }
                .padding(.horizontal,70)
                
                // NavigationLink to navigate to the MoreView
                NavigationLink {
                    MoreView()
                } label: {
                    Text("More") // More button text
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top,30)
                }
            }
            .padding(.horizontal)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

//The MoreView struct is used to represent the “More” section in the app, which integrates the UIKit-based MainTabBarController into the SwiftUI view hierarchy.
struct MoreView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainTabBarController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        return tabBarController
    }

    func updateUIViewController(_ uiViewController: MainTabBarController, context: Context) {
    }
}

#Preview {
    HomeView()
}
