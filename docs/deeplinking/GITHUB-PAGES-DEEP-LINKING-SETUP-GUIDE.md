# GitHub Pages Deep Linking Setup Guide

## 🎯 Overview
Host your `apple-app-site-association` and `assetlinks.json` files on GitHub Pages for deep linking verification.

## 📁 Repository Structure
```
your-deeplink-verification/
├── .well-known/
│   ├── apple-app-site-association
│   └── assetlinks.json
├── index.html (optional landing page)
└── README.md
```

## 🚀 Quick Setup Steps

### 1. Create a New Repository
```bash
# Create new repo for deep link verification
gh repo create your-app-deeplinks --public
cd your-app-deeplinks
```

### 2. Create the Required Files

**`.well-known/apple-app-site-association`** (no extension):
```json
{
  "applinks": {
    "apps": [],
    "details": [{
      "appID": "TEAMID.com.example.deepLinkDemo",
      "paths": ["*"]
    }]
  }
}
```

**`.well-known/assetlinks.json`**:
```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.example.deep_link_demo",
    "sha256_cert_fingerprints": [
      "YOUR_RELEASE_SHA256_HERE",
      "YOUR_DEBUG_SHA256_HERE"
    ]
  }
}]
```

### 3. Enable GitHub Pages
1. Go to repo **Settings** → **Pages**
2. Source: **Deploy from a branch**
3. Branch: **main** / **root**
4. Save

### 4. Update Your App Configuration

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<data android:scheme="https"
      android:host="your-username.github.io"
      android:pathPrefix="/your-app-deeplinks" />
```

**iOS** (Xcode → Associated Domains):
```
applinks:your-username.github.io
```

## 🔧 For Your Project Specifically

### Domain URLs:
- **GitHub Pages URL**: `https://your-username.github.io/your-app-deeplinks`
- **Apple file**: `https://your-username.github.io/your-app-deeplinks/.well-known/apple-app-site-association`
- **Android file**: `https://your-username.github.io/your-app-deeplinks/.well-known/assetlinks.json`

### Test Links:
```bash
# Test your deep links
https://your-username.github.io/your-app-deeplinks/details/123
https://your-username.github.io/your-app-deeplinks/profile
https://your-username.github.io/your-app-deeplinks/deeplink?source=test&data=github
```

## ⚠️ Important Considerations

### ✅ Advantages:
- **Free hosting** with HTTPS by default
- **Easy updates** via Git commits
- **Version control** for your verification files
- **Custom domain support** if needed
- **Global CDN** distribution

### ⚠️ Limitations:
- **Public repository** required for free GitHub Pages
- **Build time** ~10-15 minutes for changes to propagate
- **Cache issues** - iOS may cache association files aggressively

## 🛠️ Advanced Setup

### Custom Domain (Optional):
1. Buy domain (e.g., `deeplinks.yourapp.com`)
2. Add CNAME file: `echo "deeplinks.yourapp.com" > CNAME`
3. Configure DNS: `CNAME deeplinks your-username.github.io`
4. Update app configurations to use custom domain

### Index Page for Testing:
```html
<!DOCTYPE html>
<html>
<head>
    <title>Deep Link Demo - Test Links</title>
</head>
<body>
    <h1>Deep Link Testing</h1>
    <ul>
        <li><a href="/details/123">Test Details Page</a></li>
        <li><a href="/profile">Test Profile Page</a></li>
        <li><a href="/deeplink?source=github&data=test">Test Deep Link</a></li>
    </ul>
    
    <h2>Verification Files</h2>
    <ul>
        <li><a href="/.well-known/apple-app-site-association">Apple Association File</a></li>
        <li><a href="/.well-known/assetlinks.json">Android Asset Links</a></li>
    </ul>
</body>
</html>
```

## 🧪 Testing Commands

### Verify Files Are Accessible:
```bash
# Test Apple file
curl -I https://your-username.github.io/your-app-deeplinks/.well-known/apple-app-site-association

# Test Android file
curl -I https://your-username.github.io/your-app-deeplinks/.well-known/assetlinks.json

# Both should return 200 OK with Content-Type: application/json
```

### App Testing:
```bash
# Android
adb shell am start -W -a android.intent.action.VIEW -d "https://your-username.github.io/your-app-deeplinks/details/42"

# iOS Simulator
xcrun simctl openurl booted "https://your-username.github.io/your-app-deeplinks/details/42"
```

## 🎯 Production Recommendations

### For Production Apps:
1. **Use custom domain** for branding and control
2. **Set up monitoring** for file accessibility
3. **Version control** your verification files
4. **Test thoroughly** before App Store/Play Store submissions
5. **Consider backup domains** for redundancy

### Security Notes:
- Verification files are **public by design**
- Don't include sensitive information
- Regularly rotate SHA-256 certificates in `assetlinks.json`

This setup gives you a **free, reliable, and version-controlled** way to host your deep linking verification files! 🚀