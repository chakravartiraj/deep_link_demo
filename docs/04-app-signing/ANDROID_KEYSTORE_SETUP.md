# Android Release Keystore Setup Guide

## 🎉 Keystore Successfully Generated!

Your Android release keystore has been created and configured for the deep_link_demo project.

## 📁 Files Created

### Core Files
- `android/keystores/release.jks` - The actual keystore file (RSA 2048-bit, valid ~27 years)
- `android/key.properties` - Keystore configuration (update with your passwords)
- `android/app/proguard-rules.pro` - ProGuard rules for release builds

### Documentation
- `docs/ANDROID_KEYSTORE_SETUP.md` - This file

## ⚡ Quick Start

### 1. Update Passwords
Edit `android/key.properties` and replace the placeholder values:

```properties
storePassword=YOUR_ACTUAL_KEYSTORE_PASSWORD
keyPassword=YOUR_ACTUAL_KEY_PASSWORD
```

### 2. Build Signed APK
```bash
# Build a signed release APK
flutter build apk --release

# Build an Android App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### 3. Verify Signing
```bash
# Check if APK is properly signed
keytool -list -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk
```

## 🔐 Security Checklist

### ✅ Completed
- [x] Keystore generated with strong RSA 2048-bit encryption
- [x] Valid for 10,000 days (~27 years)
- [x] Build configuration updated
- [x] ProGuard rules configured for release optimization

### ⚠️ Action Required
- [ ] **Update passwords** in `android/key.properties`
- [ ] **Backup keystore** to secure location
- [ ] **Document passwords** in secure password manager
- [ ] **Test release build** with `flutter build apk --release`

## 🛠️ Build Configuration

The build system is configured to:
- **Automatically use release keystore** when `key.properties` exists
- **Fall back to debug keystore** if properties file is missing
- **Enable minification and shrinking** for smaller APK size
- **Apply ProGuard rules** for code obfuscation

## 📋 Keystore Details

```
File: keystores/release.jks
Algorithm: RSA
Key Size: 2048 bits
Validity: 10,000 days (until ~2052)
Alias: release
Distinguished Name: CN=Raj Chakraborty, OU=1, O=exampleKreativ, L=Dreaming, ST=Apocrypha, C=66
```

## 🚀 Next Steps

### For Development
1. Update `key.properties` with your actual passwords
2. Test the release build: `flutter build apk --release`
3. Verify the APK is signed correctly

### For Production
1. **Backup the keystore** to multiple secure locations
2. **Set up CI/CD secrets** for automated builds
3. **Upload to Play Console** for app signing

### For CI/CD
Set these environment variables:
- `KEYSTORE_PASSWORD`
- `KEY_PASSWORD`

Update your CI/CD scripts to use these variables instead of hardcoded passwords.

## ❗ Critical Warnings

1. **Never commit the keystore password to version control**
2. **If you lose this keystore, you cannot update your app on Google Play**
3. **Keep multiple secure backups of the keystore file**
4. **Use the same keystore for all future releases of this app**

## 🔍 Troubleshooting

### Common Issues

**"Could not find key.properties"**
- Ensure `android/key.properties` exists and has correct passwords

**"Keystore file not found"**
- Verify `keystores/release.jks` exists
- Check the path in `key.properties` is correct

**"Wrong password"**
- Ensure keystore and key passwords match what you entered during generation

**"Build failed with signing error"**
- Try building without signing first: `flutter build apk --debug`
- Check Android Studio's Build > Generate Signed Bundle/APK for detailed errors

### Testing Signing

```bash
# List keystore contents
keytool -list -v -keystore keystores/release.jks -alias release

# Verify APK signature
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk
```

## 📞 Support

For additional help:
1. Check the Flutter documentation: https://flutter.dev/docs/deployment/android
2. Review Android signing guide: https://developer.android.com/studio/publish/app-signing
3. Use `flutter doctor` to check your development environment

---

✅ **Keystore setup complete!** Your app is ready for production signing.
