# 🚀 Flutter APK Build & GitHub Pages Deployment Guide

## 📋 Overview

This guide sets up automatic APK building and distribution through GitHub Pages, allowing users to download your Flutter APK directly from your web app.

## 🏗️ Architecture

```
┌─────────────────────┐    ┌──────────────────────┐    ┌─────────────────────┐
│   Developer Push   │───▶│   GitHub Actions     │───▶│   GitHub Pages      │
│   to main branch   │    │   - Build APK        │    │   - Host Web App     │
└─────────────────────┘    │   - Build Web        │    │   - Serve APK Files  │
                           │   - Deploy Pages     │    │   - Download Page    │
                           └──────────────────────┘    └─────────────────────┘
```

## ⚙️ Setup Instructions

### 1. Enable GitHub Pages

1. Go to your repository **Settings** → **Pages**
2. Source: **GitHub Actions**
3. Save the configuration

### 2. Configure Repository Permissions

1. Go to **Settings** → **Actions** → **General**
2. **Workflow permissions**: Select "Read and write permissions"
3. Check "Allow GitHub Actions to create and approve pull requests"
4. Save

### 3. Set Up Environment Variables (Optional)

For signed APKs, add these secrets in **Settings** → **Secrets** → **Actions**:

```bash
KEYSTORE_BASE64          # Base64 encoded keystore file
KEYSTORE_PASSWORD        # Keystore password
KEY_ALIAS               # Key alias
KEY_PASSWORD            # Key password
```

## 🚀 Automated Build Process

### Triggers

The workflow automatically runs on:
- ✅ **Push to main branch**
- ✅ **Pull requests to main**
- ✅ **Manual trigger** (workflow_dispatch)
- ✅ **Version tags** (v1.0.0, v2.0.0, etc.)

### Build Steps

1. **🔧 Setup Environment**
   - Java 17 (Temurin distribution)
   - Flutter 3.24.1 (stable channel)
   - Dependencies caching

2. **📱 Build Android APK**
   - Extract version from pubspec.yaml
   - Build debug/release APK
   - Generate meaningful filename
   - Upload as artifact

3. **🌐 Build Web Application**
   - Build Flutter web (HTML renderer)
   - Download APK artifact
   - Create downloads directory
   - Generate build info JSON

4. **🚀 Deploy to GitHub Pages**
   - Upload combined web + APK build
   - Deploy to Pages environment
   - Generate deployment summary

5. **📦 Create Release (for tags)**
   - Attach APK to GitHub release
   - Generate release notes
   - Publish to repository releases

## 📁 File Structure After Build

```
build/web/
├── index.html                    # Main Flutter web app
├── downloads.html               # Download page
├── deeplink-test.html          # Deep link testing
├── downloads/
│   ├── info.json               # Build information
│   └── deep-link-demo-v1.0.0-build1-debug.apk
├── .well-known/
│   ├── apple-app-site-association
│   └── assetlinks.json
└── [other Flutter web files]
```

## 🎯 Access Points

After deployment, your users can access:

| Resource | URL | Description |
|----------|-----|-------------|
| **Web App** | `https://username.github.io/repo/` | Main Flutter web application |
| **Downloads** | `https://username.github.io/repo/downloads.html` | APK download page |
| **Direct APK** | `https://username.github.io/repo/downloads/app.apk` | Direct APK download |
| **Build Info** | `https://username.github.io/repo/downloads/info.json` | Build metadata |
| **Deep Link Test** | `https://username.github.io/repo/deeplink-test.html` | Testing interface |

## 🛠️ Local Development

### Quick Build Script

Use the provided scripts for local testing:

**Linux/macOS:**
```bash
chmod +x scripts/build-and-deploy.sh
./scripts/build-and-deploy.sh
```

**Windows:**
```cmd
scripts\build-and-deploy.bat
```

### Manual Build Commands

```bash
# Clean and get dependencies
flutter clean && flutter pub get

# Build APK
flutter build apk --release

# Build web
flutter build web --release --web-renderer html

# Serve locally
cd build/web && python -m http.server 8000
```

## 📱 APK Installation Instructions

### For End Users

1. **Download APK** from the downloads page
2. **Enable Unknown Sources**:
   - Android Settings → Security → Unknown Sources
   - Or per-app: Settings → Apps → Browser → Install Unknown Apps
3. **Install APK** by tapping the downloaded file
4. **Test Deep Links** using the provided test links

### Security Note

- APKs are **debug-signed** by default (for testing)
- For production, add proper **release signing** configuration
- Users need to **trust the source** for installation

