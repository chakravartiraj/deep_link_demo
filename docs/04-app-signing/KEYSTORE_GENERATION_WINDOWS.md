# Android Keystore Generation Guide - Windows

This guide provides step-by-step instructions for generating Android release keystores on Windows systems.

## Prerequisites

### Required Software
- **Java Development Kit (JDK)** - Availab### Verify Signature
```powershell
# Verify keystore contents and certificate details
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -list -v -keystore android\keystores\release.jks -storepass "321100"

# List keystore entries (summary)
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -list -keystore android\keystores\release.jks -storepass "321100"

# Verify APK signature after building
& "C:\Program Files\Android\Android Studio\jbr\bin\jarsigner.exe" -verify -verbose -certs build\app\outputs\flutter-apk\app-release.apk
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
```gh:
  - Android Studio (recommended)
  - Oracle JDK
  - OpenJDK
- **Flutter SDK** - For building Android apps
- **Android SDK** - Usually bundled with Android Studio

### Verify Java Installation

```powershell
# Check if Java is available
java -version

# If not found, use Android Studio's bundled Java
& "C:\Program Files\Android\Android Studio\jbr\bin\java.exe" -version
```

## Method 1: Using Android Studio's Bundled Java (Recommended)

### Step 1: Locate Android Studio's Java
Android Studio includes a bundled JDK. Common locations:
- `C:\Program Files\Android\Android Studio\jbr\bin\`
- `C:\Users\{USERNAME}\AppData\Local\Android\Sdk\java\`

### Step 2: Create Keystores Directory
```powershell
# Navigate to your Flutter project
cd C:\path\to\your\flutter\project

# Create keystores directory inside android folder
mkdir android\keystores
```

### Step 3: Generate Keystore
```powershell
# Using Android Studio's keytool with pre-filled information
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore android\keystores\release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release

# Non-interactive with pre-filled information (recommended for automation)
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore android\keystores\release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release -dname "CN=John Doe, OU=Development, O=Shell Company, L=Bengaluru, ST=Karnataka, C=India" -storepass "321100" -keypass "321100"

# Alternative with custom alias
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore android\keystores\myapp-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias myapp -dname "CN=Your Name, OU=Your Unit, O=Your Company, L=Your City, ST=Your State, C=Your Country" -storepass "your_password" -keypass "your_password"
```

**Important Notes:**
- Both `storepass` and `keypass` must be identical for PKCS12 keystores (default format)
- Passwords must be at least 6 characters long (Java requirement)
- The `-dname` parameter allows non-interactive keystore generation

### Step 4: Interactive Prompts
The keytool will prompt for:

```
Enter keystore password: [ENTER_STRONG_PASSWORD]
Re-enter new password: [CONFIRM_PASSWORD]

What is your first and last name?
  [Unknown]: John Doe

What is the name of your organizational unit?
  [Unknown]: Development Team

What is the name of your organization?
  [Unknown]: Your Company Name

What is the name of your City or Locality?
  [Unknown]: Your City

What is the name of your State or Province?
  [Unknown]: Your State

What is the two-letter country code for this unit?
  [Unknown]: US

Is CN=John Doe, OU=Development Team, O=Your Company Name, L=Your City, ST=Your State, C=US correct?
  [no]: yes
```

## Method 2: Using System Java (If Available)

### Step 1: Verify Java Installation
```powershell
java -version
javac -version
```

### Step 2: Generate Keystore
```powershell
keytool -genkey -v -keystore android\keystores\release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release
```
- or,
```powershell
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore keystores/release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release -dname "CN=John Doe, OU=Development, O=Shell Company, L=Bengaluru, ST=Karnataka, C=India" -storepass "321123" -keypass "321123"
```

## Method 3: Using PowerShell with Full Paths

### Create PowerShell Script
Create `generate-keystore.ps1`:

```powershell
# PowerShell script for keystore generation
param(
    [string]$KeystoreName = "release",
    [string]$Alias = "release",
    [int]$ValidityDays = 10000
)

