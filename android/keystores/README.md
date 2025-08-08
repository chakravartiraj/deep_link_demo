# Keystore Information

## Generated Keystores

### Release Keystore
- **Location:** `android/keystores/release-keystore.jks`
- **Alias:** release
- **Store Password:** 321123
- **Key Password:** 321123
- **Validity:** 10,000 days
- **Key Algorithm:** RSA
- **Key Size:** 2048 bits

### Certificate Details
- **CN:** John Doe
- **OU:** Development
- **O:** Shell Company
- **L:** Bengaluru
- **ST:** Karnataka
- **C:** India

## SHA256 Certificate Fingerprints

### Release SHA256
```
D4:54:BA:C0:AE:AE:7A:5F:33:63:3F:54:37:16:A7:D5:29:38:F1:77:72:E0:F6:B9:37:D1:89:E5:71:20:60:96
```

### Debug SHA256
```
0E:AB:54:F7:76:B4:C2:0B:3E:37:D1:01:70:09:F8:B9:5F:3B:F6:97:F5:84:1C:6B:14:D8:6E:BD:50:8C:A0:61
```

## Commands Used

### Generate Release Keystore
```bash
keytool -genkey -v -keystore android\keystores\release-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release -storepass 321123 -keypass 321123 -dname "CN=John Doe, OU=Development, O=Shell Company, L=Bengaluru, ST=Karnataka, C=India"
```

### Extract Release SHA256
```bash
keytool -list -v -keystore android\keystores\release-keystore.jks -alias release -storepass 321123 | findstr "SHA256"
```

### Extract Debug SHA256
```bash
keytool -list -v -keystore $env:USERPROFILE\.android\debug.keystore -alias androiddebugkey -storepass android | findstr "SHA256"
```

## Files Updated

1. `web/.well-known/assetlinks.json` - Updated with actual SHA256 fingerprints
2. `docs/05-deep-linking/platform-guides/android/assetlinks.json` - Updated with actual SHA256 fingerprints

## Usage

These SHA256 fingerprints are now properly configured in the assetlinks.json files and will be deployed to GitHub Pages, allowing Android deep linking verification to work correctly.
