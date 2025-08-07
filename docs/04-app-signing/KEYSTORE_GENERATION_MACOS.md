# Android Keystore Generation Guide - macOS

This guide provides step-by-step instructions for generating Android release keystores on macOS systems.

## Prerequisites

### Required Software
- **Java Development Kit (JDK)**
- **Flutter SDK**
- **Android Studio** (recommended)
- **Xcode Command Line Tools**

### Install Prerequisites

#### Install Xcode Command Line Tools
```bash
xcode-select --install
```

#### Install Java via Homebrew (Recommended)
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install OpenJDK
brew install openjdk@17

# Link the JDK
sudo ln -sfn $(brew --prefix)/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk

# Add to PATH
echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Verify installation
java -version
javac -version
```

#### Alternative: Install Oracle JDK
```bash
# Download from Oracle website or use Homebrew cask
brew install --cask oracle-jdk
```

#### Install Android Studio
```bash
# Via Homebrew Cask
brew install --cask android-studio

# Or download from https://developer.android.com/studio
```

#### Install Flutter
```bash
# Via Homebrew
brew install flutter

# Or manual installation
# Download Flutter SDK and add to PATH
export PATH="$PATH:/path/to/flutter/bin"
```

## Method 1: Using System Java (Recommended)

### Step 1: Create Project Structure
```bash
# Navigate to your Flutter project
cd /path/to/your/flutter/project

# Create keystores directory inside android folder
mkdir -p android/keystores
cd android/keystores
```

### Step 2: Generate Keystore
```bash
# Interactive keystore generation
keytool -genkey -v \
    -keystore android/keystores/release.jks \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -alias release

# Non-interactive with pre-filled information (recommended for automation)
keytool -genkey -v \
    -keystore android/keystores/release.jks \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -alias release \
    -dname "CN=John Doe, OU=Development, O=Shell Company, L=Bengaluru, ST=Karnataka, C=India" \
    -storepass "321100" \
    -keypass "321100"
```

**Important Notes:**
- Both `storepass` and `keypass` must be identical for PKCS12 keystores (default format)
- Passwords must be at least 6 characters long (Java requirement)
- The `-dname` parameter allows non-interactive keystore generation
```

### Step 3: Set Proper Permissions
```bash
# Secure the keystore file
chmod 600 release.jks

# Secure the keystores directory
chmod 700 ../keystores
```

## Method 2: Using Android Studio's Bundled Java

### Step 1: Locate Android Studio's Java
```bash
# Common Android Studio locations on macOS
ANDROID_STUDIO_JAVA="/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin"

# Alternative locations
find /Applications -name "keytool" 2>/dev/null
find ~/Applications -name "keytool" 2>/dev/null
```

### Step 2: Generate Using Android Studio's Java
```bash
# Using Android Studio's keytool
"/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool" \
    -genkey -v \
    -keystore android/keystores/release.jks \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -alias release
```

## Method 3: Automated Script with macOS Integration

### Create Advanced Generation Script
Create `generate-keystore.sh`:

