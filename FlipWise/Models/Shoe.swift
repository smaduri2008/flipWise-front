//
//  Shoe.swift
//  FlipWise
//
//  Data models for the FlipWise app
//

import Foundation

// MARK: - Shoe Model
struct Shoe: Codable, Identifiable {
    let styleID: String
    let name: String
    let brand: String
    let colorway: String?
    let image: String
    let releaseDate: String?
    
    var id: String { styleID }
    
    enum CodingKeys: String, CodingKey {
        case styleID = "id"
        case name
        case brand
        case colorway
        case image
        case releaseDate = "release_date"
    }
}

// MARK: - Metrics Model
struct Metrics: Codable {
    let retailPrice: Double
    let averageResalePrice: Double
    let profitMargin: Double
    let roiPercentage: Double
    
    enum CodingKeys: String, CodingKey {
        case retailPrice = "retail_price"
        case averageResalePrice = "average_resale_price"
        case profitMargin = "profit_margin"
        case roiPercentage = "roi_percentage"
    }
}

// MARK: - Recommendation Model
struct Recommendation: Codable {
    let action: String // BUY, HOLD, or SELL
    let confidence: Int // 0-100
    let reason: String
    let metrics: Metrics
    let bestPlatform: String
    
    enum CodingKeys: String, CodingKey {
        case action
        case confidence
        case reason
        case metrics
        case bestPlatform = "best_platform"
    }
}

// MARK: - AnalyzedShoe Model
struct AnalyzedShoe: Codable, Identifiable {
    let shoe: Shoe
    let recommendation: Recommendation
    
    var id: String { shoe.id }
}

// MARK: - API Response Model
struct AnalyzeResponse: Codable {
    let query: String
    let count: Int
    let results: [AnalyzedShoe]
}
