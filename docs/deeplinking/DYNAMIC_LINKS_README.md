# Firebase Dynamic Links Integration

This document explains how to use the `buildDynamicLink` function from `deep_links_helper.dart` to generate dynamic links for your Flutter app pages, specifically configured for Android platforms.

## Files Overview

### Core Files
- **`deep_links_helper.dart`** - Contains the `buildDynamicLink` function and `UtmCampaign` class
- **`dynamic_link_generator.dart`** - Service class with predefined methods for each page type
- **`dynamic_link_examples.dart`** - Example usage and demo widget
- **`dynamic_link_setup_page.dart`** - Configuration and testing interface

### Updated Pages
All existing pages now include dynamic link sharing functionality:
- **`pages/home_page.dart`** - Enhanced with multiple sharing options
- **`pages/details_page.dart`** - Share button for specific detail items
- **`pages/profile_page.dart`** - Profile sharing functionality
- **`pages/report_page.dart`** - Report sharing with query parameters

## Quick Start

### 1. Basic Usage

```dart
import 'dynamic_link_generator.dart';

// Generate a simple details page link
final dynamicLink = DynamicLinkGenerator.generateDetailsLink(
  detailId: 'item123',
  analytics: CampaignPresets.socialShare,
);

// Copy to clipboard
await Clipboard.setData(ClipboardData(text: dynamicLink));
```

### 2. With Query Parameters

```dart
// Generate link with additional parameters
final dynamicLink = DynamicLinkGenerator.generateReportLink(
  reportId: 'report456',
  queryParams: {
    'status': 'active',
    'filter': 'recent',
    'shared_by': 'user123',
  },
  analytics: CampaignPresets.emailShare,
);
```

### 3. Custom Analytics

```dart
// Generate link with custom analytics
final dynamicLink = DynamicLinkGenerator.generateCustomLink(
  path: '/custom-page',
  analytics: const UtmCampaign(
    source: 'newsletter',
    medium: 'email',
    campaign: 'spring_promotion',
    term: 'special_offer',
    content: 'header_button',
  ),
);
```

## Available Methods

### DynamicLinkGenerator Methods

| Method | Purpose | Parameters |
|--------|---------|------------|
| `generateHomeLink()` | Share app home page | `queryParams`, `analytics` |
| `generateDetailsLink()` | Share specific detail item | `detailId`, `queryParams`, `analytics` |
| `generateProfileLink()` | Share user profile | `queryParams`, `analytics` |
| `generateReportLink()` | Share report with parameters | `reportId`, `queryParams`, `analytics` |
| `generateDeepLinkDemoLink()` | Share demo page | `queryParams`, `analytics` |
| `generateCustomLink()` | Share any custom path | `path`, `queryParams`, `campaignName`, `analytics` |

### Predefined Analytics Campaigns

```dart
// Available in CampaignPresets class
CampaignPresets.socialShare    // For social media sharing
CampaignPresets.emailShare     // For email campaigns
CampaignPresets.qrCode         // For QR code generation
CampaignPresets.smsShare       // For SMS/messaging
CampaignPresets.notification   // For push notifications
```

## Configuration

### Required Setup

1. **Update Firebase Domain**
   ```dart
   // In dynamic_link_generator.dart
   static const String dynamicLinkDomain = 'your-project.page.link';
   ```

2. **Verify Package Name**
   ```dart
   // Should match your android/app/build.gradle.kts
   static const String androidPackage = 'com.example.myapp';
   ```

3. **Set Web Base URL**
   ```dart
   // Your GitHub Pages or web hosting URL
   static const String webBaseUrl = 'https://username.github.io/repo-name';
   ```

### Android Configuration

The current setup targets Android API level 21+ (Android 5.0+). Adjust if needed:

```dart
static const int minimumAndroidVersionCode = 21;
```

## Integration Examples

### Adding Share Button to Your Page

```dart
// In your page's AppBar
appBar: AppBar(
  title: const Text('Your Page'),
  actions: [
    IconButton(
      icon: const Icon(Icons.share),
      onPressed: () => _shareThisPage(context),
      tooltip: 'Share page',
    ),
  ],
),

// Share method
Future<void> _shareThisPage(BuildContext context) async {
  final dynamicLink = DynamicLinkGenerator.generateCustomLink(
    path: '/your-page',
    analytics: CampaignPresets.socialShare,
  );
  
  await Clipboard.setData(ClipboardData(text: dynamicLink));
  
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard!')),
    );
  }
}
```

### Using the Extension Method

```dart
// Simple extension usage
final link = '/profile'.toDynamicLink(
  analytics: CampaignPresets.emailShare,
);
```

## Testing Dynamic Links

### In-App Testing
1. Run the app and navigate to any page with sharing functionality
2. Tap the share button to generate and copy a dynamic link
3. Test the link in a browser or share it via messaging apps

### Setup Page
Access the Dynamic Link Setup page to:
- View current configuration
- Test link generation for all page types
- See usage examples and setup instructions

```dart
// Navigate to setup page (add to your router if needed)
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const DynamicLinkSetupPage()),
);
```

## Link Structure

Generated links follow this pattern:
```
https://your-domain.page.link/?link=https%3A//your-web-url.com/path%3Fparams&apn=com.example.myapp&amv=21&afl=https%3A//your-web-url.com/path&ifl=https%3A//your-web-url.com/path&utm_source=app&utm_medium=dynamic_link&utm_campaign=details_share
```

### Link Components
- **Domain**: Your Firebase Dynamic Links domain
- **Deep Link**: Encoded URL to your web app
- **Android Package**: Your app's package name (`apn`)
- **Min Version**: Minimum Android version (`amv`)
- **Fallback URLs**: Web fallback for Android (`afl`) and iOS (`ifl`)
- **Analytics**: UTM parameters for tracking

## Fallback Behavior

| Scenario | Behavior |
|----------|----------|
| App installed on Android | Opens the app directly to the specified page |
| App not installed | Redirects to the web version of the page |
| iOS device | Redirects to web version (iOS support can be added later) |
| Desktop/other | Redirects to web version |

## Best Practices

1. **Include Context in Links**
   ```dart
   queryParams: {
     'shared_at': DateTime.now().millisecondsSinceEpoch.toString(),
     'shared_from': 'app',
     'campaign_id': 'spring2024',
   }
   ```

2. **Use Appropriate Analytics**
   - Choose the right `CampaignPresets` for your sharing context
   - Create custom `UtmCampaign` objects for specific tracking needs

3. **Test Thoroughly**
   - Test links on devices with and without the app installed
   - Verify web fallbacks work correctly
   - Check analytics tracking in your Firebase console

4. **Error Handling**
   ```dart
   try {
     final link = DynamicLinkGenerator.generateDetailsLink(detailId: id);
     // Handle success
   } catch (e) {
     // Handle error gracefully
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Error generating link: $e')),
     );
   }
   ```

## Next Steps

1. **Firebase Setup**: Create a Firebase project and configure Dynamic Links
2. **Domain Configuration**: Set up your custom domain in Firebase console
3. **Testing**: Use the provided setup page to test link generation
4. **iOS Support**: Extend the configuration to include iOS bundle ID and App Store ID
5. **Analytics**: Monitor link performance in Firebase Analytics

## Troubleshooting

### Common Issues
- **Domain not configured**: Ensure your Firebase Dynamic Links domain is set up correctly
- **Package name mismatch**: Verify the package name matches your app's configuration
- **Web fallback not working**: Check that your web URL is accessible and correct

### Debug Tips
- Use the setup page to test individual link generation
- Check browser developer tools for any console errors
- Verify the generated links in a URL decoder to see the actual structure
