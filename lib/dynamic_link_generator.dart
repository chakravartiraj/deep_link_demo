import 'deep_links_helper.dart';

/// Service for generating Firebase Dynamic Links for app pages
/// Specifically configured for Android platform support
class DynamicLinkGenerator {
  // Configuration - Update these values to match your Firebase project
  static const String dynamicLinkDomain =
      'deeplink.page.link'; // Replace with your Firebase domain
  static const String androidPackage = 'com.example.myapp';
  static const String webBaseUrl =
      'https://chakravartiraj.github.io/deep_link_demo';

  // Android configuration
  static const int minimumAndroidVersionCode = 21; // Android 5.0+

  /// Generate dynamic link for Details page
  /// Example: /details/123 -> Firebase Dynamic Link
  static String generateDetailsLink({
    required String detailId,
    Map<String, String>? queryParams,
    UtmCampaign? analytics,
  }) {
    final deepLinkUrl = _buildDeepLink('/details/$detailId', queryParams);

    return buildDynamicLink(
      domain: dynamicLinkDomain,
      deepLink: deepLinkUrl,
      androidPackage: androidPackage,
      minimumAndroidVersionCode: minimumAndroidVersionCode,
      fallbackWebUrl: deepLinkUrl,
      analytics:
          analytics ??
          UtmCampaign(
            source: 'app',
            medium: 'dynamic_link',
            campaign: 'details_share',
          ),
    );
  }

  /// Generate dynamic link for Profile page
  static String generateProfileLink({
    Map<String, String>? queryParams,
    UtmCampaign? analytics,
  }) {
    final deepLinkUrl = _buildDeepLink('/profile', queryParams);

    return buildDynamicLink(
      domain: dynamicLinkDomain,
      deepLink: deepLinkUrl,
      androidPackage: androidPackage,
      minimumAndroidVersionCode: minimumAndroidVersionCode,
      fallbackWebUrl: deepLinkUrl,
      analytics:
          analytics ??
          UtmCampaign(
            source: 'app',
            medium: 'dynamic_link',
            campaign: 'profile_share',
          ),
    );
  }

  /// Generate dynamic link for Report page
  /// Example: /report/abc123?status=active -> Firebase Dynamic Link
  static String generateReportLink({
    required String reportId,
    Map<String, String>? queryParams,
    UtmCampaign? analytics,
  }) {
    final deepLinkUrl = _buildDeepLink('/report/$reportId', queryParams);

    return buildDynamicLink(
      domain: dynamicLinkDomain,
      deepLink: deepLinkUrl,
      androidPackage: androidPackage,
      minimumAndroidVersionCode: minimumAndroidVersionCode,
      fallbackWebUrl: deepLinkUrl,
      analytics:
          analytics ??
          UtmCampaign(
            source: 'app',
            medium: 'dynamic_link',
            campaign: 'report_share',
          ),
    );
  }

  /// Generate dynamic link for DeepLink demonstration page
  static String generateDeepLinkDemoLink({
    Map<String, String>? queryParams,
    UtmCampaign? analytics,
  }) {
    final deepLinkUrl = _buildDeepLink('/deeplink', queryParams);

    return buildDynamicLink(
      domain: dynamicLinkDomain,
      deepLink: deepLinkUrl,
      androidPackage: androidPackage,
      minimumAndroidVersionCode: minimumAndroidVersionCode,
      fallbackWebUrl: deepLinkUrl,
      analytics:
          analytics ??
          UtmCampaign(
            source: 'app',
            medium: 'dynamic_link',
            campaign: 'deeplink_demo',
          ),
    );
  }

  /// Generate dynamic link for Home page
  static String generateHomeLink({
    Map<String, String>? queryParams,
    UtmCampaign? analytics,
  }) {
    final deepLinkUrl = _buildDeepLink('/', queryParams);

    return buildDynamicLink(
      domain: dynamicLinkDomain,
      deepLink: deepLinkUrl,
      androidPackage: androidPackage,
      minimumAndroidVersionCode: minimumAndroidVersionCode,
      fallbackWebUrl: deepLinkUrl,
      analytics:
          analytics ??
          UtmCampaign(
            source: 'app',
            medium: 'dynamic_link',
            campaign: 'home_share',
          ),
    );
  }

  /// Generate a custom dynamic link for any path
  static String generateCustomLink({
    required String path,
    Map<String, String>? queryParams,
    String? campaignName,
    UtmCampaign? analytics,
  }) {
    final deepLinkUrl = _buildDeepLink(path, queryParams);

    return buildDynamicLink(
      domain: dynamicLinkDomain,
      deepLink: deepLinkUrl,
      androidPackage: androidPackage,
      minimumAndroidVersionCode: minimumAndroidVersionCode,
      fallbackWebUrl: deepLinkUrl,
      analytics:
          analytics ??
          UtmCampaign(
            source: 'app',
            medium: 'dynamic_link',
            campaign: campaignName ?? 'custom_share',
          ),
    );
  }

  /// Helper method to build the deep link URL
  static String _buildDeepLink(String path, Map<String, String>? queryParams) {
    final uri = Uri.parse('$webBaseUrl$path');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams).toString();
    }
    return uri.toString();
  }
}

/// Predefined analytics campaigns for common sharing scenarios
class CampaignPresets {
  static const UtmCampaign socialShare = UtmCampaign(
    source: 'social',
    medium: 'share',
    campaign: 'organic_growth',
  );

  static const UtmCampaign emailShare = UtmCampaign(
    source: 'email',
    medium: 'share',
    campaign: 'email_campaign',
  );

  static const UtmCampaign qrCode = UtmCampaign(
    source: 'qr',
    medium: 'offline',
    campaign: 'physical_marketing',
  );

  static const UtmCampaign smsShare = UtmCampaign(
    source: 'sms',
    medium: 'messaging',
    campaign: 'direct_share',
  );

  static const UtmCampaign notification = UtmCampaign(
    source: 'push',
    medium: 'notification',
    campaign: 'engagement',
  );
}

/// Extension to add dynamic link generation to common use cases
extension DynamicLinkRouteExtensions on String {
  /// Generate a dynamic link for this route path
  String toDynamicLink({
    Map<String, String>? queryParams,
    UtmCampaign? analytics,
  }) {
    return DynamicLinkGenerator.generateCustomLink(
      path: this,
      queryParams: queryParams,
      analytics: analytics,
    );
  }
}