# Set paths
$ProjectRoot = Get-Location
$KeystoresDir = Join-Path $ProjectRoot "android\keystores"
$KeystoreFile = Join-Path $KeystoresDir "$KeystoreName.jks"

# Create keystores directory if it doesn't exist
if (!(Test-Path $KeystoresDir)) {
    New-Item -ItemType Directory -Path $KeystoresDir
    Write-Host "Created keystores directory: $KeystoresDir"
}

# Locate Java keytool
$JavaPaths = @(
    "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe",
    "C:\Program Files\Java\jdk*\bin\keytool.exe",
    "keytool.exe"
)

$KeytoolPath = $null
foreach ($Path in $JavaPaths) {
    if (Test-Path $Path -ErrorAction SilentlyContinue) {
        $KeytoolPath = $Path
        break
    }
    # Handle wildcard paths
    $ExpandedPaths = Get-ChildItem $Path -ErrorAction SilentlyContinue
    if ($ExpandedPaths) {
        $KeytoolPath = $ExpandedPaths[0].FullName
        break
    }
}

if (!$KeytoolPath) {
    Write-Error "Keytool not found. Please install Java or Android Studio."
    exit 1
}

Write-Host "Using keytool: $KeytoolPath"
Write-Host "Generating keystore: $KeystoreFile"

# Generate keystore
& $KeytoolPath -genkey -v -keystore $KeystoreFile -keyalg RSA -keysize 2048 -validity $ValidityDays -alias $Alias

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Keystore generated successfully!"
    Write-Host "Location: $KeystoreFile"
    Write-Host "Alias: $Alias"
    Write-Host "Validity: $ValidityDays days"
} else {
    Write-Error "❌ Failed to generate keystore"
}
```

### Run the Script
```powershell
# Make sure execution policy allows scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Run the script
.\generate-keystore.ps1

# Or with custom parameters
.\generate-keystore.ps1 -KeystoreName "myapp-release" -Alias "myapp" -ValidityDays 7300
```

## Configuration Setup

### Create key.properties
Create `android\key.properties`:

```properties
storeFile=../keystores/release.jks
storePassword=321100
keyAlias=release
keyPassword=321100
```

**Important Path Note**: The path `../keystores/release.jks` resolves from the `android/` directory to `android/keystores/release.jks`, not the project root. Ensure your keystore is placed in `android/keystores/` directory.

**Password Security**: In production, consider using environment variables or secure CI/CD secrets instead of hardcoded passwords.

### Update build.gradle.kts
Add to `android\app\build.gradle.kts`:

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

## Testing the Keystore

### Build Signed APK
```powershell
# Clean and build
flutter clean
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### Verify Signature
```powershell
# Using Android Studio's keytool
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -list -v -keystore keystores\release.jks -alias release

# Verify APK signature
& "C:\Program Files\Android\Android Studio\jbr\bin\jarsigner.exe" -verify -verbose -certs build\app\outputs\flutter-apk\app-release.apk
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

**"keytool is not recognized"**
```powershell
# Solution 1: Use full path
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -version

# Solution 2: Add to PATH
$env:PATH += ";C:\Program Files\Android\Android Studio\jbr\bin"
```

**"Java not found"**
```powershell
# Install Android Studio or set JAVA_HOME
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$env:PATH += ";$env:JAVA_HOME\bin"
```

**"Different store and key passwords not supported for PKCS12"**
```powershell
# This warning appears when different passwords are specified
# Modern Java uses PKCS12 format which requires identical passwords
# Solution: Use the same password for both -storepass and -keypass
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore android\keystores\release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release -dname "CN=John Doe, OU=Development, O=Shell Company, L=Bengaluru, ST=Karnataka, C=India" -storepass "321100" -keypass "321100"
```

**"Keystore password must be at least 6 characters"**
```powershell
# Ensure passwords meet minimum length requirement
# ❌ Bad: -storepass "123" -keypass "456"  
# ✅ Good: -storepass "321100" -keypass "321100"
```

**"Access denied"**
```powershell
# Run PowerShell as Administrator
Start-Process powershell -Verb runAs
```

**"Execution policy error"**
```powershell
# Allow script execution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Keystore Management

