# Release APK Testing and Validation

**Complete guide for testing the signed release APK and deep linking functionality**

## 📱 Release APK Build Results

### ✅ Build Success
- **APK Location:** `build/app/outputs/flutter-apk/app-release.apk`
- **APK Size:** 20.6MB (21,588,213 bytes)
- **Build Time:** 42.9 seconds
- **Build Date:** August 8, 2025 17:33:26

### 🔐 Certificate Verification
- **Keystore Location:** `android/keystores/release-keystore.jks`
- **Certificate SHA256:** `D4:54:BA:C0:AE:AE:7A:5F:33:63:3F:54:37:16:A7:D5:29:38:F1:77:72:E0:F6:B9:37:D1:89:E5:71:20:60:96`
- **Signature Algorithm:** SHA256withRSA
- **Verification Status:** ✅ Matches assetlinks.json configuration

## 🧪 Testing Procedures

### Prerequisites for Testing

1. **Android Device or Emulator**
   - Android 5.0 (API level 21) or higher
   - Developer options enabled
   - USB debugging enabled (for physical device)

2. **ADB (Android Debug Bridge)**
   - Verify with: `adb --version`
   - Ensure device is connected: `adb devices`

3. **Internet Connection**
   - Required for deep link verification
   - GitHub Pages site must be accessible

### Installation Commands

```bash
# Install the release APK
adb install build\app\outputs\flutter-apk\app-release.apk

# Force install if app already exists
adb install -r build\app\outputs\flutter-apk\app-release.apk

# Install on specific device (if multiple devices)
adb -s <device_id> install build\app\outputs\flutter-apk\app-release.apk
```

### Basic Functionality Testing

```bash
# Launch the app manually
adb shell am start -n com.example.myapp/.MainActivity

# Check if app is installed
adb shell pm list packages | findstr myapp

# Get app information
adb shell dumpsys package com.example.myapp
```

## 🔗 Deep Link Testing

### Test Deep Link URLs

The following URLs should be tested for deep linking functionality:

1. **Home Route:**
   ```
   https://chakravartiraj.github.io/deep_link_demo/home
   ```

2. **Profile Route:**
   ```
   https://chakravartiraj.github.io/deep_link_demo/profile/123
   ```

3. **Report Route:**
   ```
   https://chakravartiraj.github.io/deep_link_demo/report/456
   ```

4. **Details Route:**
   ```
   https://chakravartiraj.github.io/deep_link_demo/details/product-789
   ```

### Deep Link Testing Commands

```bash
# Test home route
adb shell am start \
  -W -a android.intent.action.VIEW \
  -d "https://chakravartiraj.github.io/deep_link_demo/home" \
  com.example.myapp

# Test profile route with parameter
adb shell am start \
  -W -a android.intent.action.VIEW \
  -d "https://chakravartiraj.github.io/deep_link_demo/profile/123" \
  com.example.myapp

# Test report route with parameter
adb shell am start \
  -W -a android.intent.action.VIEW \
  -d "https://chakravartiraj.github.io/deep_link_demo/report/456" \
  com.example.myapp

# Test details route with parameter
adb shell am start \
  -W -a android.intent.action.VIEW \
  -d "https://chakravartiraj.github.io/deep_link_demo/details/product-789" \
  com.example.myapp
```

### Expected Results

For each deep link test:
1. **App Launch:** App should open automatically
2. **Correct Route:** App should navigate to the specified route
3. **Parameter Passing:** Route parameters should be correctly parsed
4. **UI Display:** Appropriate page content should be displayed

## 🔍 Android App Links Verification

### Manual Verification

1. **Open Browser** on the Android device
2. **Navigate to:** `https://chakravartiraj.github.io/deep_link_demo/home`
3. **Expected:** Android should show app choice dialog or open app directly
4. **Verify:** App opens to the correct route

### Automated Verification

```bash
# Check intent filters
adb shell dumpsys package com.example.myapp | findstr -i intent

# Verify domain associations
adb shell pm get-app-links com.example.myapp

# Test domain verification status
adb shell pm get-app-links --user 0 com.example.myapp
```

