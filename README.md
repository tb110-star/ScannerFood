# AI Food Scanner - Food Recognition Application <br>(iOS)

<br>
<br>

<div align="center">
  <a >
    <img src="/pasted-image.jpeg">
  </a>
</div>

<br>
<br>

> [!Note]
> This app requires a valid network connection to process food recognition. <br>
> Minimal [iOS version](https://developer.apple.com/ios/) required to run the app: **17.0**


## Overview

AI Food Scanner is a Swift-based iOS application designed to provide a seamless food recognition experience. Our app enables users to capture a food image using their camera or select one from their gallery, process it using Google Vision API, and retrieve detailed food-related information.

This application integrates the **Google Vision API** for food image recognition and **Ninja API** for nutritional data analysis.

## Index

[Screenshots](#Screenshots)

[Installation](#Installation)

[Features](#Features)

[iOS Technology Implementation](#iOS-Technology-Implementation)

[Libraries](#Libraries)

[Backend Integration](#Backend-Integration)

[Contact/Authors](#Contact/Authors)


## Screenshots

<p float="left">
  <img src="/AI Food Scanner Images/homescreen.png" width="150" />
  <img src="/AI Food Scanner Images/scanning_screen.png" width="150" />
  <img src="/AI Food Scanner Images/results_screen.png" width="150" />
</p>


## Installation

1. Clone the AI Food Scanner app using **Git**

```git
  git clone https://https://github.com/tb110-star/ScannerFood.git
```
2. Open the project in **Xcode**.

3. Build and run the application on a physical device or an iOS Simulator.


## Features

- ***Image Capture & Selection:*** Capture an image using the camera or pick an image from the gallery using `PhotosPicker`.
- ***Food Recognition:*** Process selected images using Google Vision API.
- ***Nutritional Analysis:*** Retrieve calorie and macronutrient data from **Ninja API**.
- ***User Authentication:*** Secure login and account management via Firebase Authentication.
- ***History Tracking:*** Save scanned food items and track dietary intake over time.


## iOS Technology Implementation
- **[MVVM Pattern](https://www.geeksforgeeks.org/introduction-to-model-view-view-model-mvvm/)**
- **[SwiftUI](https://developer.apple.com/xcode/swiftui/)**
- **[Combine](https://developer.apple.com/documentation/combine/)**
- **[NavigationStack](https://developer.apple.com/documentation/swiftui/navigationstack/)**
- **[Firebase Authentication](https://firebase.google.com/docs/auth)** for user login


## Libraries
This app utilizes various third-party libraries and technologies:

- **[SwiftUI Framework](https://developer.apple.com/documentation/swiftui/)** for UI development
- **[URLSession](https://developer.apple.com/documentation/foundation/urlsession)** for network requests
- **[Swift Package Manager](https://developer.apple.com/documentation/swift_packages/)** for dependency management


## Backend Integration

AI Food Scanner leverages Firebase and external APIs for seamless backend functionality.

- **[Authentication](https://firebase.google.com/docs/auth)**
  - User registration and login powered by Firebase Authentication.
  - Secure authentication methods implemented for user convenience.

- **[Database](https://firebase.google.com/docs/firestore)**
  - Firebase Firestore is used for efficient storage of user data.
  - Scanned food history and user preferences are securely managed.

- **[Ninja API](https://api-ninjas.com/)**
  - Provides real-time nutritional analysis of scanned food items.

- **[Google Vision API](https://cloud.google.com/vision)**
  - for food recognition

These backend services ensure a reliable and secure foundation for AI Food Scanner, providing users with a smooth experience while interacting with the app.



## Contact/Authors

[Tarlan Bakhtiari](git clone https://https://github.com/tb110-star/ScannerFood.git)


