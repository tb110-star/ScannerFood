# AI Food Scanner - Food Recognition Application (iOS)

<div align="center">
  <a>
    <img src="/1024.png" width="350">
  </a>
</div>

> **Note:**
> This app requires a valid network connection to process food recognition.  
> Minimal [iOS version](https://developer.apple.com/ios/) required to run the app: **18.0**

## Overview

AI Food Scanner is a Swift-based iOS application designed to provide a seamless food recognition experience. Users can capture a food image using their camera or select one from their gallery, process it using Google Vision API, and retrieve detailed food-related information, including nutrition facts and macro data.

This application integrates **Clarifai API** for food image recognition and **AI Nutritional Facts API** for nutritional data analysis.

## Index

- [Screenshots](#Screenshots)
- [Installation](#Installation)
- [Features](#Features)
- [iOS Technology Implementation](#iOS-Technology-Implementation)
- [Libraries](#Libraries)
- [Contact/Authors](#Contact/Authors)

## Screenshots

<p float="left">
  <img src="/C5B07C2B-904D-44D4-8168-35E37F5551BD.png" width="150" />
  <img src="/79AFE94C-FFF6-4870-8E25-DDF6A8163B32_1_105_c.jpeg" width="150" />
  <img src="/3B4D5A3E-6DF5-4B41-9E7A-37E7FFC95E98_1_105_c.jpeg" width="150" />
</p>

## Installation

1. Clone the AI Food Scanner app using **Git**:
   ```git
   git clone https://github.com/tb110-star/ScannerFood.git
   ```
2. Open the project in **Xcode**.
3. Build and run the application on a physical device or an iOS Simulator.

## Features

- **Image Capture & Selection:** Capture an image using the camera or pick an image from the gallery using `PhotosPicker`.
- **Food Recognition:** Process selected images using Clarifai API.
- **User Confirmation & Editing:** Users can confirm recognized ingredients, adjust estimated quantities, and manually edit food details before nutritional analysis.
- **Nutritional Analysis:** Retrieve calorie and macronutrient data from **AI Nutritional Facts API**.
- **User Authentication:** Secure login and account management via Firebase Authentication.
- **History Tracking:** Save scanned food items and track dietary intake over time via FireStore.

## iOS Technology Implementation

- **[MVVM Pattern](https://www.geeksforgeeks.org/introduction-to-model-view-view-model-mvvm/)**
- **[SwiftUI](https://developer.apple.com/xcode/swiftui/)**
- **[NavigationStack](https://developer.apple.com/documentation/swiftui/navigationstack/)**
- **[Firebase Authentication](https://firebase.google.com/docs/auth)** for user login
- **[FireStore](https://firebase.google.com/docs/firestore)** for history
## Libraries

This app utilizes various third-party libraries and technologies:

- **[SwiftUI Framework](https://developer.apple.com/documentation/swiftui/)** for UI development
- **[URLSession](https://developer.apple.com/documentation/foundation/urlsession)** for network requests
- **[Swift Package Manager](https://developer.apple.com/documentation/swift_packages/)** for dependency management



## Contact/Authors

[Tarlan Bakhtiari](https://github.com/tb110-star/ScannerFood)

