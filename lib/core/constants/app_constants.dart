/// App-wide constants and configuration values
class AppConstants {
  // App Information
  static const String appName = 'Deep Link Demo';
  static const String appVersion = '1.0.0';

  // Deep Linking Configuration
  static const String deepLinkDomain = 'deeplink.page.link';
  static const String androidPackage = 'com.example.myapp';
  static const String webBaseUrl = 'https://your-web-app.com';

  // Route Names
  static const String homeRoute = '/';
  static const String detailsRoute = '/details';
  static const String profileRoute = '/profile';
  static const String deepLinkRoute = '/deeplink';
  static const String landingRoute = '/landing';
  // Base route - use with reportId parameter
  static const String reportRoute = '/report';

  // Route Helpers
  static String reportRouteWithId(String reportId) => '$reportRoute/$reportId';

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 12.0;

  // Private constructor to prevent instantiation
  AppConstants._();
}
