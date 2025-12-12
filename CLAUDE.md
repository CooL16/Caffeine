# Caffeine

macOS menu bar app that prevents your Mac from sleeping.

## Project Structure

```
src/
├── Caffeine.xcodeproj/          # Xcode project
└── Caffeine/
    ├── Classes/
    │   ├── CaffeineApp.swift        # App entry point (@main)
    │   ├── AppDelegate.swift        # NSApplicationDelegate
    │   ├── Models/
    │   │   └── SleepPreventionManager.swift  # IOKit sleep assertions
    │   ├── ViewModels/
    │   │   └── CaffeineViewModel.swift
    │   └── Views/
    │       ├── MenuBarController.swift   # Menu bar icon & menu
    │       └── PreferencesView.swift     # SwiftUI preferences window
    └── Ressources/
        ├── Assets.xcassets/
        ├── Info.plist
        ├── Caffeine.entitlements
        └── *.lproj/                 # Localizations (12 languages)
```

## Tech Stack

- Swift / SwiftUI
- Minimum deployment: macOS 11 (Big Sur)
- Sparkle framework for auto-updates (in `/sparkle`)
- IOKit for sleep prevention (`IOPMAssertionCreateWithDescription`)

## Architecture

MVVM pattern:
- **Model**: `SleepPreventionManager` (singleton) handles IOKit power assertions
- **ViewModel**: `CaffeineViewModel` manages app state and user preferences
- **Views**: SwiftUI `PreferencesView`, AppKit `MenuBarController`

## Localization

12 supported languages in `Ressources/*.lproj/Localizable.strings`:
- English, German, Spanish, French, Italian, Japanese, Korean, Dutch, Portuguese, Portuguese (Brazil), Russian, Chinese (Simplified)

When updating user-facing strings:
1. Update the source code
2. Update **all** `Localizable.strings` files (key must match exactly)

## Build

Open `src/Caffeine.xcodeproj` in Xcode and build.
