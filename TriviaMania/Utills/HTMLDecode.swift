//
//  HTMLDecode.swift
//  TriviaMania
//
//  Created by Siamak Moloudi on 28/03/2025.
//
// This file defines an extension on String to add a computed property called decodedHTML. The purpose of this property is to convert HTML-encoded text into a human-readable format by decoding special HTML entities.

import Foundation

// Extension to add a computed property to the String type
extension String {
    
    // A computed property that decodes HTML entities in a string.
    var decodedHTML: String {
        // Convert the string to UTF-8 encoded data
        guard let data = self.data(using: .utf8) else { return self }
        
        // Define options for interpreting the data as an HTML document
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html, // Interpret as HTML
            .characterEncoding: String.Encoding.utf8.rawValue // Specify UTF-8 encoding
        ]
        
        // Try to create an NSAttributedString from the data, extracting the plain text content
        return (try? NSAttributedString(data: data, options: options, documentAttributes: nil).string) ?? self
    }
}
