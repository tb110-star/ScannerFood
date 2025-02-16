//
//  VisionAPIRepository.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 15.02.25.
//

import Foundation

final class VisionAPIRepository {
    
    private let apiKey = "AIzaSyAjwoBeNPbbvKJHnDZ68JDC-C65MovAOYE"
    
    func analyzeImage(base64String: String) async throws -> VisionResponse {
        guard let url = URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)") else {
            throw HTTPError.invalidURL

        }
        
        let requestBody: [String: Any] = [
                   "requests": [
                       [
                           "image": ["content": base64String],
                           "features": [
                                           ["type": "LABEL_DETECTION", "maxResults": 10],
                                           ["type": "OBJECT_LOCALIZATION", "maxResults": 5],
                                           ["type": "IMAGE_PROPERTIES", "maxResults": 5],
                                           ["type": "WEB_DETECTION", "maxResults": 5],
                                           ["type": "TEXT_DETECTION", "maxResults": 5],
                                           ["type": "LOGO_DETECTION", "maxResults": 5],
                                           ["type": "SAFE_SEARCH_DETECTION"],
                                           ["type": "CROP_HINTS"],
                                           ["type": "PRODUCT_SEARCH"],
                                           ["type": "LANDMARK_DETECTION"],
                                           ["type": "DOCUMENT_TEXT_DETECTION"]
                           ]
                       ]
                   ]
               ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        print("Request Body:", requestBody)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        print("✅ API Response Data: \(String(data: data, encoding: .utf8) ?? "No data")")
        var decodedResponse: GoogleVisionResponse?
            do {
                decodedResponse = try JSONDecoder().decode(GoogleVisionResponse.self, from: data)
                print(decodedResponse ?? "No valid response")
            } catch {
                print("JSON decoding error: \(error)")
                throw HTTPError.decodingFailed
            }

            guard let visionResponse = decodedResponse?.responses.first else {
                throw HTTPError.invalidResponse
            }

            return visionResponse
    }
    
    
}
enum HTTPError: Error {
    case invalidURL, invalidImageURL
    case invalidResponse
    case decodingFailed
}
