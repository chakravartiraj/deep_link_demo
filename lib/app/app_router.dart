import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/core/constants/app_constants.dart';
import 'package:myapp/features/deep_linking/deep_linking.dart';
import 'package:myapp/features/details/details.dart';
import 'package:myapp/features/home/home.dart';
import 'package:myapp/features/landing/landing.dart';
import 'package:myapp/features/profile/profile.dart';
import 'package:myapp/features/report/report.dart';
import 'package:myapp/shared/shared.dart';

/// Production-ready router – no external packages needed.
final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: kDebugMode,
  routes: [
    // Landing page route - fast loading for web
    GoRoute(
      path: AppConstants.homeRoute,
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
      path: AppConstants.detailsRoute,
      builder: (_, state) => DetailsPage(detailId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: AppConstants.profileRoute,
      builder: (_, __) => const ProfilePage(),
    ),
    GoRoute(
      path: AppConstants.reportRoute,
      builder: (_, state) => ReportPage(
        reportId: state.pathParameters['reportId'],
        queryParams: state.uri.queryParameters,
      ),
    ),
    GoRoute(
      path: AppConstants.deepLinkRoute,
      builder: (_, state) =>
          DeepLinkPage(queryParams: state.uri.queryParameters),
    ),
  ],
  errorBuilder: (_, __) => const ErrorPage(),
);
