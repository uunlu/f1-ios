# F1App Architecture

## Overview
This app follows a clean architecture pattern with a **Composition Root** for dependency injection, ensuring loose coupling and high testability.

## Architecture Components

### 1. Composition Root - DependencyContainer
- **Location**: `F1App/Composition/DependencyContainer.swift`
- **Purpose**: Single point of truth for object graph creation
- **Responsibilities**:
  - Creates and manages all dependencies
  - Provides factory methods for ViewModels
  - Ensures proper dependency injection throughout the app

### 2. Coordinator Pattern - AppCoordinator
- **Location**: `F1App/Coordinator/AppCoordinator.swift`
- **Purpose**: Manages navigation and view creation
- **Responsibilities**:
  - Handles all navigation logic
  - Creates views through dependency container
  - Manages NavigationPath state
  - Decouples views from navigation decisions

### 3. ViewModels
- **Locations**: `F1App/ViewModels/`
- **Purpose**: Business logic and state management
- **Key Features**:
  - Receive dependencies through initializers
  - Navigation logic free
  - Easily testable with mock dependencies
  - Follow Single Responsibility Principle

### 4. Views
- **Locations**: `F1App/Views/`
- **Purpose**: UI presentation only
- **Key Features**:
  - No direct ViewModel creation
  - No navigation logic
  - Pure presentation components
  - Receive dependencies from coordinator

## Dependency Flow

```
F1AppApp
    ↓
DependencyContainer (Composition Root)
    ↓
AppCoordinator
    ↓
ViewModels (SeasonsViewModel, RaceWinnerViewModel)
    ↓
Services (SeasonLoader, RaceWinnerLoader, NetworkService)
```

## Benefits

### 1. **Testability**
- ViewModels can be easily unit tested with mock dependencies
- Services can be tested in isolation
- No tight coupling between components

### 2. **Modularity**
- Each component has a single responsibility
- Easy to replace implementations
- Clear separation of concerns

### 3. **Maintainability**
- Dependencies are explicit and managed in one place
- Easy to understand data flow
- Reduced coupling between components

### 4. **Scalability**
- Easy to add new features
- New dependencies can be easily injected
- Coordinator can handle complex navigation flows

## Usage Examples

### Adding a New ViewModel
1. Create the ViewModel with dependencies in constructor
2. Add factory method to `DependencyContainer`
3. Add view creation method to `AppCoordinator`
4. Views receive ViewModel through coordinator

### Testing
```swift
// Easy to test with mock dependencies
let mockSeasonLoader = MockSeasonLoader()
let viewModel = SeasonsViewModel(seasonLoader: mockSeasonLoader)
```

### Navigation
```swift
// Navigation is handled by coordinator
coordinator.showRaceWinners(for: season)
coordinator.goBack()
coordinator.popToRoot()
```

## File Structure
```
F1App/
├── Composition/
│   └── DependencyContainer.swift
├── Coordinator/
│   └── AppCoordinator.swift
├── ViewModels/
│   ├── SeasonsViewModel.swift
│   └── RaceWinnerViewModel.swift
├── Views/
│   ├── SeasonsView.swift
│   ├── RaceWinnerView.swift
│   └── SeasonDetailsView.swift
├── Services/
│   ├── NetworkService.swift
│   ├── SeasonLoader.swift
│   └── RaceWinnerLoader.swift
└── Models/
    ├── Season.swift
    └── RaceWinner.swift
```

This architecture ensures clean separation of concerns, high testability, and maintainable code that can easily scale as the app grows. 