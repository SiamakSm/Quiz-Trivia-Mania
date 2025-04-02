//
//  HomeView.swift
//  TriviaMania
//
//  Created by Siamak Moloudi on 27/03/2025.
//

import SwiftUI
import UIKit

struct HomeView: View {
    @State private var difficulty: String = "easy"
    let difficulties = ["easy", "medium", "hard"]
    @State private var qCount: Int = 5
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Text("Hello.")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)

                Text("Welcome to Trivia Mania!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .padding(.bottom, 10)

                Spacer()
                VStack(alignment: .center)
                {
                    Image("Image1")
                        .renderingMode(.none)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                }
                .padding(.bottom, 30)
                
                VStack {
                        Text("Number of Questions : \(qCount)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .padding(.bottom,1)
                            // Slider pour choisir le nombre de questions
                        Slider(value: Binding(
                            get: { Double(qCount) },
                            set: { qCount = Int($0) }
                        ), in: 1...30, step: 1)
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 5)
                
                VStack {
                    Text("Level of Difficulty")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .padding(.bottom,1)
                    
                    // Picker pour choisir la difficulté
                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(difficulties, id: \.self) { level in
                            Text(level.capitalized) // Affiche en majuscule
                        }
                    }.padding(.bottom, 30)
                    .pickerStyle(SegmentedPickerStyle())
                }.padding(.horizontal, 30)
                    
                NavigationLink {
                    QuestionsViews(numQuestions: qCount , diffQuestions: difficulty)
                    
                } label: {
                    Text("Start Challenging...")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(25)
                        .shadow(radius: 10)
                }
                .padding(.horizontal,70)
                
                NavigationLink {
                    MoreView()
                } label: {
                    Text("More")
                        .font(.headline)
                        .foregroundColor(.black)
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
