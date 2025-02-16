//
//  GoogleVisionModel.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 15.02.25.
//

import Foundation

struct GoogleVisionResponse: Codable {
    let responses: [VisionResponse]
}

struct VisionResponse: Codable {
    let labelAnnotations: [LabelAnnotation]?
    let imagePropertiesAnnotation: ImagePropertiesAnnotation?
    let webDetection: WebDetection?
    let localizedObjectAnnotations: [LocalizedObjectAnnotation]?
    let textAnnotations: [TextAnnotation]?
    let logoAnnotations: [LogoAnnotation]? //
    let safeSearchAnnotation: SafeSearchAnnotation? // can be not optional
    let cropHintsAnnotation: CropHintsAnnotation?
    let productSearchResults: ProductSearchResults?
    let landmarkAnnotations: [LandmarkAnnotation]?
    let fullTextAnnotation: FullTextAnnotation?
}

struct LabelAnnotation: Codable {
    let mid: String
    let description: String
    let score: Double
    let topicality: Double?
}

struct ImagePropertiesAnnotation: Codable {
    let dominantColors: DominantColors
}

struct DominantColors: Codable {
    let colors: [ColorInfo]
}

struct ColorInfo: Codable {
    let color: RGBColor
    let score: Double
    let pixelFraction: Double
}

struct RGBColor: Codable {
    let red: Int
    let green: Int
    let blue: Int
}

struct WebDetection: Codable {
    let webEntities: [WebEntity]?
    let fullMatchingImages: [WebImage]?
    let partialMatchingImages: [WebImage]?
    let pagesWithMatchingImages: [WebPage]?
    let visuallySimilarImages: [WebImage]?
    let bestGuessLabels: [BestGuessLabel]?
}

struct WebImage: Codable {
    let url: String
}

struct WebPage: Codable {
    let url: String
    let pageTitle: String?
}

struct BestGuessLabel: Codable {
    let label: String
    let languageCode: String
}

struct WebEntity: Codable {
    let entityId: String
    let score: Double
    let description: String
}

struct LocalizedObjectAnnotation: Codable {
    let mid: String
    let name: String
    let score: Double
    let boundingPoly: BoundingPoly?
}

struct BoundingPoly: Codable {
    let normalizedVertices: [Vertex]?
}

struct Vertex: Codable {
    let x: Double?
    let y: Double?
}

struct TextAnnotation: Codable {
    let locale: String?
    let description: String
}

struct LogoAnnotation: Codable {
    let mid: String
    let description: String
    let score: Double
    let topicality: Double?
}

struct SafeSearchAnnotation: Codable {
    let adult: SafeSearchLikelihood
    let medical: SafeSearchLikelihood
    let spoof: SafeSearchLikelihood
    let violence: SafeSearchLikelihood
    let racy: SafeSearchLikelihood
}
enum SafeSearchLikelihood: String, Codable {
    case veryUnlikely = "VERY_UNLIKELY"
    case unlikely = "UNLIKELY"
    case possible = "POSSIBLE"
    case likely = "LIKELY"
    case veryLikely = "VERY_LIKELY"
}
struct CropHintsAnnotation: Codable {
    let cropHints: [CropHint]
}

struct CropHint: Codable {
    let boundingPoly: BoundingPoly?
    let confidence: Double
    let importanceFraction: Double
}

struct ProductSearchResults: Codable {
    let indexTime: String?
    let products: [Product]
}

struct Product: Codable {
    let productCategory: String
    let score: Double
    let image: String?
}

struct LandmarkAnnotation: Codable {
    let mid: String
    let description: String
    let score: Double
    let locations: [Location]?
}

struct Location: Codable {
    let latLng: LatLng
}

struct LatLng: Codable {
    let latitude: Double
    let longitude: Double
}

struct FullTextAnnotation: Codable {
    let text: String
}
