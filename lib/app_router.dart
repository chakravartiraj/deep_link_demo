import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '/home_page.dart';
import '/details_page.dart';
import '/profile_page.dart';
import '/deeplink_page.dart';
import '/error_page.dart';

/// Production-ready router – no external packages needed.
final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: kDebugMode,
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomePage()),
    GoRoute(
      path: '/details/:id',
      builder: (_, state) => DetailsPage(detailId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
    GoRoute(
      path: '/deeplink',
      builder: (_, state) => DeepLinkPage(queryParams: state.uri.queryParameters),
    ),
  ],
  errorBuilder: (_, __) => const ErrorPage(),
);