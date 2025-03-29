//
//  HomeView.swift
//  TriviaMania
//
//  Created by Siamak Moloudi on 27/03/2025.
//

import SwiftUI

struct HomeView: View {
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

                NavigationLink {
                    QuestionsViews()
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
                
                Text("MOLOUDI Mohammad - ABDOLI Hossein")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .cornerRadius(40)
                    .shadow(radius: 10)
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

#Preview {
    HomeView()
}