## 🔧 Customization

### Version Management

Update version in `pubspec.yaml`:
```yaml
version: 1.2.0+5  # version+build_number
```

### APK Signing (Production)

1. **Generate keystore:**
```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. **Add to android/key.properties:**
```properties
storePassword=your-store-password
keyPassword=your-key-password
keyAlias=upload
storeFile=../upload-keystore.jks
```

3. **Update android/app/build.gradle:**
```gradle
android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### Custom Download Page

Modify `web/downloads.html` to:
- Add your branding
- Customize styling
- Add analytics tracking
- Include installation videos
- Add QR codes for easy mobile download

### Build Notifications

Add webhook notifications to workflow:
```yaml
- name: Notify Discord
  uses: sarisia/actions-status-discord@v1
  if: always()
  with:
    webhook: ${{ secrets.DISCORD_WEBHOOK }}
    title: "Build Complete"
    description: "APK ready for download!"
```

## 📊 Analytics & Monitoring

### Download Tracking

Add to `downloads.html`:
```javascript
// Track APK downloads
downloadBtn.onclick = () => {
    // Google Analytics
    gtag('event', 'download', {
        'event_category': 'APK',
        'event_label': 'Android',
        'value': 1
    });
    
    // Custom analytics
    fetch('/api/track-download', {
        method: 'POST',
        body: JSON.stringify({ platform: 'android' })
    });
};
```

### Build Monitoring

Monitor build status:
- GitHub Actions dashboard
- Workflow email notifications
- Third-party monitoring (StatusPage, etc.)

## 🚨 Troubleshooting

### Common Issues

**❌ APK not available after build**
- Check GitHub Actions logs
- Verify artifacts were uploaded
- Ensure proper file permissions

**❌ Downloads page shows "Build in progress"**
- Wait for GitHub Actions to complete
- Check if `info.json` was generated correctly
- Verify GitHub Pages deployment

**❌ APK won't install on Android**
- Enable "Install from unknown sources"
- Check Android version compatibility
- Verify APK isn't corrupted

**❌ Deep links not working**
- Verify `.well-known` files are accessible
- Check platform-specific configurations
- Test with actual devices, not just emulators

### Debug Commands

```bash
# Check build artifacts
ls -la build/app/outputs/flutter-apk/

# Verify web build
ls -la build/web/downloads/

# Test local server
cd build/web && python -m http.server 8000

# Check APK info
aapt dump badging app-release.apk
```

## 🎯 Production Checklist

Before going live:

- [ ] **Update app signing** for release builds
- [ ] **Test APK installation** on multiple Android devices
- [ ] **Verify deep links** work from actual web browsers
- [ ] **Check download page** loads correctly
- [ ] **Test GitHub Pages** deployment
- [ ] **Add analytics** tracking
- [ ] **Set up monitoring** for build failures
- [ ] **Create user documentation** for installation
- [ ] **Test on different** Android versions (API 21+)
- [ ] **Verify file sizes** are reasonable for mobile download

## 🌟 Advanced Features

### Progressive Download

Add download progress tracking:
```javascript
async function downloadWithProgress(url, filename) {
    const response = await fetch(url);
    const reader = response.body.getReader();
    const contentLength = +response.headers.get('Content-Length');
    
    // Show progress bar
    let receivedLength = 0;
    const chunks = [];
    
    while(true) {
        const {done, value} = await reader.read();
        if (done) break;
        
        chunks.push(value);
        receivedLength += value.length;
        
        // Update progress
        const progress = (receivedLength / contentLength) * 100;
        updateProgressBar(progress);
    }
}
```

### QR Code Generation

Add QR codes for easy mobile download:
```html
<script src="https://cdn.jsdelivr.net/npm/qrcode@1.5.3/build/qrcode.min.js"></script>
<script>
QRCode.toCanvas(document.getElementById('qr-canvas'), window.location.href + 'downloads/app.apk');
</script>
```

### Update Notifications

Implement in-app update notifications:
```dart
// In Flutter app
class UpdateChecker {
  static Future<bool> hasUpdate() async {
    final response = await http.get(Uri.parse('https://your-site.com/downloads/info.json'));
    final info = jsonDecode(response.body);
    final latestVersion = info['version'];
    final currentVersion = await PackageInfo.fromPlatform().version;
    
    return latestVersion != currentVersion;
  }
}
```

This setup provides a **complete, automated solution** for building and distributing your Flutter APK through GitHub Pages! 🚀
