# Deep Linking Setup Instructions

## 🔧 Configuration Required

### 1. Update SHA-256 Fingerprints in assetlinks.json

To get your SHA-256 fingerprints for Android:

#### Debug Certificate:
```bash
# For debug builds
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

#### Release Certificate:
```bash
# For release builds (replace with your keystore path)
keytool -list -v -keystore /path/to/your/release.keystore -alias your-key-alias
```

Copy the SHA-256 fingerprint and update the `assetlinks.json` file:
- Replace `PUT_YOUR_RELEASE_SHA256_HERE` with your release certificate SHA-256
- Replace `PUT_YOUR_DEBUG_SHA256_HERE` with your debug certificate SHA-256

### 2. Update Apple Team ID in apple-app-site-association

Replace `TEAMID` in the `apple-app-site-association` file with your actual Apple Developer Team ID.

### 3. Update App Store ID (Optional)

In `web/index.html`, replace `YOUR_APP_STORE_ID` with your actual App Store ID for iOS smart app banners.

## 🌐 GitHub Pages Deployment

Once configured, these files will be automatically served when you deploy to GitHub Pages:

- **Apple Association**: `https://your-username.github.io/your-repo/.well-known/apple-app-site-association`
- **Android Asset Links**: `https://your-username.github.io/your-repo/.well-known/assetlinks.json`

## ✅ Verification

### Test URLs:
- Apple: `https://search.developer.apple.com/appsearch-validation-tool/`
- Android: `https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://your-domain.com&relation=delegate_permission/common.handle_all_urls`

### Deep Link Test Examples:
- `/details/123` - Detail page with parameter
- `/profile` - Profile page
- `/home` - Home page
- `/report` - Report page
- `/deeplink?source=web&data=test` - Custom deep link with parameters
