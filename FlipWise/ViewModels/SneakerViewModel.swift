//
//  SneakerViewModel.swift
//  FlipWise
//
//  Business logic for sneaker search and analysis
//

import Foundation

@MainActor
class SneakerViewModel: ObservableObject {
    @Published var shoes: [AnalyzedShoe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func searchSneakers(query: String) async {
        // Clear previous results and errors
        shoes = []
        errorMessage = nil
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let response = try await APIService.analyzeSneakers(query: query)
            shoes = response.results
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
