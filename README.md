# F1 iOS App

## Overview
Formula 1 iOS application built with SwiftUI.

## Architecture
- MVVM + Coordinator pattern
- SwiftUI for UI
- Combine for reactive programming
- SwiftLint for code style
- Offline-first architecture

## Project Structure
- `Views/`: UI components
- `ViewModels/`: Business logic
- `Models/`: Data models
- `Services/`: API and data services
- `Components/`: Reusable UI elements
- `Coordinator/`: Navigation flow
- `Styles/`: UI styling
- `Utilities/`: Helper functions
- `Config/`: App configuration
- `Mocks/`: Test data
- `Decorators/`: View modifiers
- `Composition/`: View composition

## Features
- F1 Seasons information
- Season rounds' race winners
- Offline data persistence
- Dark/Light mode

## Technical Details
- Custom storage solution (File/UserDefaults/InMemory)
- URLSession for networking
- Combine for async operations
- SwiftUI previews
- Modular architecture
- Unit testing

## Requirements
- iOS 17.6+
- Xcode 16.1+
- Swift 5.9+

## Setup
1. Clone repository
2. Open F1App.xcodeproj
3. Build and run

## Testing
- Unit tests in F1AppTests
- SwiftLint for code quality
- GitHub Actions for CI