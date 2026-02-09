//
//  ShoeDetailView.swift
//  FlipWise
//
//  Detail modal view for displaying full sneaker analysis
//

import SwiftUI

struct ShoeDetailView: View {
    let analyzedShoe: AnalyzedShoe
    @Environment(\.dismiss) private var dismiss
    
    var shoe: Shoe {
        analyzedShoe.shoe
    }
    
    var recommendation: Recommendation {
        analyzedShoe.recommendation
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Large Shoe Image
                    AsyncImage(url: URL(string: shoe.image)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 300)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 300)
                        case .failure:
                            Image(systemName: "photo")
                                .font(.system(size: 72))
                                .foregroundColor(.gray)
                                .frame(height: 300)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 5)
                    
                    // Shoe Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text(shoe.brand.uppercased())
                            .font(.caption)
                            .foregroundColor(.gray)
                            .fontWeight(.semibold)
                        
                        Text(shoe.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        if let colorway = shoe.colorway {
                            Text(colorway)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Recommendation Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recommendation")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text(recommendation.action)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(badgeColor)
                                .cornerRadius(12)
                            
                            Text("\(recommendation.confidence)% confidence")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(recommendation.reason)
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    
                    // Metrics Grid
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Metrics")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            MetricCard(
                                title: "Retail Price",
                                value: "$\(recommendation.metrics.retailPrice, specifier: "%.0f")",
                                color: .blue
                            )
                            
                            MetricCard(
                                title: "Avg Resale",
                                value: "$\(recommendation.metrics.averageResalePrice, specifier: "%.0f")",
                                color: .purple
                            )
                            
                            MetricCard(
                                title: "Profit Margin",
                                value: "$\(recommendation.metrics.profitMargin, specifier: "%.0f")",
                                color: recommendation.metrics.profitMargin >= 0 ? .green : .red
                            )
                            
                            MetricCard(
                                title: "ROI",
                                value: "\(recommendation.metrics.roiPercentage, specifier: "%.1f")%",
                                color: recommendation.metrics.roiPercentage >= 0 ? .green : .red
                            )
                        }
                    }
                    
                    // Best Platform
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Best Platform")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(recommendation.bestPlatform)
                                .font(.body)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Release Date
                    if let releaseDate = shoe.releaseDate {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Release Date")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Text(formatDate(releaseDate))
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    var badgeColor: Color {
        switch recommendation.action.uppercased() {
        case "BUY":
            return .green
        case "HOLD":
            return .orange
        case "SELL":
            return .red
        default:
            return .gray
        }
    }
    
    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MMMM d, yyyy"
            return formatter.string(from: date)
        }
        return dateString
    }
}

// MARK: - Metric Card Component
struct MetricCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    ShoeDetailView(analyzedShoe: AnalyzedShoe(
        shoe: Shoe(
            styleID: "555088-134",
            name: "Air Jordan 1 Retro High OG Chicago",
            brand: "Jordan",
            colorway: "White/Black-Red",
            image: "https://via.placeholder.com/400",
            releaseDate: "2015-05-30"
        ),
        recommendation: Recommendation(
            action: "BUY",
            confidence: 85,
            reason: "High demand and limited supply make this a strong investment",
            metrics: Metrics(
                retailPrice: 160,
                averageResalePrice: 450,
                profitMargin: 290,
                roiPercentage: 181.25
            ),
            bestPlatform: "StockX"
        )
    ))
}
