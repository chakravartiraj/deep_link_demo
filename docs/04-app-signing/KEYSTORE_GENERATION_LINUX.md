# Android Keystore Generation Guide - Linux

This guide provides step-by-step instructions for generating Android release keystores on Linux systems (Ubuntu, Debian, CentOS, Fedora, etc.).

## Prerequisites

### Required Software
- **Java Development Kit (JDK)**
- **Flutter SDK**
- **Android SDK** (optional, for Android Studio)

### Install Java

#### Ubuntu/### Verify Keystore
```bash
# Verify keystore contents and certificate details
keytool -list -v -keystore android/keystores/release.jks -storepass "321100"

# List keystore entries (summary)
keytool -list -keystore android/keystores/release.jks -storepass "321100"

# Check keystore validity
keytool -list -keystore android/keystores/release.jks

# Export certificate for verification
keytool -export -alias release -keystore android/keystores/release.jks -file release.crt -storepass "321100"

# View certificate details
keytool -printcert -file release.crt
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
```h
# Install OpenJDK (recommended)
sudo apt update
sudo apt install openjdk-17-jdk

# Or Oracle JDK
sudo apt install oracle-java17-installer

# Verify installation
java -version
javac -version
```

#### CentOS/RHEL/Fedora
```bash
# CentOS/RHEL
sudo yum install java-17-openjdk-devel

# Fedora
sudo dnf install java-17-openjdk-devel

# Verify installation
java -version
javac -version
```

#### Arch Linux
```bash
# Install OpenJDK
sudo pacman -S jdk17-openjdk

