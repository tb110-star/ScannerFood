//
//  UrlApiRepository.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 18.02.25.
//

import Foundation

func uploadImageToImgBB(imageData: Data) async throws -> String {
    let apiKey = "b872e0496b5c520b9f7901615b7821ab"
    let url = URL(string: "https://api.imgbb.com/1/upload?key=\(apiKey)")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let base64Image = imageData.base64EncodedString()
    let bodyString = "image=\(base64Image)"
    request.httpBody = bodyString.data(using: .utf8)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    
    let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
    if let dataDict = jsonResponse?["data"] as? [String: Any], let imageUrl = dataDict["url"] as? String {
        print("✅ Image uploaded successfully: \(imageUrl)")
        return imageUrl
    } else {
        throw URLError(.cannotParseResponse)
    }
}