**List keystore contents:**
```powershell
keytool -list -v -keystore keystores\release.jks
```

**Change keystore password:**
```powershell
keytool -storepasswd -keystore keystores\release.jks
```

**Export certificate:**
```powershell
keytool -export -alias release -keystore keystores\release.jks -file release.crt
```

**Get certificate fingerprint (for Firebase, Google APIs):**
```powershell
keytool -list -v -keystore keystores\release.jks -alias release
```

## Security Best Practices

### Password Management
- Use strong, unique passwords (minimum 12 characters)
- Store passwords in a secure password manager
- Never commit passwords to version control

### Keystore Backup
```powershell
# Create backup with timestamp
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
Copy-Item keystores\release.jks "keystores\backup\release_$Timestamp.jks"

# Compress for secure storage
Compress-Archive -Path keystores\release.jks -DestinationPath "keystores\backup\release_$Timestamp.zip"
```

### Environment Variables
For CI/CD, use environment variables:

```powershell
# Set environment variables
$env:KEYSTORE_PASSWORD = "your_password"
$env:KEY_PASSWORD = "your_key_password"

# Update key.properties to use environment variables
```

## Automation Scripts

### Batch Keystore Generation
Create `batch-generate-keystores.ps1`:

```powershell
# Generate multiple keystores for different environments
$Environments = @("development", "staging", "production")

foreach ($Env in $Environments) {
    Write-Host "Generating keystore for: $Env"
    & "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" `
        -genkey -v `
        -keystore "keystores\$Env.jks" `
        -keyalg RSA `
        -keysize 2048 `
        -validity 10000 `
        -alias $Env `
        -dname "CN=MyApp $Env, OU=IT Department, O=My Company, L=My City, ST=My State, C=US" `
        -storepass "password123" `
        -keypass "password123"
}
```

---

## Complete Example - Working Setup

### Step-by-Step Working Example
Here's the exact sequence that successfully generates a signed APK:

```powershell
# 1. Create keystores directory
mkdir android\keystores

# 2. Generate keystore with pre-filled information
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore android\keystores\release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release -dname "CN=John Doe, OU=Development, O=Shell Company, L=Bengaluru, ST=Karnataka, C=India" -storepass "321100" -keypass "321100"

# 3. Verify keystore was created successfully
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -list -v -keystore android\keystores\release.jks -storepass "321100"

# 4. Create key.properties file
@"
storeFile=../keystores/release.jks
storePassword=321100
keyAlias=release
keyPassword=321100
"@ | Out-File -FilePath android\key.properties -Encoding UTF8

# 5. Build signed release APK
flutter build apk --release
```

### Expected Results
- ✅ Keystore created: `android\keystores\release.jks`
- ✅ Configuration: `android\key.properties`
- ✅ Signed APK: `build\app\outputs\flutter-apk\app-release.apk`
- ✅ No password warnings (both passwords identical)
- ✅ PKCS12 keystore format
- ✅ 27+ years validity

## Quick Reference

### Essential Commands
```powershell
# Generate keystore
keytool -genkey -v -keystore release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release

# List keystore
keytool -list -v -keystore release.jks

# Build signed APK
flutter build apk --release

# Verify signature
jarsigner -verify -verbose -certs app-release.apk
```

### File Locations
- Keystore: `android\keystores\release.jks`
- Configuration: `android\key.properties`
- Build config: `android\app\build.gradle.kts`

---

**Important**: Always backup your keystore files securely. Losing them means you cannot update your published Android apps!
