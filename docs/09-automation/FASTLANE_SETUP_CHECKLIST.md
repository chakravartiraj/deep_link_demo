# 📋 Fastlane Setup Checklist

Use this checklist to ensure all dependencies are properly installed and configured.

## ✅ Prerequisites Checklist

### System Requirements
- [ ] Windows 10/11 with PowerShell 5.1+
- [ ] Flutter SDK installed and in PATH
- [ ] Git installed
- [ ] Administrative privileges available

### Installation Steps

#### 1. Java Development Kit (JDK) 17
```powershell
# Install JDK
winget install Microsoft.OpenJDK.17

# Verify installation
java -version        # Should show: openjdk version "17.0.16"
javac -version       # Should show: javac 17.0.16
keytool -help        # Should show keytool help

# Check environment variables
echo $env:JAVA_HOME  # Should show: C:\Program Files\Microsoft\jdk-17.0.16.8-hotspot
```
- [ ] JDK 17 installed
- [ ] JAVA_HOME environment variable set
- [ ] JDK bin directory in PATH
- [ ] java command working
- [ ] javac command working
- [ ] keytool command working

#### 2. Ruby Installation
```powershell
# Install Ruby
winget install RubyInstallerTeam.Ruby.3.3

# Verify installation
ruby --version       # Should show: ruby 3.3.x
gem --version        # Should show: 3.x.x
```
- [ ] Ruby 3.3.x installed
- [ ] RubyGems working
- [ ] Ruby bin directory in PATH

#### 3. Fastlane and Dependencies
```powershell
# Install Fastlane globally
gem install fastlane -NV

# Install Bundler
gem install bundler

# Verify installation
fastlane --version   # Should show: fastlane 2.228.0
bundle --version     # Should show: Bundler version 2.x.x
```
- [ ] Fastlane installed globally
- [ ] Bundler installed
- [ ] No "bundle exec" prefix required

#### 4. Flutter Verification
```powershell
# Check Flutter
flutter doctor       # Should show no critical issues
flutter --version    # Should show Flutter version
```
- [ ] Flutter SDK properly installed
- [ ] Flutter doctor shows healthy setup
- [ ] Flutter commands work from any directory

## 🎯 Fastlane Configuration Checklist

### Project Structure
```
android/
├── fastlane/
│   ├── Fastfile         ✅ Contains all automation lanes
│   ├── Appfile          ✅ App configuration
│   └── README.md        ✅ Generated documentation
├── keystores/           🔄 Created manually
│   └── release.jks      🔄 Generated release keystore
└── app/
    └── build.gradle.kts ✅ Android build configuration
```
- [ ] android/fastlane/ directory exists
- [ ] Fastfile contains Flutter-optimized lanes
- [ ] Appfile configured with correct package name
- [ ] No Gemfile in android/ directory (to avoid bundle exec warning)

### Lane Verification
Test each lane to ensure proper functionality:

```powershell
# Navigate to android directory
cd android

# Test basic lanes
fastlane android analyze        # ✅ Should complete in ~30-60 seconds
fastlane android clean          # ✅ Should complete in ~3-4 minutes
fastlane android build_debug    # ✅ Should complete in ~3-5 minutes
```
- [ ] `fastlane android analyze` works
- [ ] `fastlane android clean` works
- [ ] `fastlane android build_debug` works
- [ ] `fastlane android build_release` works (creates keystore automatically)
- [ ] `fastlane android deploy_web` works
- [ ] No "bundle exec" prefix required
- [ ] Build artifacts created in correct locations

## 🏗️ Build Output Verification

### Debug Build
```
Location: build/app/outputs/flutter-apk/app-debug.apk
Size: ~20-30 MB
Duration: ~3-5 minutes (first build)
```
- [ ] Debug APK created successfully
- [ ] File size within expected range
- [ ] APK installs on device/emulator

### Release Build
```
Location: build/app/outputs/flutter-apk/app-release.apk
Size: ~10-20 MB (compressed)
Duration: ~4-6 minutes
Keystore: android/keystores/release.jks (auto-created)
```
- [ ] Release APK created successfully
- [ ] Keystore auto-generated with correct settings
- [ ] File size smaller than debug (due to compression)
- [ ] APK signed and ready for distribution

### Web Build
```
Location: build/web/
Size: ~5-15 MB total
Duration: ~2-3 minutes
Deep Linking: .well-known/ directory with verification files
```
- [ ] Web build created successfully
- [ ] Deep linking verification files copied
- [ ] Ready for deployment to hosting service

## 🚨 Troubleshooting Checklist

### Common Issues
- [ ] If "java not found": Check JAVA_HOME and PATH
- [ ] If "ruby not found": Check Ruby installation and PATH
- [ ] If "bundle exec" warning: Remove Gemfile from android/
- [ ] If Gradle errors: Run `./gradlew --stop` then retry
- [ ] If permissions errors: Run as administrator or check file permissions

### Performance Issues
- [ ] First builds are slower (Gradle daemon setup)
- [ ] Subsequent builds should be faster
- [ ] Keep Gradle daemon running between builds
- [ ] Use debug builds for development

### Verification Commands
```powershell
# Quick system check
java -version && javac -version && ruby --version && fastlane --version && flutter --version

# Quick project check (from android/ directory)
fastlane android analyze
```
- [ ] All version commands return expected outputs
- [ ] No error messages in system check
- [ ] Analyze lane completes successfully

## 📊 Performance Benchmarks

Expected execution times on typical development machine:
- [ ] `analyze`: 30-60 seconds
- [ ] `clean`: 3-4 minutes (first run), 1-2 minutes (subsequent)
- [ ] `test`: 1-2 minutes
- [ ] `build_debug`: 3-5 minutes (first), 1-2 minutes (subsequent)
- [ ] `build_release`: 4-6 minutes
- [ ] `build_web`: 2-3 minutes
- [ ] `deploy_web`: 3-4 minutes
- [ ] `ci` (full pipeline): 10-15 minutes

## 🎉 Final Verification

Run this complete test to verify everything is working:

```powershell
# Complete workflow test
cd android
fastlane android clean
fastlane android analyze
fastlane android build_debug
fastlane android report
```

- [ ] All commands execute without errors
- [ ] Build artifacts created in correct locations
- [ ] No "bundle exec" prefix required
- [ ] Execution times within expected ranges
- [ ] Ready for daily development workflow

---

## 📚 Quick Reference

### Daily Commands
```bash
fastlane android clean          # Start fresh
fastlane android analyze        # Check code quality
fastlane android build_debug    # Development builds
```

### Release Commands
```bash
fastlane android ci             # Full validation
fastlane android build_release  # Production APK
fastlane android deploy_web     # Web deployment
```

### Keystore Info
- **Location:** `android/keystores/release.jks`
- **Alias:** `release`
- **Passwords:** `321123` (store and key)
- **Auto-created:** When first running `build_release`

---

✅ **Setup Complete!** You're ready for professional Flutter development with Fastlane automation.
