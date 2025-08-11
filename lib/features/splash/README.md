# Splash Feature

This feature contains the splash screen functionality for the Deep Link Demo app.

## Structure

```
lib/features/splash/
├── pages/
│   └── splash_page.dart      # Main splash screen widget
├── splash_wrapper.dart       # Wrapper with platform routing
├── splash.dart              # Feature exports
├── screens.dart             # Legacy export file
└── README.md               # This documentation
```

## Files

### `pages/splash_page.dart`
A sophisticated Flutter splash page that matches the web `index.html` loading screen with:

**Features:**
- **Identical Visual Design**: Matches the web version exactly
- **Multi-layered Spinner**: Outer, main, and inner rotating rings
- **Floating Particles**: Animated particles floating from bottom to top
- **Progress Bar**: Animated progress with shimmer effect
- **Status Messages**: Sequential status updates during loading
- **Pulse Animation**: Breathing effect on the app title
- **Fade Transition**: Smooth fade-out when complete

**Animations:**
- **Spinner**: 3 concentric rotating rings at different speeds
- **Particles**: 9 floating particles with staggered timing
- **Progress**: Smooth progress bar with shimmer overlay
- **Pulse**: Title text breathing animation
- **Fade**: Smooth exit transition

**Timing:**
- **Duration**: 8 seconds maximum
- **Status Updates**: Every 1.6 seconds
- **Auto-complete**: Automatic or callback-triggered

### `splash_wrapper.dart`
A wrapper widget that:
- Shows the splash screen initially
- Transitions to the appropriate page after completion
- Handles platform-specific routing (web vs mobile)

### `screens.dart`
Barrel export file for easy importing of all screen widgets.

## Usage

### Basic Usage
```dart
import 'package:myapp/features/splash/splash.dart';

// Show splash page with callback
SplashPage(
  onComplete: () {
    // Navigate to next screen
  },
)
```

### With Wrapper (Recommended)
```dart
import 'package:myapp/features/splash/splash.dart';

// Automatic routing after splash
const SplashWrapper()
```

### Integration in Router
The splash page is integrated into the app router to show on initial load:

```dart
GoRoute(
  path: '/',
  builder: (context, state) => const SplashWrapper(),
),
```

## Design Specifications

### Colors
- **Background**: Linear gradient from `#667eea` to `#764ba2`
- **Spinners**: White with varying opacity (0.1 to 0.8)
- **Text**: White with 0.9 opacity, pulse to 0.6
- **Particles**: White with 0.3 opacity
- **Progress**: White gradient with shimmer effect

### Dimensions
- **Spinner Container**: 80x80px
- **Main Spinner**: 60x60px
- **Inner Spinner**: 40x40px
- **Progress Bar**: 240x4px
- **Particles**: 4x4px

### Animations
- **Spinner Rotation**: 1.2s linear infinite
- **Pulse**: 2s ease-in-out infinite (reverse)
- **Particles**: 6s ease-in-out infinite
- **Progress**: 8s ease-in-out
- **Fade Out**: 0.5s ease-out

## Platform Compatibility

- ✅ **iOS**: Native performance with smooth animations
- ✅ **Android**: Optimized for all Android versions
- ✅ **Web**: Matches HTML/CSS version exactly
- ✅ **Desktop**: Responsive design for larger screens

## Performance

- **Optimized Animations**: Using `AnimationController` with `vsync`
- **Memory Efficient**: Proper disposal of controllers
- **Smooth Rendering**: 60fps animations with `will-change` equivalent
- **Battery Friendly**: Efficient animation cycles

## Customization

The splash page can be customized by modifying:
- **Colors**: Change gradient and text colors
- **Timing**: Adjust animation durations
- **Messages**: Update status message array
- **Callback**: Custom completion handling
