# 🚀 Fastlane Quick Command Reference

## 📋 Essential Setup Commands

```powershell
# One-time setup
winget install Microsoft.OpenJDK.17     # Install JDK 17
winget install RubyInstallerTeam.Ruby.3.3  # Install Ruby
gem install fastlane -NV                # Install Fastlane
gem install bundler                     # Install Bundler

# Project initialization (if needed)
cd android
fastlane init
```

## 🎯 Daily Development Commands

```powershell
# Navigate to android directory first
cd android

# Clean and reset project
fastlane android clean

# Code quality check
fastlane android analyze

# Run tests
fastlane android test

# Build for development
fastlane android build_debug

# Quick project status
fastlane android report
```

## 🚀 Release Commands

```powershell
# Complete validation pipeline
fastlane android ci

# Build production APK (auto-creates keystore)
fastlane android build_release

# Alternative Gradle-based release build
fastlane android build_gradle_release

# Build optimized web version
fastlane android build_web

# Prepare web deployment with deep linking
fastlane android deploy_web
```

## 🛠️ Troubleshooting Commands

```powershell
# System verification
java -version                           # Check Java
ruby --version                         # Check Ruby
fastlane --version                     # Check Fastlane
flutter doctor                         # Check Flutter

# Project verification
flutter clean && flutter pub get       # Reset Flutter
cd android && ./gradlew clean          # Reset Android
cd android && ./gradlew --stop         # Stop Gradle daemon

# Environment check
echo $env:JAVA_HOME                    # Check Java path
echo $env:PATH                         # Check system PATH
```

## 📊 Expected Output Locations

```
Debug APK:    build/app/outputs/flutter-apk/app-debug.apk
Release APK:  build/app/outputs/flutter-apk/app-release.apk
Web Build:    build/web/
Keystore:     android/keystores/release.jks
```

## ⏱️ Typical Execution Times

```
analyze:        30-60 seconds
clean:          3-4 minutes (first run)
test:           1-2 minutes
build_debug:    3-5 minutes (first run)
build_release:  4-6 minutes
build_web:      2-3 minutes
deploy_web:     3-4 minutes
ci (full):      10-15 minutes
```

## 🔑 Keystore Information

```
Auto-created on first release build:
Location:       android/keystores/release.jks
Alias:          release
Store Password: 321123
Key Password:   321123
Validity:       25 years
Certificate:    Shell Company, Bengaluru, Karnataka, India
```

## 🚨 Quick Fixes

```powershell
# "bundle exec" warning fix
rm android/fastlane/Gemfile          # Remove to use global Fastlane

# Java not found fix
$env:JAVA_HOME = "C:\Program Files\Microsoft\jdk-17.0.16.8-hotspot"
$env:PATH = "$env:PATH;$env:JAVA_HOME\bin"

# Gradle build issues fix
cd android && ./gradlew --stop && ./gradlew clean

# Permission issues fix
# Run PowerShell as Administrator

# Flutter issues fix
flutter clean && flutter pub get && flutter doctor
```

---

## 💡 Pro Tips

1. **Keep Gradle daemon running** between builds for faster execution
2. **Use debug builds** during development to save time
3. **Run analyze frequently** to catch issues early
4. **Backup keystore file** - it's critical for app releases
5. **Use ci lane before releases** for complete validation

## 📞 Need Help?

- Check `docs/09-automation/FASTLANE.md` for complete documentation
- Run `fastlane android --help` for lane-specific help
- Use `flutter doctor` to diagnose Flutter issues
- Check `scripts/FASTLANE_SETUP_CHECKLIST.md` for setup verification