```bash
#!/bin/bash

# Android Keystore Generation Script for macOS
# Enhanced with macOS-specific features

set -e  # Exit on any error

# Configuration
KEYSTORE_NAME="${1:-release}"
ALIAS="${2:-release}"
VALIDITY="${3:-10000}"
KEYSTORE_DIR="android/keystores"
KEYSTORE_FILE="$KEYSTORE_DIR/$KEYSTORE_NAME.jks"

# macOS specific configurations
KEYCHAIN_SERVICE="android-keystore-$KEYSTORE_NAME"
USE_KEYCHAIN="${USE_KEYCHAIN:-false}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_debug() {
    echo -e "${BLUE}[DEBUG]${NC} $1"
}

# Show macOS notification
notify() {
    osascript -e "display notification \"$2\" with title \"Keystore Generator\" subtitle \"$1\""
}

# Check if Java is installed
check_java() {
    if ! command -v java &> /dev/null; then
        log_error "Java is not installed or not in PATH"
        echo "Please install Java first:"
        echo "  brew install openjdk@17"
        echo "  Or install Android Studio"
        exit 1
    fi
    
    if ! command -v keytool &> /dev/null; then
        log_error "keytool is not available"
        
        # Try to find keytool in common macOS locations
        KEYTOOL_PATHS=(
            "/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool"
            "/Library/Java/JavaVirtualMachines/*/Contents/Home/bin/keytool"
            "/opt/homebrew/opt/openjdk@17/bin/keytool"
            "/usr/local/opt/openjdk@17/bin/keytool"
        )
        
        for path in "${KEYTOOL_PATHS[@]}"; do
            if [ -f "$path" ]; then
                export PATH="$(dirname $path):$PATH"
                log_info "Found keytool at: $path"
                break
            fi
        done
        
        if ! command -v keytool &> /dev/null; then
            echo "Please install JDK or Android Studio"
            exit 1
        fi
    fi
    
    JAVA_VERSION=$(java -version 2>&1 | head -n 1)
    log_info "Java version: $JAVA_VERSION"
}

# Create directory structure
setup_directories() {
    if [ ! -d "$KEYSTORE_DIR" ]; then
        mkdir -p "$KEYSTORE_DIR"
        log_info "Created directory: $KEYSTORE_DIR"
    fi
    
    # Set secure permissions (macOS specific)
    chmod 700 "$KEYSTORE_DIR"
    
    # Set extended attributes for additional security
    xattr -w com.apple.metadata:_kTimeMachineNearest "$(date -Iseconds)" "$KEYSTORE_DIR" 2>/dev/null || true
}

# Generate secure password
generate_password() {
    # Use macOS security framework to generate secure password
    if command -v security &> /dev/null; then
        security add-generic-password -a "$USER" -s "$KEYCHAIN_SERVICE" -w
        log_info "Password stored in macOS Keychain"
        USE_KEYCHAIN=true
    else
        # Fallback to openssl
        openssl rand -base64 32 | tr -d "=+/" | cut -c1-20
    fi
}

# Get password from macOS Keychain
get_keychain_password() {
    if [ "$USE_KEYCHAIN" = true ]; then
        security find-generic-password -a "$USER" -s "$KEYCHAIN_SERVICE" -w 2>/dev/null || echo ""
    else
        echo ""
    fi
}

# Generate keystore
generate_keystore() {
    if [ -f "$KEYSTORE_FILE" ]; then
        log_warn "Keystore already exists: $KEYSTORE_FILE"
        
        # Use macOS dialog for confirmation
        if command -v osascript &> /dev/null; then
            RESPONSE=$(osascript -e 'display dialog "Keystore already exists. Do you want to overwrite it?" buttons {"Cancel", "Overwrite"} default button "Cancel"')
            if [[ ! "$RESPONSE" =~ "Overwrite" ]]; then
                log_info "Aborted by user"
                exit 0
            fi
        else
            read -p "Do you want to overwrite it? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                log_info "Aborted by user"
                exit 0
            fi
        fi
        
        rm "$KEYSTORE_FILE"
    fi
    
    log_info "Generating keystore: $KEYSTORE_FILE"
    log_info "Alias: $ALIAS"
    log_info "Validity: $VALIDITY days"
    
    # Start progress indicator
    notify "Starting" "Generating keystore..."
    
    keytool -genkey -v \
        -keystore "$KEYSTORE_FILE" \
        -keyalg RSA \
        -keysize 2048 \
        -validity "$VALIDITY" \
        -alias "$ALIAS"
    
    # Set secure permissions (macOS specific)
    chmod 600 "$KEYSTORE_FILE"
    
    # Add extended attributes
    xattr -w com.apple.metadata:kMDItemDescription "Android Release Keystore for $ALIAS" "$KEYSTORE_FILE" 2>/dev/null || true
    xattr -w com.apple.metadata:kMDItemKeywords "android,keystore,mobile,app,$ALIAS" "$KEYSTORE_FILE" 2>/dev/null || true
    
    # Completion notification
    notify "Success" "Keystore generated successfully!"
    
    log_info "✅ Keystore generated successfully!"
    log_info "Location: $(pwd)/$KEYSTORE_FILE"
    
    # Optional: Add to Spotlight comments for easier finding
    osascript -e "tell application \"Finder\" to set comment of (POSIX file \"$(pwd)/$KEYSTORE_FILE\" as alias) to \"Android keystore for $ALIAS app - Created $(date)\""
}

# Verify keystore
verify_keystore() {
    log_info "Verifying keystore..."
    keytool -list -v -keystore "$KEYSTORE_FILE" -alias "$ALIAS"
    
    # Get certificate fingerprints for Firebase/Google services
    log_info "Certificate fingerprints for Firebase/Google APIs:"
    keytool -list -v -keystore "$KEYSTORE_FILE" -alias "$ALIAS" | grep -E "(SHA1|SHA256)"
}

# macOS specific integrations
macos_integrations() {
    # Add to Quick Look
    if command -v qlmanage &> /dev/null; then
        qlmanage -r cache 2>/dev/null || true
    fi
    
    # Create desktop alias for easy access
    if [ -f "$KEYSTORE_FILE" ]; then
        osascript -e "tell application \"Finder\" to make alias file to (POSIX file \"$(pwd)/$KEYSTORE_FILE\" as alias) at desktop"
    fi
    
    # Open containing folder
    open "$KEYSTORE_DIR"
}

# Main execution
main() {
    log_info "🍎 Android Keystore Generator for macOS"
    log_info "======================================"
    
    check_java
    setup_directories
    generate_keystore
    verify_keystore
    
    # Ask if user wants macOS integrations
    if command -v osascript &> /dev/null; then
        RESPONSE=$(osascript -e 'display dialog "Enable macOS integrations (Spotlight indexing, desktop alias)?" buttons {"Skip", "Enable"} default button "Enable"')
        if [[ "$RESPONSE" =~ "Enable" ]]; then
            macos_integrations
        fi
    fi
    
    echo
    log_info "Next steps:"
    echo "1. Update android/key.properties with your passwords"
    echo "2. Test with: flutter build apk --release"
    echo "3. Backup your keystore securely!"
    echo "4. Note: Passwords can be stored in macOS Keychain for security"
    
    notify "Complete" "Keystore setup finished!"
}

# Cleanup function
cleanup() {
    log_info "Cleaning up temporary files..."
    # Add any cleanup code here
}

# Set trap for cleanup
trap cleanup EXIT

# Run main function
main "$@"
```

