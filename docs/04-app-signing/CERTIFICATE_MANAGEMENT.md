# Certificate Management and Deep Linking Configuration

**Complete guide for Android certificate management and deep linking setup**

## 🔐 Certificate Overview

This document covers the generation and management of certificates required for Android deep linking verification in the Flutter Deep Link Demo project.

## 📋 Certificate Requirements

### Android App Links Verification
Android App Links require SHA256 certificate fingerprints to verify app ownership of specific domains. This prevents malicious apps from intercepting deep links intended for your application.

### Certificate Types
1. **Debug Certificate**: Used during development and testing
2. **Release Certificate**: Used for production app signing and Play Store distribution

## 🛠️ Keystore Generation

### Release Keystore Creation

We generated a release keystore with the following specifications:

```bash
keytool -genkey -v -keystore android\keystores\release-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias release \
  -storepass 321123 \
  -keypass 321123 \
  -dname "CN=John Doe, OU=Development, O=Shell Company, L=Bengaluru, ST=Karnataka, C=India"
```

### Keystore Details

| Property | Value |
|----------|-------|
| **Filename** | `release-keystore.jks` |
| **Location** | `android/keystores/` directory |
| **Alias** | `release` |
| **Algorithm** | RSA |
| **Key Size** | 2048 bits |
| **Validity** | 10,000 days |
| **Store Password** | `321123` |
| **Key Password** | `321123` |

### Certificate Distinguished Name

| Field | Value | Description |
|-------|-------|-------------|
| **CN** | John Doe | Common Name |
| **OU** | Development | Organizational Unit |
| **O** | Shell Company | Organization |
| **L** | Bengaluru | Locality/City |
| **ST** | Karnataka | State/Province |
| **C** | India | Country |

## 🔍 SHA256 Fingerprint Extraction

### Release Certificate Fingerprint

```bash
keytool -list -v -keystore android\keystores\release-keystore.jks -alias release -storepass 321123 | findstr "SHA256"
```

**Result:**
```
D4:54:BA:C0:AE:AE:7A:5F:33:63:3F:54:37:16:A7:D5:29:38:F1:77:72:E0:F6:B9:37:D1:89:E5:71:20:60:96
```

### Debug Certificate Fingerprint

```bash
keytool -list -v -keystore $env:USERPROFILE\.android\debug.keystore -alias androiddebugkey -storepass android | findstr "SHA256"
```

**Result:**
```
0E:AB:54:F7:76:B4:C2:0B:3E:37:D1:01:70:09:F8:B9:5F:3B:F6:97:F5:84:1C:6B:14:D8:6E:BD:50:8C:A0:61
```

## 📄 Asset Links Configuration

### assetlinks.json Structure

The `assetlinks.json` file establishes the relationship between your website and Android app:

```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.example.myapp",
    "sha256_cert_fingerprints": [
      "D4:54:BA:C0:AE:AE:7A:5F:33:63:3F:54:37:16:A7:D5:29:38:F1:77:72:E0:F6:B9:37:D1:89:E5:71:20:60:96",
      "0E:AB:54:F7:76:B4:C2:0B:3E:37:D1:01:70:09:F8:B9:5F:3B:F6:97:F5:84:1C:6B:14:D8:6E:BD:50:8C:A0:61"
    ]
  }
}]
```

### File Locations

| File | Purpose | Location |
|------|---------|----------|
| **Production** | Live verification | `web/.well-known/assetlinks.json` |
| **Documentation** | Reference copy | `docs/05-deep-linking/platform-guides/android/assetlinks.json` |

### Deployment URLs

After deployment to GitHub Pages, the asset links file is accessible at:
```
https://chakravartiraj.github.io/deep_link_demo/.well-known/assetlinks.json
```

## 🔧 Android Configuration

### Manifest Configuration

Update `android/app/src/main/AndroidManifest.xml`:

```xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:launchMode="singleTop"
    android:theme="@style/LaunchTheme">
    
    <!-- Standard App Launch -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>
    
    <!-- Deep Link Intent Filter -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="https"
              android:host="chakravartiraj.github.io" />
    </intent-filter>
</activity>
```

### Build Configuration

Update `android/app/build.gradle`:

```gradle
android {
    signingConfigs {
        release {
            keyAlias 'release'
            keyPassword '321123'
            storeFile file('../keystores/release-keystore.jks')
            storePassword '321123'
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            // Other release configurations
        }
    }
}
```

## 🧪 Testing and Verification

### Local Testing

1. **Build release APK**:
   ```bash
   flutter build apk --release
   ```

2. **Install on device**:
   ```bash
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

3. **Test deep link**:
   ```bash
   adb shell am start \
     -W -a android.intent.action.VIEW \
     -d "https://chakravartiraj.github.io/deep_link_demo/profile/123" \
     com.example.myapp
   ```

### Online Verification

Use Google's Digital Asset Links API to verify configuration:
```
https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://chakravartiraj.github.io&relation=delegate_permission/common.handle_all_urls
```

## 🔒 Security Best Practices

### Keystore Security

1. **Store securely**: Keep release keystore in secure location
2. **Backup**: Create encrypted backups of keystores
3. **Access control**: Limit access to release signing keys
4. **Version control**: Never commit keystores to version control

### Certificate Management

1. **Password strength**: Use strong passwords for production keystores
2. **Key rotation**: Plan for certificate renewal before expiration
3. **Multiple environments**: Use different certificates for debug/release
4. **Documentation**: Maintain records of certificate details

## 📱 iOS Configuration (Future)

For iOS deep linking, you'll need:

1. **Apple App Site Association** file
2. **Team ID** and **Bundle Identifier**
3. **Associated Domains** capability

Example `apple-app-site-association`:
```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAMID.com.example.myapp",
        "paths": ["*"]
      }
    ]
  }
}
```

## 🚨 Troubleshooting

### Common Issues

1. **Fingerprint mismatch**: Ensure correct keystore is used for signing
2. **File not accessible**: Verify assetlinks.json is served over HTTPS
3. **Verification failure**: Check package name matches exactly
4. **Certificate expiration**: Monitor certificate validity periods

### Debug Commands

```bash
# Verify keystore integrity
keytool -list -keystore keystores/release-keystore.jks

# Check certificate details
keytool -printcert -jarfile app-release.apk

# Test network accessibility
curl https://chakravartiraj.github.io/deep_link_demo/.well-known/assetlinks.json
```

## 📚 Additional Resources

- [Android App Links Documentation](https://developer.android.com/training/app-links)
- [Digital Asset Links](https://developers.google.com/digital-asset-links)
- [Flutter Deep Linking Guide](https://docs.flutter.dev/development/ui/navigation/deep-linking)
- [Keystore and Certificate Management](https://developer.android.com/studio/publish/app-signing)
