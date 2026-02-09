//
//  ContentView.swift
//  FlipWise
//
//  Main search screen with beautiful gradient background
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SneakerViewModel()
    @State private var searchQuery = ""
    @State private var selectedShoe: AnalyzedShoe?
    
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Search Section
                    VStack(spacing: 24) {
                        VStack(spacing: 12) {
                            Text("Find Your Next Investment")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Search any sneaker to get AI-powered recommendations")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 60)
                        
                        // Search Bar
                        HStack(spacing: 12) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                
                                TextField("Search sneakers (e.g., Jordan 1)", text: $searchQuery)
                                    .textFieldStyle(.plain)
                                    .submitLabel(.search)
                                    .onSubmit {
                                        performSearch()
                                    }
                                
                                if !searchQuery.isEmpty {
                                    Button(action: {
                                        searchQuery = ""
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(12)
                            
                            Button(action: {
                                performSearch()
                            }) {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(12)
                            }
                            .disabled(searchQuery.isEmpty)
                            .opacity(searchQuery.isEmpty ? 0.5 : 1.0)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Content Area
                    if viewModel.isLoading {
                        // Loading State
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.white)
                            
                            Text("Analyzing sneakers...")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 60)
                    } else if let errorMessage = viewModel.errorMessage {
                        // Error State
                        ErrorView(message: errorMessage)
                            .padding()
                    } else if !viewModel.shoes.isEmpty {
                        // Results Grid
                        LazyVGrid(
                            columns: [
                                GridItem(.adaptive(minimum: 280), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(viewModel.shoes) { analyzedShoe in
                                Button(action: {
                                    selectedShoe = analyzedShoe
                                }) {
                                    ShoeCard(analyzedShoe: analyzedShoe)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .sheet(item: $selectedShoe) { analyzedShoe in
            ShoeDetailView(analyzedShoe: analyzedShoe)
        }
    }
    
    private func performSearch() {
        guard !searchQuery.isEmpty else { return }
        
        // Dismiss keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        Task {
            await viewModel.searchSneakers(query: searchQuery)
        }
    }
}

#Preview {
    ContentView()
}
