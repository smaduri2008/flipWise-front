//
//  ErrorView.swift
//  FlipWise
//
//  Error display component
//

import SwiftUI

struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text(message)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.9))
        )
        .shadow(radius: 10)
    }
}

#Preview {
    ErrorView(message: "Failed to load sneakers. Please try again.")
        .padding()
}
