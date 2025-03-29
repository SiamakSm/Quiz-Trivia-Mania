//
//  AboutView.swift
//  TriviaMania
//
//  Created by Siamak Moloudi on 29/03/2025.
//
import SwiftUI
import UIKit

struct AboutView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AboutViewController {
        let storyboard = UIStoryboard(name: "About", bundle: nil) // Charger About.storyboard
        let viewController = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: AboutViewController, context: Context) {
        // Rien à mettre ici
    }
}
