//
//  ContentView.swift
//  TriviaMania
//
//  Created by Siamak Moloudi on 27/03/2025.
//

//import SwiftUI
//
//struct ContentView: View {
//    @State private var triviaQuestions: [DataModel] = []
//
//    var body: some View {
//        VStack {
//            if let question = triviaQuestions.first {
//                Text(question.question)
//                    .font(.title)
//            } else {
//                Text("Chargement...")
//            }
//
//            Button("Charger une question") {
//                Api().getData { data in
//                    triviaQuestions = data
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
//