### Make Script Executable and Run
```bash
# Make executable
chmod +x generate-keystore.sh

# Run with defaults
./generate-keystore.sh

# Run with custom parameters
./generate-keystore.sh myapp-release myapp 7300

# Run with environment variable for Keychain integration
USE_KEYCHAIN=true ./generate-keystore.sh
```

## Configuration Setup

### Create key.properties with macOS Security
```bash
# Create configuration file
cat > android/key.properties << EOF
storeFile=../keystores/release.jks
storePassword=321100
keyAlias=release
keyPassword=321100
EOF

# Secure the properties file
chmod 600 android/key.properties

# Optional: Store passwords in macOS Keychain
security add-generic-password -a "$USER" -s "android-keystore-password" -w "321100"
security add-generic-password -a "$USER" -s "android-key-password" -w "321100"
```

**Important Path Note**: The path `../keystores/release.jks` resolves from the `android/` directory to `android/keystores/release.jks`, not the project root. Ensure your keystore is placed in `android/keystores/` directory.

**Password Security**: In production, consider using environment variables or secure CI/CD secrets instead of hardcoded passwords.

### Enhanced build.gradle.kts for macOS
Add to `android/app/build.gradle.kts`:

```kotlin
import java.util.Properties
import java.io.IOException

// Function to get password from macOS Keychain
fun getKeychainPassword(service: String): String? {
    return try {
        val process = ProcessBuilder("security", "find-generic-password", "-a", System.getProperty("user.name"), "-s", service, "-w")
            .start()
        val result = process.inputStream.bufferedReader().readText().trim()
        if (process.waitFor() == 0) result else null
    } catch (e: Exception) {
        null
    }
}

// Load keystore properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    // ... existing configuration ...
    
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String? 
                    ?: getKeychainPassword("android-key-password")
                    ?: throw IOException("Key password not found")
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String?
                    ?: getKeychainPassword("android-keystore-password")
                    ?: throw IOException("Keystore password not found")
            }
        }
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
}
```