# Verify installation
java -version
```

### Install Android Studio (Optional)
```bash
# Download Android Studio
wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/*/android-studio-*-linux.tar.gz

# Extract and install
tar -xzf android-studio-*-linux.tar.gz
sudo mv android-studio /opt/
sudo ln -sf /opt/android-studio/bin/studio.sh /usr/local/bin/android-studio

# Add to PATH
echo 'export PATH=$PATH:/opt/android-studio/bin' >> ~/.bashrc
source ~/.bashrc
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

### Step 3: Set Proper Permissions
```bash
# Secure the keystore file
chmod 600 release.jks

# Make sure only owner can access keystores directory
chmod 700 ../keystores
```

## Method 2: Using Android Studio's Bundled Java

### Step 1: Locate Android Studio Java
```bash
# Common Android Studio locations
ANDROID_STUDIO_JAVA="/opt/android-studio/jbr/bin"
# Alternative locations
# $HOME/android-studio/jbr/bin
# /usr/local/android-studio/jbr/bin

# Verify location
find /opt -name "keytool" 2>/dev/null
find $HOME -name "keytool" 2>/dev/null
```

### Step 2: Generate Using Android Studio's Java
```bash
# Using Android Studio's keytool
/opt/android-studio/jbr/bin/keytool -genkey -v \
    -keystore android/keystores/release.jks \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -alias release
```

## Method 3: Automated Script

### Create Generation Script
Create `generate-keystore.sh`:

```bash
#!/bin/bash

# Android Keystore Generation Script for Linux
# Usage: ./generate-keystore.sh [keystore_name] [alias] [validity_days]

set -e  # Exit on any error

# Configuration
KEYSTORE_NAME="${1:-release}"
ALIAS="${2:-release}"
VALIDITY="${3:-10000}"
KEYSTORE_DIR="android/keystores"
KEYSTORE_FILE="$KEYSTORE_DIR/$KEYSTORE_NAME.jks"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Check if Java is installed
check_java() {
    if ! command -v java &> /dev/null; then
        log_error "Java is not installed or not in PATH"
        echo "Please install Java first:"
        echo "  Ubuntu/Debian: sudo apt install openjdk-17-jdk"
        echo "  CentOS/RHEL:   sudo yum install java-17-openjdk-devel"
        echo "  Fedora:        sudo dnf install java-17-openjdk-devel"
        exit 1
    fi
    
    if ! command -v keytool &> /dev/null; then
        log_error "keytool is not available"
        echo "Please install JDK (not just JRE)"
        exit 1
    fi
    
    log_info "Java version: $(java -version 2>&1 | head -n 1)"
}

# Create directory structure
setup_directories() {
    if [ ! -d "$KEYSTORE_DIR" ]; then
        mkdir -p "$KEYSTORE_DIR"
        log_info "Created directory: $KEYSTORE_DIR"
    fi
    
    # Set secure permissions
    chmod 700 "$KEYSTORE_DIR"
}

# Generate keystore
generate_keystore() {
    if [ -f "$KEYSTORE_FILE" ]; then
        log_warn "Keystore already exists: $KEYSTORE_FILE"
        read -p "Do you want to overwrite it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Aborted by user"
            exit 0
        fi
        rm "$KEYSTORE_FILE"
    fi
    
    log_info "Generating keystore: $KEYSTORE_FILE"
    log_info "Alias: $ALIAS"
    log_info "Validity: $VALIDITY days"
    
    keytool -genkey -v \
        -keystore "$KEYSTORE_FILE" \
        -keyalg RSA \
        -keysize 2048 \
        -validity "$VALIDITY" \
        -alias "$ALIAS"
    
    # Set secure permissions
    chmod 600 "$KEYSTORE_FILE"
    
    log_info "✅ Keystore generated successfully!"
    log_info "Location: $(pwd)/$KEYSTORE_FILE"
}

# Verify keystore
verify_keystore() {
    log_info "Verifying keystore..."
    keytool -list -v -keystore "$KEYSTORE_FILE" -alias "$ALIAS"
}

# Main execution
main() {
    log_info "Android Keystore Generator for Linux"
    log_info "======================================"
    
    check_java
    setup_directories
    generate_keystore
    
    echo
    log_info "Next steps:"
    echo "1. Update android/key.properties with your passwords"
    echo "2. Test with: flutter build apk --release"
    echo "3. Backup your keystore securely!"
}

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
```

## Configuration Setup

### Create key.properties
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
```

**Important Path Note**: The path `../keystores/release.jks` resolves from the `android/` directory to `android/keystores/release.jks`, not the project root. Ensure your keystore is placed in `android/keystores/` directory.

**Password Security**: In production, consider using environment variables or secure CI/CD secrets instead of hardcoded passwords.

### Update build.gradle.kts
Add to `android/app/build.gradle.kts`:

```kotlin
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
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
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

## Environment-Specific Configurations

### Development Environment
```bash
# Create development keystore
keytool -genkey -v \
    -keystore keystores/dev.jks \
    -keyalg RSA \
    -keysize 2048 \
    -validity 365 \
    -alias dev \
    -dname "CN=Dev Environment, OU=Development, O=MyCompany, L=DevCity, ST=DevState, C=US" \
    -storepass "dev123" \
    -keypass "dev123"
```

### Production Environment
```bash
# Create production keystore with strong security
keytool -genkey -v \
    -keystore keystores/production.jks \
    -keyalg RSA \
    -keysize 4096 \
    -validity 10000 \
    -alias production \
    -dname "CN=Production App, OU=Production, O=MyCompany Ltd, L=ProductionCity, ST=ProductionState, C=US"

# Note: Use interactive mode for production to enter secure passwords
```

## Testing and Verification

### Build Signed APK
```bash
# Clean and build
flutter clean
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### Verify Keystore
```bash
# List keystore contents
keytool -list -v -keystore keystores/release.jks -alias release

# Check keystore validity
keytool -list -keystore keystores/release.jks

# Export certificate for verification
keytool -export -alias release -keystore keystores/release.jks -file release.crt

# View certificate details
keytool -printcert -file release.crt
```

### Verify APK Signature
```bash
# Using jarsigner
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk

# Using apksigner (if available)
apksigner verify --verbose build/app/outputs/flutter-apk/app-release.apk
```

## Advanced Configurations

### Multiple Keystores Management
```bash
# Create keystores for different environments
for env in dev staging prod; do
    keytool -genkey -v \
        -keystore "keystores/${env}.jks" \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000 \
        -alias "$env" \
        -dname "CN=$env Environment, OU=Mobile Team, O=MyCompany, L=MyCity, ST=MyState, C=US" \
        -storepass "${env}123" \
        -keypass "${env}123"
done
```

### Certificate Fingerprints (for Firebase/Google APIs)
```bash
# Get SHA-1 fingerprint
keytool -list -v -keystore keystores/release.jks -alias release | grep SHA1

# Get SHA-256 fingerprint
keytool -list -v -keystore keystores/release.jks -alias release | grep SHA256

# All fingerprints
keytool -list -v -keystore keystores/release.jks -alias release
```

## Security and Backup

### Secure Permissions
```bash
# Set restrictive permissions
chmod 700 keystores/              # Only owner can access directory
chmod 600 keystores/*.jks         # Only owner can read keystore files
chmod 600 android/key.properties  # Only owner can read properties

# Verify permissions
ls -la keystores/
ls -la android/key.properties
```

### Backup Strategies
```bash
# Create encrypted backup
tar -czf keystores-backup-$(date +%Y%m%d).tar.gz keystores/
gpg -c keystores-backup-$(date +%Y%m%d).tar.gz

# Copy to secure location
cp keystores-backup-*.tar.gz.gpg /secure/backup/location/

# Cloud backup (encrypted)
rclone copy keystores-backup-*.tar.gz.gpg mycloud:/secure-backups/
```

### Environment Variables for CI/CD
```bash
# Set environment variables
export KEYSTORE_PASSWORD="your_secure_password"
export KEY_PASSWORD="your_secure_key_password"

# Use in key.properties
cat > android/key.properties << EOF
storeFile=../keystores/release.jks
storePassword=\${KEYSTORE_PASSWORD}
keyAlias=release
keyPassword=\${KEY_PASSWORD}
EOF
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

## Troubleshooting

### Common Issues

**"keytool: command not found"**
```bash
# Install JDK
sudo apt install openjdk-17-jdk  # Ubuntu/Debian
sudo yum install java-17-openjdk-devel  # CentOS/RHEL

# Or use full path
/usr/lib/jvm/java-17-openjdk-amd64/bin/keytool -version
```

**"Permission denied"**
```bash
# Fix permissions
chmod 700 keystores/
chmod 600 keystores/release.jks
chmod 600 android/key.properties
```

**"Keystore was tampered with, or password was incorrect"**
```bash
# Verify password
keytool -list -keystore keystores/release.jks

# Check file integrity
file keystores/release.jks
```

**Build fails with signing error**
```bash
# Check keystore path
ls -la keystores/release.jks

# Verify key.properties
cat android/key.properties

# Test with debug build first
flutter build apk --debug
```

## Automation and CI/CD

### GitHub Actions Example
```yaml
# .github/workflows/build.yml
name: Build Release APK
on:
  push:
    tags: ['v*']

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Java
      uses: actions/setup-java@v3
      with:
        distribution: 'openjdk'
        java-version: '17'
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.32.8'
    
    - name: Create key.properties
      run: |
        echo "storeFile=../keystores/release.jks" > android/key.properties
        echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" >> android/key.properties
        echo "keyAlias=release" >> android/key.properties
        echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
    
    - name: Decode keystore
      run: |
        echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > keystores/release.jks
    
    - name: Build APK
      run: flutter build apk --release
```

### Docker Support
```dockerfile
# Dockerfile for keystore generation
FROM openjdk:17-jdk-slim

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
ENV FLUTTER_VERSION=3.32.8
RUN wget -O flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$FLUTTER_VERSION-stable.tar.xz \
    && tar xf flutter.tar.xz \
    && mv flutter /opt/ \
    && rm flutter.tar.xz

ENV PATH="/opt/flutter/bin:${PATH}"

WORKDIR /workspace
COPY . .

RUN chmod +x generate-keystore.sh
CMD ["./generate-keystore.sh"]
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

# 6. Build signed release APK
flutter build apk --release
```

### Expected Results
- ✅ Keystore created: `android/keystores/release.jks`
- ✅ Configuration: `android/key.properties`
- ✅ Signed APK: `build/app/outputs/flutter-apk/app-release.apk`
- ✅ No password warnings (both passwords identical)
- ✅ PKCS12 keystore format
- ✅ 27+ years validity

## Quick Reference

### Essential Commands
```bash
# Generate keystore
keytool -genkey -v -keystore release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release

# List keystore
keytool -list -v -keystore release.jks

# Build signed APK
flutter build apk --release

# Verify signature
jarsigner -verify -verbose -certs app-release.apk
```

### File Structure
```
project/
├── android/
│   ├── keystores/
│   │   └── release.jks
│   ├── key.properties
│   └── app/build.gradle.kts
└── scripts/
    └── generate-keystore.sh
```

### Security Checklist
- [ ] Use strong passwords (12+ characters)
- [ ] Set restrictive file permissions (600 for files, 700 for directories)
- [ ] Never commit passwords to version control
- [ ] Create encrypted backups
- [ ] Use environment variables in CI/CD
- [ ] Document keystore details securely

---

**Important**: Always backup your keystore files securely. Losing them means you cannot update your published Android apps!
