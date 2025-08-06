import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/pages/deeplink_page.dart';
import 'package:myapp/pages/details_page.dart';
import 'package:myapp/pages/profile_page.dart';
import 'package:myapp/pages/report_page.dart';
import 'pages/landing_page.dart';
import 'pages/home_page.dart';
import 'pages/error_page.dart';

/// Production-ready router – no external packages needed.
final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: kDebugMode,
  routes: [
    // Landing page route - fast loading for web
    GoRoute(
      path: '/',
      builder: (context, state) {
        // Use fast loading page for web
        if (kIsWeb) {
          return const LandingPage();
        }
        // For mobile, go directly to home
        return const HomePage();
      },
    ),

    // Main app routes
    GoRoute(
      path: '/details/:id',
      builder: (_, state) => DetailsPage(detailId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
    GoRoute(
      path: '/report/:reportId',
      builder: (_, state) => ReportPage(
        reportId: state.pathParameters['reportId'],
        queryParams: state.uri.queryParameters,
      ),
    ),
    GoRoute(
      path: '/deeplink',
      builder: (_, state) =>
          DeepLinkPage(queryParams: state.uri.queryParameters),
    ),
  ],
  errorBuilder: (_, __) => const ErrorPage(),
);