## macOS-Specific Features

### Keychain Integration
```bash
# Store passwords in Keychain
security add-generic-password -a "$USER" -s "android-keystore" -w "your_keystore_password"
security add-generic-password -a "$USER" -s "android-key" -w "your_key_password"

# Retrieve passwords from Keychain
KEYSTORE_PASSWORD=$(security find-generic-password -a "$USER" -s "android-keystore" -w)
KEY_PASSWORD=$(security find-generic-password -a "$USER" -s "android-key" -w)

# Use in build process
export KEYSTORE_PASSWORD
export KEY_PASSWORD
```

### Spotlight Integration
```bash
# Add metadata for Spotlight search
xattr -w com.apple.metadata:kMDItemDescription "Android Release Keystore" keystores/release.jks
xattr -w com.apple.metadata:kMDItemKeywords "android,keystore,mobile,release" keystores/release.jks

# Set Finder comments
osascript -e 'tell application "Finder" to set comment of (POSIX file "'$(pwd)'/keystores/release.jks" as alias) to "Android release keystore - Handle with care!"'
```

### File Associations and Quick Look
```bash
# Enable Quick Look for .jks files (if desired)
# Create ~/Library/QuickLook/JKSQuickLook.qlgenerator (advanced)

# Open keystore directory in Finder
open keystores/

# Reveal keystore in Finder
open -R keystores/release.jks
```

## Testing and Verification

### Build Signed APK
```bash
# Clean and build
flutter clean
flutter build apk --release

# Build App Bundle
flutter build appbundle --release

# Build for iOS (bonus)
flutter build ios --release
```

### Verify Keystore on macOS
```bash
# Verify keystore contents and certificate details
keytool -list -v -keystore android/keystores/release.jks -storepass "321100"

# List keystore entries (summary)
keytool -list -keystore android/keystores/release.jks -storepass "321100"

# Check keystore with specific Java version
/usr/libexec/java_home -v 17 --exec keytool -list -v -keystore android/keystores/release.jks -storepass "321100"

# Export certificate
keytool -export -alias release -keystore android/keystores/release.jks -file release.crt -storepass "321100"

# View certificate in Keychain Access
open -a "Keychain Access" release.crt
```

**Expected Output Example:**
```
Keystore type: PKCS12
Your keystore contains 1 entry

Alias name: release
Creation date: Aug 7, 2025
Entry type: PrivateKeyEntry
Certificate chain length: 1
Certificate[1]:
Owner: CN=John Doe, OU=Development, O=Shell Company, L=Bengaluru, ST=Karnataka, C=India
Issuer: CN=John Doe, OU=Development, O=Shell Company, L=Bengaluru, ST=Karnataka, C=India
Serial number: [unique_number]
Valid from: [start_date] until: [end_date]
Certificate fingerprints:
         SHA1: [fingerprint]
         SHA256: [fingerprint]
```

### Verify APK Signature
```bash
# Using jarsigner
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk

# Using Android SDK tools (if available)
$ANDROID_HOME/build-tools/*/apksigner verify --verbose build/app/outputs/flutter-apk/app-release.apk
```

## Advanced macOS Configurations

### Multiple Java Versions Management
```bash
# List installed Java versions
/usr/libexec/java_home -V

# Set specific Java version
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# Use specific Java version for keytool
$(/usr/libexec/java_home -v 17)/bin/keytool -version

# Create alias for easy switching
alias java17='export JAVA_HOME=$(/usr/libexec/java_home -v 17)'
alias java11='export JAVA_HOME=$(/usr/libexec/java_home -v 11)'
```

