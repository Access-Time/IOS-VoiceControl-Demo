# Voice Control Demo App

A demonstration iOS app designed to showcase common voice control accessibility issues. This cat browsing app looks functional for typical users but contains deliberate barriers for users relying on voice control.

## Purpose

This app serves as a training tool to:
- Identify voice control accessibility issues
- Demonstrate how seemingly normal UI patterns can be inaccessible
- Practice detecting and fixing voice control barriers

## App Features

### Browse Tab
Browse a grid of cat photos with shake-to-like functionality.

### Search Tab
Search for cat breeds with a searchable list.

### Swipe Tab
Tinder-style swipe interface for liking/passing on cat photos.

## Deliberate Accessibility Issues

### 1. **Login Screen** ([LoginView.swift](VoiceControlDemo/Views/LoginView.swift))
- **Unlabeled text fields** (lines 33-58) - No accessibility labels on username/password fields
- **Missing textContentType** - Password manager cannot auto-fill
- **Non-button control** (line 62) - Login uses Text with tap gesture instead of Button

### 2. **Browse View** ([BrowseView.swift](VoiceControlDemo/Views/BrowseView.swift))
- **Shake-to-like gesture** (lines 57-72) - Only way to like photos is shaking device (inaccessible via voice)
- **Unlabeled icon buttons** (lines 114, 135) - Close and zoom buttons have no accessibility labels
- **Icon confusion** (line 136) - Magnifying glass used for zoom (same as search icon)

### 3. **Search View** ([SearchView.swift](VoiceControlDemo/Views/SearchView.swift))
- **Mismatched label** (line 27) - Accessibility label says "Look for" but placeholder says "Search for"
- Voice users will say "Search for" but the system recognizes "Look for"
- **Icon reuse** (line 23) - Magnifying glass icon conflicts with zoom function

### 4. **Swipe View** ([SwipeView.swift](VoiceControlDemo/Views/SwipeView.swift))
- **Swipe-only interaction** (lines 36-78) - No button alternatives for like/dislike
- Completely inaccessible for voice control users
- Instructions tell users to swipe but provide no alternative method

### 5. **Time Challenge Modal** ([TimeChallengeModal.swift](VoiceControlDemo/Views/TimeChallengeModal.swift))
- **5-second timer** (line 11) - Extremely short time limit
- **Complex multi-step sequence** (lines 67-93) - Requires tapping 4 buttons in specific order
- Time pressure makes voice control nearly impossible

## Issue Summary

| Issue Type | Location | Impact |
|------------|----------|--------|
| Gesture-only (shake) | Browse detail view | High - No alternative for liking |
| Gesture-only (swipe) | Swipe tab | High - Core feature unusable |
| Unlabeled inputs | Login screen | High - Cannot target fields |
| Missing textContentType | Login screen | Medium - No auto-fill support |
| Non-button control | Login button | Medium - Unreliable activation |
| Unlabeled icon buttons | Browse detail view | Medium - Cannot identify buttons |
| Mismatched labels | Search input | Medium - Wrong voice command |
| Icon confusion | Search/Browse | Low - Ambiguous function |
| Time pressure | Challenge modal | High - Impossible timing |

## Running the App

1. Open `VoiceControlDemo.xcodeproj` in Xcode
2. Select a simulator or device
3. Build and run (⌘R)
4. Login with any username/password
5. Explore the three tabs

## Testing Voice Control

### On iOS Device
1. Go to Settings → Accessibility → Voice Control
2. Enable Voice Control
3. Try to interact with the app using only voice commands

### Commands to Try
- "Tap [element name]" - Tap a labeled element
- "Show names" - Display labels for all interactive elements
- "Show numbers" - Display numbers for tapping
- "Tap [field name]" - Focus a text field

### Expected Issues
- Cannot like photos in Browse tab (shake only)
- Cannot swipe in Swipe tab (gesture only)
- Cannot focus login fields (no labels)
- Cannot find close/zoom buttons (no labels)
- Search field responds to wrong command ("Look for" vs "Search for")
- Time challenge is too fast to complete

## Learning Exercise

Try to:
1. Navigate the entire app using only voice control
2. Identify which features are completely blocked
3. Document which issues are most severe
4. Propose fixes for each accessibility barrier

## Files Structure

```
VoiceControlDemo/
├── Models/
│   └── CatBreed.swift           # Data models
├── ViewModels/
│   └── CatViewModel.swift       # App logic
├── Views/
│   ├── LoginView.swift          # Login with issues
│   ├── MainTabView.swift        # Tab navigation
│   ├── BrowseView.swift         # Grid with shake-to-like
│   ├── SearchView.swift         # Search with wrong label
│   ├── SwipeView.swift          # Swipe-only interaction
│   └── TimeChallengeModal.swift # Time-pressured challenge
├── ContentView.swift            # Root view
└── VoiceControlDemoApp.swift    # App entry point
```

## Notes

This app intentionally violates accessibility best practices for educational purposes. Do not use these patterns in production apps.