### Google Digital Asset Links Verification

Verify the assetlinks.json configuration:
```
https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://chakravartiraj.github.io&relation=delegate_permission/common.handle_all_urls
```

## 📊 Performance Testing

### App Launch Performance

```bash
# Measure cold start time
adb shell am start-activity \
  -W -n com.example.myapp/.MainActivity

# Measure warm start time
adb shell input keyevent KEYCODE_HOME
adb shell am start-activity \
  -W -n com.example.myapp/.MainActivity
```

### Memory Usage

```bash
# Monitor memory usage
adb shell dumpsys meminfo com.example.myapp

# Monitor CPU usage
adb shell top | findstr myapp
```

### Network Performance

```bash
# Monitor network usage
adb shell cat /proc/net/dev
adb shell dumpsys netstats detail
```

## 🐛 Debugging and Troubleshooting

### Common Issues

1. **Installation Failed**
   ```bash
   # Clear app data and retry
   adb shell pm clear com.example.myapp
   adb install -r build\app\outputs\flutter-apk\app-release.apk
   ```

2. **Deep Links Not Working**
   ```bash
   # Check intent filter configuration
   adb shell dumpsys package com.example.myapp | findstr -A 20 -B 5 "android.intent.action.VIEW"
   
   # Verify domain verification
   adb shell pm verify-app-links --re-verify com.example.myapp
   ```

3. **App Crashes**
   ```bash
   # View crash logs
   adb logcat | findstr "com.example.myapp"
   
   # Clear and capture fresh logs
   adb logcat -c
   adb logcat | findstr -i "error\|exception\|crash"
   ```

### Debug Information Collection

```bash
# Collect comprehensive debug info
adb shell dumpsys package com.example.myapp > app_debug_info.txt
adb logcat -d > logcat_output.txt
adb shell dumpsys meminfo com.example.myapp > memory_info.txt
```

## ✅ Testing Checklist

### Pre-Testing
- [ ] APK built successfully
- [ ] Certificate verification passed
- [ ] Device/emulator connected
- [ ] ADB working properly
- [ ] Internet connection available

### Installation Testing
- [ ] Fresh installation successful
- [ ] App appears in launcher
- [ ] App launches without errors
- [ ] Basic navigation works

### Deep Link Testing
- [ ] Home route opens correctly
- [ ] Profile route with parameters works
- [ ] Report route with parameters works
- [ ] Details route with parameters works
- [ ] Browser-initiated deep links work
- [ ] Intent-based deep links work

### Performance Testing
- [ ] Cold start performance acceptable
- [ ] Warm start performance acceptable
- [ ] Memory usage within reasonable limits
- [ ] No memory leaks detected
- [ ] Network usage optimized

### Verification Testing
- [ ] Certificate matches assetlinks.json
- [ ] Domain verification successful
- [ ] Intent filters correctly configured
- [ ] Google verification passes

## 📈 Test Results Documentation

### Template for Test Results

```
## Test Execution Results - [Date]

### Environment
- Device: [Device Model/Emulator]
- Android Version: [Version]
- APK Version: [Build Date/Version]

### Installation
- Status: ✅/❌
- Issues: [Any issues encountered]

### Deep Link Testing
- Home Route: ✅/❌
- Profile Route: ✅/❌
- Report Route: ✅/❌
- Details Route: ✅/❌

### Performance
- Cold Start: [Time in ms]
- Memory Usage: [MB]
- Network: [Acceptable/Issues]

### Overall Status: ✅/❌
```

## 🚀 Next Steps

After successful testing:

1. **Document Results:** Record all test outcomes
2. **Performance Optimization:** Address any performance issues
3. **User Acceptance Testing:** Share with stakeholders
4. **Play Store Preparation:** Prepare for store submission
5. **Production Deployment:** Plan release strategy

## 📚 Additional Resources

- **Android Deep Linking Guide:** https://developer.android.com/training/app-links
- **ADB Documentation:** https://developer.android.com/studio/command-line/adb
- **Testing Android Apps:** https://developer.android.com/training/testing
- **Digital Asset Links:** https://developers.google.com/digital-asset-links