### Automated Backup with Time Machine
```bash
# Create backup script for Time Machine
cat > backup-keystore.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="$HOME/Documents/Keystores-Backup"
mkdir -p "$BACKUP_DIR"

# Copy keystores with timestamp
cp -R keystores/ "$BACKUP_DIR/keystores-$(date +%Y%m%d-%H%M%S)/"

# Create encrypted archive
tar -czf "$BACKUP_DIR/keystores-$(date +%Y%m%d).tar.gz" keystores/
gpg -c "$BACKUP_DIR/keystores-$(date +%Y%m%d).tar.gz"

echo "Backup created: $BACKUP_DIR"
EOF

chmod +x backup-keystore.sh
```

### Launch Agent for Automated Tasks
Create `~/Library/LaunchAgents/com.yourcompany.keystore.backup.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.yourcompany.keystore.backup</string>
    <key>ProgramArguments</key>
    <array>
        <string>/path/to/your/backup-keystore.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>2</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
</dict>
</plist>
```

Load the launch agent:
```bash
launchctl load ~/Library/LaunchAgents/com.yourcompany.keystore.backup.plist
```

## Security and Compliance

### macOS Security Features
```bash
# Enable FileVault (full disk encryption)
sudo fdesetup enable

# Set up secure folder with encryption
hdiutil create -size 100m -fs HFS+J -encryption AES-256 -volname "Keystores" keystores-secure.dmg

# Mount and use encrypted volume
hdiutil attach keystores-secure.dmg
cp keystores/*.jks /Volumes/Keystores/
```

### Privacy and Permissions
```bash
# Check file permissions
ls -la@ keystores/  # @ shows extended attributes

# Remove quarantine attribute if needed
xattr -d com.apple.quarantine keystores/release.jks

# Set immutable flag for protection
chflags uchg keystores/release.jks  # Makes file unchangeable
chflags nouchg keystores/release.jks  # Removes protection
```

## Path Resolution and Common Issues

### Understanding Relative Paths
The most common confusion is with the `storeFile` path in `key.properties`:

```properties
storeFile=../keystores/release.jks
```

**Path Resolution Explanation:**
- The `key.properties` file is located in `android/` directory
- The path `../keystores/release.jks` means:
  - `..` = Go up one directory level (from `android/` to project root)
  - `keystores/` = Enter the keystores directory  
  - `release.jks` = The keystore file
- **Final resolved path**: `android/keystores/release.jks`

**❌ Common Mistake**: Placing keystore in project root `keystores/` directory
**✅ Correct Location**: Place keystore in `android/keystores/` directory

### File Structure
```
your-flutter-project/
├── android/
│   ├── keystores/          ← Keystore goes here
│   │   └── release.jks     ← Your keystore file
│   ├── key.properties      ← Contains storeFile=../keystores/release.jks
│   └── app/
│       └── build.gradle.kts
└── lib/
    └── main.dart
```

## Troubleshooting macOS-Specific Issues

### Common macOS Issues

**"Java not found" despite installation**
```bash
# Check Java installations
/usr/libexec/java_home -V

# Set JAVA_HOME explicitly
export JAVA_HOME=$(/usr/libexec/java_home)
echo 'export JAVA_HOME=$(/usr/libexec/java_home)' >> ~/.zshrc
```

**"keytool: command not found" with Android Studio**
```bash
# Add Android Studio's Java to PATH
export PATH="/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin:$PATH"

# Make permanent
echo 'export PATH="/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin:$PATH"' >> ~/.zshrc
```

**Permission denied errors**
```bash
# Fix ownership
sudo chown -R $USER:staff keystores/

# Fix permissions
chmod 700 keystores/
chmod 600 keystores/*.jks
```

**Gatekeeper blocking execution**
```bash
# Allow unsigned scripts to run
xattr -dr com.apple.quarantine generate-keystore.sh

# Or use spctl
spctl --add generate-keystore.sh
```

**M1/M2 Mac Compatibility**
```bash
# Install Java for Apple Silicon
arch -arm64 brew install openjdk@17

# Force Intel compatibility if needed
arch -x86_64 brew install openjdk@17

# Check architecture
uname -m  # arm64 for M1/M2, x86_64 for Intel
```

## CI/CD Integration for macOS

