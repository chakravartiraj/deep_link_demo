Flutter Deep-Linking Setup (Android + iOS) – 2025 Edition  
No Firebase Dynamic Links, no extra plugins, just the built-in Router.

──────────────────────────────
1. Flutter side (single file)
──────────────────────────────
```dart
// file: lib/router.dart
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../deeplinking/home_page.dart';
import '../deeplinking/details_page.dart';
import '../deeplinking/profile_page.dart';
import '../deeplinking/deeplink_page.dart';
import '../deeplinking/error_page.dart';

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: kDebugMode,
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomePage()),
    GoRoute(
      path: '/details/:id',
      builder: (_, state) => DetailsPage(id: state.pathParameters['id']!),
    ),
    GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
    GoRoute(
      path: '/deeplink',
      builder: (_, state) => DeepLinkPage(query: state.uri.queryParameters),
    ),
  ],
  errorBuilder: (_, __) => const ErrorPage(),
);
```

Use it in `main.dart`:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp.router(routerConfig: appRouter));
}
```

──────────────────────────────
2. Android setup
──────────────────────────────
2-a.  `android/app/src/main/AndroidManifest.xml`

```xml
<application …>
  <activity
      android:name=".MainActivity"
      android:exported="true"
      android:launchMode="singleTop">
    
    <!-- Tell Flutter to enable deep linking -->
    <meta-data
        android:name="flutter_deeplinking_enabled"
        android:value="true" />

    <!-- HTTPS App Link (supports deferred deep link) -->
    <intent-filter android:autoVerify="true">
      <action android:name="android.intent.action.VIEW" />
      <category android:name="android.intent.category.DEFAULT" />
      <category android:name="android.intent.category.BROWSABLE" />
      <data android:scheme="https"
            android:host="example.com"
            android:pathPrefix="/" />
    </intent-filter>

    <!-- Optional custom scheme for direct deep link -->
    <intent-filter>
      <action android:name="android.intent.action.VIEW" />
      <category android:name="android.intent.category.DEFAULT" />
      <category android:name="android.intent.category.BROWSABLE" />
      <data android:scheme="myapp" android:host="open" />
    </intent-filter>
  </activity>
</application>
```

2-b.  Digital-asset-link file  
Digital-asset-link – .json
(full filename: assetlinks.json)
Host at `https://example.com/.well-known/assetlinks.json`

```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.example.myapp",
    "sha256_cert_fingerprints": ["<release-sha256>", "<debug-sha256>"]
  }
}]
```

──────────────────────────────
3. iOS setup
──────────────────────────────
3-a.  Xcode ▸ Runner ▸ Signing & Capabilities  
Add **Associated Domains** → entry: `applinks:example.com`

3-b.  `ios/Runner/Info.plist`

```xml
<!-- Disable Flutter’s legacy handler (Router takes over) -->
<key>FlutterDeepLinkingEnabled</key>
<false/>

<!-- Optional custom scheme -->
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key><array><string>myapp</string></array>
    <key>CFBundleURLName</key><string>com.example.myapp</string>
  </dict>
</array>
```

3-c.  `apple-app-site-association` (no extension)  
apple-app-site-association – no extension at all
(full filename: apple-app-site-association)
Host at `https://example.com/.well-known/apple-app-site-association`

```json
{
  "applinks": {
    "apps": [],
    "details": [{
      "appID": "TEAMID.com.example.myapp",
      "paths": ["*"]
    }]
  }
}
```

──────────────────────────────
4. Testing matrix
──────────────────────────────
| Case | Command / Action |
|---|---|
| Android direct (custom) | `adb shell am start -W -a android.intent.action.VIEW -d "myapp://open/details/42"` |
| Android deferred | Uninstall → tap `https://example.com/details/42` → Play Store → install → auto-open to `/details/42` |
| iOS direct (custom) | `xcrun simctl openurl booted "myapp://open/details/42"` |
| iOS deferred | Tap `https://example.com/details/42` → App Store → install → auto-open to `/details/42` |

──────────────────────────────
5. Production checklist
──────────────────────────────
- Serve both `.well-known` files **over HTTPS** with `Content-Type: application/json`  
- Add **debug + release SHA-256** to `assetlinks.json`  
- Re-sign app after adding new domains / entitlements  
- Flush CDN caches (iOS) if association file changes

With the above, `go_router` handles **both direct and deferred deep links** on Android and iOS without any third-party plugin .