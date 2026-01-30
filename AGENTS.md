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

## Changelog (MANDATORY)
**All important code changes** (fixes, additions, deletions, changes) have to written to CHANGELOG.md.
Changelog format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

**Before writing to CHANGELOG.md:**
1. Check for new release tags: `git tag --sort=-creatordate | head -1`
2. Release tags are prefixed with `v` (e.g., `v2.0.1`)
3. If a new tag exists that isn't in CHANGELOG.md, create a new version section with that tag's version and date, moving relevant [Unreleased] content under it

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
