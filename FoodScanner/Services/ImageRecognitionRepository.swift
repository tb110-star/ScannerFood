
//
//  FoodScannerApp.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 04.02.25.
//
import Foundation

final class FoodRecognitionRepository {
    private let apiKey = "86232c0ec6msha0e6116dd4015d6p1801e2jsn8f9975c783b7"
    private let host = "food-item-recognition.p.rapidapi.com"
    private let baseURL = "https://food-item-recognition.p.rapidapi.com/"

    func recognizeFood(from imageUrl: String) async throws -> [FoodItem] {
        print("🌐 Preparing API request with image URL...") // Debugging print

        // Ensure the URL is valid
        guard let url = URL(string: baseURL) else {
            print("❌ Invalid API URL")
            throw URLError(.badURL)
        }

        // Creating the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.setValue(host, forHTTPHeaderField: "x-rapidapi-host")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // Creating body data
        let bodyString = "image_url=\(imageUrl)"
        guard let bodyData = bodyString.data(using: .utf8) else {
            print("❌ Failed to encode body data")
            throw URLError(.badURL)
        }
        request.httpBody = bodyData

        print("📤 Sending request to API with image URL: \(imageUrl)")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("📩 Response received: \(httpResponse.statusCode)")
                if !(200...299).contains(httpResponse.statusCode) {
                    print("❌ Server responded with error: \(httpResponse.statusCode)")
                    throw URLError(.badServerResponse)
                }
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Raw API Response: \(jsonString)")
            } else {
                print("❌ Failed to convert response to String")
            }

            print("📖 Decoding API response...")
            let decodedResponse = try JSONDecoder().decode([FoodItem].self, from: data)
            print("✅ Successfully decoded response!")

            return decodedResponse
        } catch {
            print("❌ Error fetching API response: \(error.localizedDescription)")
            throw error
        }
    }
    func uploadImageToImgBB(imageData: Data) async throws -> String {
        let apiKey = "b872e0496b5c520b9f7901615b7821ab"
        let url = URL(string: "https://api.imgbb.com/1/upload?key=\(apiKey)")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // اضافه کردن تصویر در قالب فرم-دیتا
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"\r\n\r\n".data(using: .utf8)!)
        body.append(imageData.base64EncodedData()) // **مقدار base64**
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        print("📤 Uploading image to ImgBB...")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("❌ Server responded with an error")
            throw URLError(.badServerResponse)
        }

        let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any]

        if let dataDict = jsonResponse?["data"] as? [String: Any],
           let imageUrl = dataDict["url"] as? String {
            print("✅ Image uploaded successfully: \(imageUrl)")
            return imageUrl
        } else {
            print("❌ Failed to extract image URL from response")
            throw URLError(.cannotParseResponse)
        }
    }
}