### GitHub Actions with macOS Runner
```yaml
# .github/workflows/build-macos.yml
name: Build on macOS
on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Java
      uses: actions/setup-java@v3
      with:
        distribution: 'adopt'
        java-version: '17'
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.32.8'
    
    - name: Decode keystore
      run: |
        echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > keystores/release.jks
    
    - name: Create key.properties
      run: |
        echo "storeFile=../keystores/release.jks" > android/key.properties
        echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" >> android/key.properties
        echo "keyAlias=release" >> android/key.properties
        echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
    
    - name: Build APK
      run: flutter build apk --release
    
    - name: Build iOS (bonus)
      run: |
        flutter build ios --release --no-codesign
        cd ios && xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release archive
```

### Fastlane Integration
```ruby
# ios/fastlane/Fastfile
platform :ios do
  desc "Build and deploy iOS app"
  lane :release do
    setup_ci if ENV['CI']
    
    # iOS specific tasks
    match(type: "appstore")
    gym(scheme: "Runner")
    upload_to_app_store
  end
end

platform :android do
  desc "Build and deploy Android app"
  lane :release do
    # Android specific tasks using the generated keystore
    gradle(task: "clean bundleRelease")
    upload_to_play_store
  end
end
```

---

## Complete Example - Working Setup

### Step-by-Step Working Example
Here's the exact sequence that successfully generates a signed APK:

```bash
# 1. Create keystores directory
mkdir -p android/keystores

# 2. Generate keystore with pre-filled information
keytool -genkey -v \
    -keystore android/keystores/release.jks \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -alias release \
    -dname "CN=John Doe, OU=Development, O=Shell Company, L=Bengaluru, ST=Karnataka, C=India" \
    -storepass "321100" \
    -keypass "321100"

# 3. Verify keystore was created successfully
keytool -list -v -keystore android/keystores/release.jks -storepass "321100"

# 4. Create key.properties file
cat > android/key.properties << EOF
storeFile=../keystores/release.jks
storePassword=321100
keyAlias=release
keyPassword=321100
EOF

# 5. Secure the properties file
chmod 600 android/key.properties

# 6. Optional: Store passwords in macOS Keychain
security add-generic-password -a "$USER" -s "android-keystore-password" -w "321100"

# 7. Build signed release APK
flutter build apk --release

# 8. Build iOS (bonus for macOS)
flutter build ios --release --no-codesign
```

### Expected Results
- ✅ Keystore created: `android/keystores/release.jks`
- ✅ Configuration: `android/key.properties`
- ✅ Signed APK: `build/app/outputs/flutter-apk/app-release.apk`
- ✅ No password warnings (both passwords identical)
- ✅ PKCS12 keystore format
- ✅ 27+ years validity
- ✅ Passwords stored in macOS Keychain (optional)

## Quick Reference

### Essential Commands
```bash
# Generate keystore
keytool -genkey -v -keystore release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release

# Use specific Java version
$(/usr/libexec/java_home -v 17)/bin/keytool -list -v -keystore release.jks

# Build signed APK
flutter build apk --release

# Store password in Keychain
security add-generic-password -a "$USER" -s "keystore-password" -w "your_password"

# Retrieve from Keychain
security find-generic-password -a "$USER" -s "keystore-password" -w
```

### macOS File Locations
```
~/Library/Developer/Xcode/UserData/KeyBindings/
/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/
/usr/libexec/java_home
~/Library/Keychains/
android/keystores/release.jks  ← Your keystore location
android/key.properties         ← Configuration file
```

### Security Best Practices for macOS
- Use FileVault for full disk encryption
- Store passwords in macOS Keychain
- Enable automatic security updates
- Use secure folders or encrypted disk images
- Set up Time Machine for automated backups
- Use proper file permissions (600 for keystores)

---

**macOS-Specific Advantages:**
- Integrated Keychain for secure password storage
- Spotlight search for keystore files
- Time Machine automatic backups
- Built-in encryption and security features
- Seamless iOS and Android development on same machine

**Important**: Always backup your keystore files securely using Time Machine or encrypted cloud storage. Losing them means you cannot update your published Android apps!
