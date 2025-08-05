/// A lightweight, reusable helper to **manually** build Firebase Dynamic Links.
///
/// Example:
/// ```dart
/// final url = buildDynamicLink(
///   domain: 'myapp.page.link',
///   deepLink: 'https://example.com/product/42?utm_source=qr',
///   androidPackage: 'com.example.myapp',
///   iosBundle: 'com.example.myapp',
///   fallbackWebUrl: 'https://example.com/pwa',
///   minimumAndroidVersionCode: 25,
///   analytics: UtmCampaign(
///     source: 'qr',
///     medium: 'cpc',
///     campaign: 'spring_sale',
///   ),
/// );
/// ```
String buildDynamicLink({
  required String domain,
  required String deepLink,
  String? androidPackage,
  String? iosBundle,
  String? fallbackWebUrl,
  int? minimumAndroidVersionCode,
  String? iosAppStoreId,
  String? iosCustomScheme,
  int? minimumIosVersion,
  String? fallbackIpadUrl,
  String? ipadBundleId,
  bool skipIosPreview = false,
  String? desktopFallbackUrl,
  UtmCampaign? analytics,
}) {
  final buf = StringBuffer('https://$domain/?link=${Uri.encodeQueryComponent(deepLink)}');

  // Android
  if (androidPackage != null) buf.write('&apn=$androidPackage');
  if (minimumAndroidVersionCode != null) buf.write('&amv=$minimumAndroidVersionCode');

  // iOS
  if (iosBundle != null) buf.write('&ibi=$iosBundle');
  if (iosAppStoreId != null) buf.write('&isi=$iosAppStoreId');
  if (iosCustomScheme != null) buf.write('&ius=$iosCustomScheme');
  if (minimumIosVersion != null) buf.write('&imv=$minimumIosVersion');
  if (ipadBundleId != null) buf.write('&ipbi=$ipadBundleId');
  if (fallbackIpadUrl != null) {
    buf.write('&ipfl=${Uri.encodeQueryComponent(fallbackIpadUrl)}');
  }
  if (skipIosPreview) buf.write('&efr=1');

  // Fallbacks
  if (fallbackWebUrl != null) {
    buf.write('&afl=${Uri.encodeQueryComponent(fallbackWebUrl)}');
    buf.write('&ifl=${Uri.encodeQueryComponent(fallbackWebUrl)}');
  }
  if (desktopFallbackUrl != null) {
    buf.write('&ofl=${Uri.encodeQueryComponent(desktopFallbackUrl)}');
  }

  // Analytics
  if (analytics != null) {
    final q = analytics._toQueryMap();
    q.forEach((k, v) => buf.write('&$k=${Uri.encodeQueryComponent(v)}'));
  }

  return buf.toString();
}

/// Optional UTM container for Google Play / iTunes analytics.
class UtmCampaign {
  const UtmCampaign({
    this.source,
    this.medium,
    this.campaign,
    this.term,
    this.content,
    this.at,
    this.ct,
    this.mt,
    this.pt,
  });

  final String? source;
  final String? medium;
  final String? campaign;
  final String? term;
  final String? content;
  final String? at;
  final String? ct;
  final String? mt;
  final String? pt;

  Map<String, String> _toQueryMap() {
    final m = <String, String>{};
    if (source != null) m['utm_source'] = source!;
    if (medium != null) m['utm_medium'] = medium!;
    if (campaign != null) m['utm_campaign'] = campaign!;
    if (term != null) m['utm_term'] = term!;
    if (content != null) m['utm_content'] = content!;
    if (at != null) m['at'] = at!;
    if (ct != null) m['ct'] = ct!;
    if (mt != null) m['mt'] = mt!;
    if (pt != null) m['pt'] = pt!;
    return m;
  }
}

//By default (i.e. **if you do not supply any fallback parameters**), Firebase Dynamic Links will automatically send the user to the **correct store page**:
//- **Android** → Google Play Store listing for the package name you put in `apn`.  
//- **iOS** → App Store listing for the bundle ID you put in `ibi` (and App Store ID in `isi`).

//The optional parameters you can pass to `buildDynamicLink`—  
//`fallbackWebUrl`, `afl`, `ifl`, `ipfl`, `ofl`—are **overrides**.  
//If you supply one of them, Firebase will use **that URL instead** of the store.  
//If you omit them, the link will fall back to the store automatically.

//So:

//| Provided to `buildDynamicLink`? | Behaviour when app is **not** installed |
//|---------------------------------|-----------------------------------------|
//| **None of the fallback URLs**   | Redirects to Google Play / App Store |
//| `fallbackWebUrl` (or `afl`/`ifl`/`ipfl`/`ofl`) set | Redirects to the URL you supplied, **not** the store |

//Example:

// Falls back to Play Store / App Store automatically
//buildDynamicLink(
//  domain: 'myapp.page.link',
//  deepLink: 'https://example.com/promo',
//  androidPackage: 'com.example.myapp',
//  iosBundle: 'com.example.myapp',
//  iosAppStoreId: '123456789',
//);

// Falls back to the web page instead of the stores
//buildDynamicLink(
//  domain: 'myapp.page.link',
//  deepLink: 'https://example.com/promo',
//  androidPackage: 'com.example.myapp',
//  iosBundle: 'com.example.myapp',
//  iosAppStoreId: '123456789',
//  fallbackWebUrl: 'https://example.com/promo',
//);
