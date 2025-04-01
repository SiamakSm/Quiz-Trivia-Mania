//
//  HomeView.swift
//  TriviaMania
//
//  Created by Siamak Moloudi on 27/03/2025.
//

import SwiftUI
import UIKit

struct HomeView: View {
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
                    .padding(.bottom, 30)

                Spacer()
                VStack(alignment: .center)
                {
                    Image("Image1")
                        .renderingMode(.none)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        
                }
                .padding(.top)
                
                VStack {
                        Text("Nombre de questions : \(qCount)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .padding(.bottom, 1)
                            // Slider pour choisir le nombre de questions
                        Slider(value: Binding(
                            get: { Double(qCount) },
                            set: { qCount = Int($0) }
                        ), in: 1...30, step: 1)
                        }
                        .padding(40)
                
                NavigationLink {
                    QuestionsViews(numQuestions: qCount)
                    
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
                .padding(.horizontal, 30)
                
                Spacer()

                NavigationLink {
                    MoreView()
                } label: {
                    Text("More")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .cornerRadius(44)
                        .shadow(radius: 10)
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal)
            .padding(.top, 20)
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
