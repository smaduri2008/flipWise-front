//
//  APIService.swift
//  FlipWise
//
//  Handles API communication with the Flask backend
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

class APIService {
    // Note: Change this to your computer's IP address for real device testing
    // Find your IP: ifconfig | grep "inet " | grep -v 127.0.0.1
    static let baseURL = "http://localhost:5001/api"
    
    static func analyzeSneakers(query: String) async throws -> AnalyzeResponse {
        // Construct URL
        guard let url = URL(string: "\(baseURL)/analyze") else {
            throw APIError.invalidURL
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create request body
        let body = ["query": query]
        request.httpBody = try? JSONEncoder().encode(body)
        
        // Make request
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Validate response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            
            // Decode response
            do {
                let decoder = JSONDecoder()
                let analyzeResponse = try decoder.decode(AnalyzeResponse.self, from: data)
                return analyzeResponse
            } catch {
                throw APIError.decodingError(error)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}
