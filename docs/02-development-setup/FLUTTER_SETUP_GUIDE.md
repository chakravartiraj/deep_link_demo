# Flutter Configuration Setup Guide

## Overview
This guide documents the complete setup and configuration of the Flutter development environment for this project, including keyring issue resolution and platform enablement.

## Table of Contents
1. [Keyring Issue Resolution](#keyring-issue-resolution)
2. [Platform Configuration](#platform-configuration)
3. [VS Code Integration](#vs-code-integration)
4. [Environment Setup](#environment-setup)
5. [Troubleshooting](#troubleshooting)

## Keyring Issue Resolution

### Problem
When opening this project in VS Code, the following error appeared:
```
An OS keyring couldn't be identified for storing the encryption related data in your current desktop environment.
```

### Root Cause
The Dart/Flutter VS Code extensions were attempting to use the OS keyring (Windows Credential Manager) to store:
- Analytics data
- Authentication tokens
- Crash reporting data
- Secure storage for development tools

### Solution Implemented
We implemented a multi-layered approach to prevent keyring access:

#### 1. Global Flutter/Dart Analytics Disable
```bash
flutter --disable-analytics
dart --disable-analytics
```

#### 2. Environment Variables
Set the following environment variables:
- `FLUTTER_SECURE_STORAGE_USE_PLAINTEXT=true`
- `DART_ANALYTICS_DISABLED=true`
- `FLUTTER_ANALYTICS_DISABLED=true`
- `NO_ANALYTICS=1`
- `DART_DISABLE_ANALYTICS=1`

#### 3. Configuration Files
- **`.flutter`** - Local Flutter configuration
- **`.env`** - Environment variables file
- **`.vscode/settings.json`** - VS Code workspace settings
- **`.vscode/launch.json`** - Debug configuration

## Platform Configuration

### Enabled Platforms
The following platforms have been enabled for this Flutter project:

| Platform | Status | Command to Run |
|----------|--------|----------------|
| Android | ✅ Enabled | `flutter run -d android` |
| iOS | ✅ Enabled | `flutter run -d ios` |
| Web | ✅ Enabled | `flutter run -d web-server` |
| Windows Desktop | ✅ Enabled | `flutter run -d windows` |

### Configuration Commands Used
```bash
flutter config --enable-android
flutter config --enable-ios
flutter config --enable-web
flutter config --enable-windows-desktop
```

### Verification
Check current configuration:
```bash
flutter config --list
flutter devices
```

## VS Code Integration

### Workspace Settings
The `.vscode/settings.json` file includes:
- Dart/Flutter extension configuration
- Analytics disabled
- Environment variables for terminal
- Development optimizations

### Launch Configuration
The `.vscode/launch.json` provides:
- Debug configuration for Flutter
- Release configuration for Flutter
- Environment variables for secure storage

## Environment Setup

### Launch Scripts
Two launch scripts are provided to ensure proper environment variables:

#### Windows Batch Script (`launch_vscode.bat`)
```batch
@echo off
set FLUTTER_SECURE_STORAGE_USE_PLAINTEXT=true
set DART_ANALYTICS_DISABLED=true
set FLUTTER_ANALYTICS_DISABLED=true
set NO_ANALYTICS=1
set DART_DISABLE_ANALYTICS=1
code "c:\Users\raja.chakraborty\StudioProjects\deep_link_demo"
```

#### PowerShell Script (`launch_vscode.ps1`)
```powershell
$env:FLUTTER_SECURE_STORAGE_USE_PLAINTEXT = "true"
$env:DART_ANALYTICS_DISABLED = "true"
$env:FLUTTER_ANALYTICS_DISABLED = "true"
$env:NO_ANALYTICS = "1"
$env:DART_DISABLE_ANALYTICS = "1"
code "c:\Users\raja.chakraborty\StudioProjects\deep_link_demo"
```

## Troubleshooting

### If Keyring Message Still Appears
1. Close VS Code completely
2. Run the PowerShell launcher: `.\launch_vscode.ps1`
3. Verify environment variables are set
4. Restart VS Code

### If Platform Not Available
1. Check Flutter configuration: `flutter config --list`
2. Verify platform is enabled
3. Check device availability: `flutter devices`
4. Ensure platform-specific requirements are met

### Common Issues
- **Web not working**: Ensure web support is enabled and Chrome is installed
- **Windows Desktop issues**: Verify Visual Studio Build Tools are installed
- **iOS issues**: Only available on macOS with Xcode
- **Android issues**: Ensure Android SDK and emulator are properly configured

## Files Modified/Created
- `.flutter` - Flutter configuration
- `.env` - Environment variables
- `.vscode/settings.json` - VS Code workspace settings
- `.vscode/launch.json` - Debug configuration
- `launch_vscode.bat` - Windows batch launcher
- `launch_vscode.ps1` - PowerShell launcher
- `KEYRING_FIX.md` - Quick fix guide
- `analysis_options_server.yaml` - Dart Analysis Server options

## Next Steps
1. Test the application on all enabled platforms
2. Configure platform-specific settings as needed
3. Set up CI/CD for multi-platform builds
4. Configure platform-specific app icons and metadata
