//
//  ShoeCard.swift
//  FlipWise
//
//  Shoe card component for displaying sneaker information
//

import SwiftUI

struct ShoeCard: View {
    let analyzedShoe: AnalyzedShoe
    
    var shoe: Shoe {
        analyzedShoe.shoe
    }
    
    var recommendation: Recommendation {
        analyzedShoe.recommendation
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Shoe Image
            AsyncImage(url: URL(string: shoe.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(height: 200)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                case .failure:
                    Image(systemName: "photo")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                        .frame(height: 200)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(12)
            
            // Brand
            Text(shoe.brand.uppercased())
                .font(.caption)
                .foregroundColor(.gray)
                .fontWeight(.semibold)
            
            // Shoe Name
            Text(shoe.name)
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(2)
                .foregroundColor(.primary)
            
            // Recommendation Badge
            Text(recommendation.action)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(badgeColor)
                .cornerRadius(8)
            
            // Prices
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Retail")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text("$\(recommendation.metrics.retailPrice, specifier: "%.0f")")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Resale")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text("$\(recommendation.metrics.averageResalePrice, specifier: "%.0f")")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            
            // Profit Margin
            Text("Profit: $\(recommendation.metrics.profitMargin, specifier: "%.0f")")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(recommendation.metrics.profitMargin >= 0 ? .green : .red)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
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
}

#Preview {
    ShoeCard(analyzedShoe: AnalyzedShoe(
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
            reason: "High demand and limited supply",
            metrics: Metrics(
                retailPrice: 160,
                averageResalePrice: 450,
                profitMargin: 290,
                roiPercentage: 181.25
            ),
            bestPlatform: "StockX"
        )
    ))
    .padding()
    .frame(width: 300)
}
