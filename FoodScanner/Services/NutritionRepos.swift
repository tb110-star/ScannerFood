//
//  NutritionRepos.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 19.02.25.
//

import Foundation
final class NutritionRepository {
    private let apiKey = "86232c0ec6msha0e6116dd4015d6p1801e2jsn8f9975c783b7"
    private let baseURL = "https://ai-nutritional-facts.p.rapidapi.com/getNutritionalInfo"

    func getNutritionInfo(_ request: NutritionRequest) async throws -> NutritionResponse {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        urlRequest.setValue("ai-nutritional-facts.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try JSONEncoder().encode(request)
        urlRequest.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(NutritionResponse.self, from: data)
        return decodedResponse
    }
}
