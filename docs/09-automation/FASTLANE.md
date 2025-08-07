# 🚀 Fastlane Setup & Usage Guide

Complete documentation for setting up and using Fastlane for Flutter Deep Link Demo automation.

## 📋 Table of Contents
- [Prerequisites](#prerequisites)
- [Installation Process](#installation-process)
- [Fastlane Configuration](#fastlane-configuration)
- [Available Lanes](#available-lanes)
- [CLI Commands Reference](#cli-commands-reference)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

## 🔧 Prerequisites

### System Requirements
- **Windows 10/11** with PowerShell 5.1+
- **Flutter SDK** installed and in PATH
- **Git** for version control
- **Administrative privileges** for installations

### Required Software Stack
1. **Ruby** (for Fastlane)
2. **Java Development Kit (JDK) 17** (for Android builds)
3. **Fastlane** (automation platform)
4. **Bundler** (Ruby dependency management)

## 📦 Installation Process

### Step 1: Install Ruby on Windows

```powershell
# Install Ruby using winget
winget install RubyInstallerTeam.Ruby.3.3

# Verify installation
ruby --version
# Expected output: ruby 3.3.x

gem --version
# Expected output: 3.x.x
```

### Step 2: Install Java Development Kit (JDK) 17

```powershell
# Search for available JDK packages
winget search "OpenJDK"

# Install Microsoft OpenJDK 17
winget install Microsoft.OpenJDK.17

# Set environment variables for current session
$jdkPath = "C:\Program Files\Microsoft\jdk-17.0.16.8-hotspot"
$env:JAVA_HOME = $jdkPath
$env:PATH = "$env:PATH;$jdkPath\bin"

# Set permanent environment variables
[Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkPath, "User")
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$jdkPath\bin*") {
    $newPath = "$currentPath;$jdkPath\bin"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
}

# Verify installation
java -version
# Expected output: openjdk version "17.0.16"

javac -version
# Expected output: javac 17.0.16

keytool -help
# Should show keytool command help
```

### Step 3: Install Fastlane and Dependencies

```powershell
# Install Fastlane globally
gem install fastlane -NV

# Install Bundler for dependency management
gem install bundler

# Verify installations
fastlane --version
# Expected output: fastlane 2.228.0

bundle --version
# Expected output: Bundler version 2.x.x
```

### Step 4: Initialize Fastlane for Android

```powershell
# Navigate to project root
cd C:\path\to\your\flutter\project

# Navigate to android directory
cd android

# Initialize Fastlane (if not already done)
fastlane init

# Follow prompts:
# 1. Select "4. Manual setup - manually setup your project to automate your tasks"
# 2. Confirm package name: com.example.deepLinkDemo
# 3. Continue with setup
```

## 🛠️ Fastlane Configuration

### Directory Structure
```
android/
├── fastlane/
│   ├── Fastfile         # Main automation script
│   ├── Appfile          # App configuration
│   ├── Gemfile          # Ruby dependencies (optional)
│   ├── Gemfile.lock     # Locked dependencies (optional)
│   └── README.md        # Generated documentation
├── keystores/           # Auto-created by Fastlane
│   └── release.jks      # Release signing keystore
└── app/
    └── build.gradle.kts # Android build configuration
```

### Key Configuration Files

#### `android/fastlane/Fastfile`
- Contains all automation lanes (clean, build, test, etc.)
- Configured for Flutter-specific workflows
- Includes automatic keystore generation
- Web deployment preparation

#### `android/fastlane/Appfile`
- App identifier and configuration
- Environment variables for signing
- Platform-specific settings

## 🎯 Available Lanes
To get a list of all the available actions, open https://docs.fastlane.tools/actions

### Development Lanes

#### 🧹 Clean Project
```bash
fastlane android clean
```
**What it does:**
- Runs `flutter clean` to remove build artifacts
- Runs `flutter pub get` to refresh dependencies
- Runs `gradle clean` to clean Android build cache
- **Duration:** ~3-4 minutes (first run)

#### 🔍 Code Analysis
```bash
fastlane android analyze
```
**What it does:**
- Runs `flutter analyze --no-fatal-infos`
- Checks for code quality issues
- Reports warnings and errors
- **Duration:** ~30-60 seconds

#### 🧪 Run Tests
```bash
fastlane android test
```
**What it does:**
- Runs `flutter test --coverage`
- Generates test coverage reports
- Validates app functionality
- **Duration:** ~1-2 minutes

### Build Lanes

#### 🔨 Debug Build
```bash
fastlane android build_debug
```
**What it does:**
- Builds debug APK using `flutter build apk --debug`
- Reports file size and location
- No signing required
- **Duration:** ~3-5 minutes
- **Output:** `build/app/outputs/flutter-apk/app-debug.apk`

#### 🚀 Release Build
```bash
fastlane android build_release
```
**What it does:**
- Automatically creates release keystore if not exists
- Builds signed release APK using `flutter build apk --release`
- Reports file size and location
- **Duration:** ~4-6 minutes
- **Output:** `build/app/outputs/flutter-apk/app-release.apk`

#### 📦 Gradle Release Build
```bash
fastlane android build_gradle_release
```
**What it does:**
- Uses Gradle for building and signing
- More control over build process
- Includes ProGuard/R8 optimization
- **Duration:** ~5-7 minutes

### Web Deployment Lanes

#### 🌐 Web Build
```bash
fastlane android build_web
```
**What it does:**
- Builds optimized web release using `flutter build web --release`
- Calculates and reports build size
- **Duration:** ~2-3 minutes
- **Output:** `build/web/`

#### 🚀 Web Deployment Preparation
```bash
fastlane android deploy_web
```
**What it does:**
- Builds web release
- Copies deep linking verification files:
  - `assetlinks.json` for Android
  - `apple-app-site-association` for iOS
- Creates `.well-known` directory structure
- **Duration:** ~3-4 minutes
- **Ready for:** GitHub Pages, Firebase, Netlify deployment

### Utility Lanes

#### 🏗️ Complete CI/CD Pipeline
```bash
fastlane android ci
```
**What it does:**
- Runs clean → analyze → test → build_release
- Complete validation and build process
- **Duration:** ~10-15 minutes

#### 📊 Project Report
```bash
fastlane android report
```
**What it does:**
- Shows Flutter version information
- Reports project architecture details
- Displays build artifact sizes
- **Duration:** ~10-20 seconds

### Standard Android Lanes

#### 🧪 Android Tests
```bash
fastlane android test
```
**What it does:**
- Runs Android unit and instrumentation tests using Gradle
- Executes `gradle test` command
- **Duration:** ~3-5 minutes

#### 🚀 Beta Distribution
```bash
fastlane android beta
```
**What it does:**
- Builds and uploads beta release to Firebase App Distribution/Crashlytics
- Distributes to internal testers
- **Duration:** ~8-12 minutes
- **Requires:** Firebase configuration

#### 📱 Production Deploy
```bash
fastlane android deploy
```
**What it does:**
- Builds signed release APK/AAB
- Uploads to Google Play Console
- Submits for review/release
- **Duration:** ~10-15 minutes
- **Requires:** Play Console API setup

#### 🎬 Screenshot Generation
```bash
fastlane android build_for_screengrab
```
**What it does:**
- Builds debug APK optimized for automated screenshot generation
- Prepares for UI testing and store asset creation
- **Duration:** ~3-5 minutes

#### 🔧 Debug Build (Gradle)
```bash
fastlane android build_debug_gradle
```
**What it does:**
- Builds debug APK using `gradle assembleDebug`
- Quick development build for testing
- **Duration:** ~2-4 minutes

#### 🏭 Release Build
```bash
fastlane android release
```
**What it does:**
- Builds production-ready APK using `gradle assembleRelease`
- Includes signing and optimization
- **Duration:** ~5-8 minutes

#### 📸 Automated Screenshots
```bash
fastlane android screenshots
```
**What it does:**
- Captures automated screenshots for app store listings
- Runs across multiple device configurations
- **Duration:** ~15-25 minutes
- **Requires:** UI test setup

## 📚 CLI Commands Reference

### Project Setup Commands
```powershell
# Initial project setup
cd C:\path\to\flutter\project
cd android
fastlane init

# Verify Fastlane configuration
fastlane lanes
```

### Daily Development Commands
```powershell
# Start fresh development session
fastlane android clean

# Quick code check
fastlane android analyze

# Run tests before committing
fastlane android test

# Build for testing on device
fastlane android build_debug
```

### Release Preparation Commands
```powershell
# Complete validation pipeline
fastlane android ci

# Build production APK
fastlane android build_release

# Prepare web deployment
fastlane android deploy_web

# Generate project report
fastlane android report
```

### Keystore Management Commands
```powershell
# Check if keystore exists
ls android/keystores/

# View keystore information (after creation)
keytool -list -v -keystore android/keystores/release.jks -storepass 321123

# Backup keystore (IMPORTANT!)
cp android/keystores/release.jks android/keystores/release.jks.backup
```

### Troubleshooting Commands
```powershell
# Check Flutter doctor
flutter doctor

# Check Java installation
java -version
javac -version
keytool -help

# Check Ruby and gems
ruby --version
gem list fastlane
bundle --version

# Clean Gradle cache (if build issues)
cd android
./gradlew clean
./gradlew --stop

# Check Fastlane version
fastlane --version
```

## 🛠️ Troubleshooting

### Common Issues and Solutions

#### 1. "bundle exec" Warning
**Issue:** Fastlane suggests using `bundle exec`
```
fastlane detected a Gemfile in the current directory
However, it seems like you didn't use `bundle exec`
```

**Solutions:**
```powershell
# Option 1: Remove Gemfile to use global Fastlane
rm android/fastlane/Gemfile
rm android/fastlane/Gemfile.lock

# Option 2: Use bundle exec (more consistent)
bundle exec fastlane android clean

# Option 3: Install Fastlane globally
gem install fastlane --user-install
```

#### 2. Java/Keytool Not Found
**Issue:** `java: command not found` or `keytool: command not found`

**Solution:**
```powershell
# Verify JDK installation
winget list Microsoft.OpenJDK.17

# Set environment variables
$jdkPath = "C:\Program Files\Microsoft\jdk-17.0.16.8-hotspot"
$env:JAVA_HOME = $jdkPath
$env:PATH = "$env:PATH;$jdkPath\bin"

# Restart terminal and verify
java -version
```

#### 3. Flutter Not Found
**Issue:** `flutter: command not found`

**Solution:**
```powershell
# Check Flutter installation
flutter doctor

# Add Flutter to PATH if needed
$env:PATH = "$env:PATH;C:\flutter\bin"
```

#### 4. Gradle Build Failures
**Issue:** Kotlin daemon errors or build failures

**Solution:**
```powershell
# Stop Gradle daemon
cd android
./gradlew --stop

# Clean and rebuild
fastlane android clean
fastlane android build_debug
```

#### 5. Permission Issues
**Issue:** Cannot create keystore or write files

**Solution:**
```powershell
# Run as administrator or check permissions
# Ensure android/keystores/ directory is writable

# Create directory manually if needed
mkdir android/keystores
```

## 💡 Best Practices

### Development Workflow
```powershell
# Daily development start
fastlane android clean
fastlane android analyze

# Before committing code
fastlane android test
fastlane android build_debug

# Before releasing
fastlane android ci
fastlane android build_release
```

### Performance Tips
1. **Keep Gradle daemon running** between builds for faster execution
2. **Use debug builds** for development to save time
3. **Clean only when necessary** as it's time-consuming
4. **Run analysis frequently** to catch issues early

### Security Considerations
1. **Backup keystore file** - Store `android/keystores/release.jks` securely
2. **Never commit keystore** to version control
3. **Document keystore passwords** securely
4. **Use same keystore** for all releases of the same app

### CI/CD Integration
```yaml
# Example GitHub Actions workflow
name: Build and Test
on: [push, pull_request]
jobs:
  build:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - name: Install dependencies
        run: flutter pub get
      - name: Run Fastlane CI
        run: |
          cd android
          fastlane android ci
```

## 📊 Performance Metrics

### Typical Build Times
- **Clean:** 3-4 minutes (first run), 1-2 minutes (subsequent)
- **Analyze:** 30-60 seconds
- **Test:** 1-2 minutes
- **Debug Build:** 3-5 minutes (first), 1-2 minutes (subsequent)
- **Release Build:** 4-6 minutes
- **Web Build:** 2-3 minutes
- **Complete CI:** 10-15 minutes

### File Sizes (Approximate)
- **Debug APK:** 20-30 MB
- **Release APK:** 10-20 MB (with compression)
- **Web Build:** 5-15 MB (total)

## 🔗 Additional Resources

- [Fastlane Documentation](https://docs.fastlane.tools/)
- [Flutter Build Documentation](https://docs.flutter.dev/deployment)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [GitHub Actions for Flutter](https://docs.flutter.dev/deployment/cd)

---

## 🎯 Quick Reference Card

### Essential Commands
```powershell
# Setup (one-time)
winget install Microsoft.OpenJDK.17
gem install fastlane

# Daily use
fastlane android clean      # Clean project
fastlane android analyze    # Check code
fastlane android test       # Run tests
fastlane android build_debug # Debug build

# Release preparation
fastlane android ci         # Full pipeline
fastlane android build_release # Production APK
fastlane android deploy_web # Web deployment
```

### Key Paths
- **Fastfile:** `android/fastlane/Fastfile`
- **Keystore:** `android/keystores/release.jks`
- **Debug APK:** `build/app/outputs/flutter-apk/app-debug.apk`
- **Release APK:** `build/app/outputs/flutter-apk/app-release.apk`
- **Web Build:** `build/web/`

### Keystore Details
- **Path:** `android/keystores/release.jks`
- **Alias:** `release`
- **Passwords:** `321123` (both store and key)
- **Validity:** 25 years
- **Certificate:** Shell Company, Bengaluru, Karnataka, India

---

🎉 **You're now ready to use Fastlane for professional Flutter development automation!**
