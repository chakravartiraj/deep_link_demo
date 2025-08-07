import 'package:flutter/material.dart';
import 'package:myapp/core/constants/app_constants.dart';
import 'package:go_router/go_router.dart';

/// A generic error page for unmatched routes.
class ErrorPage extends StatelessWidget {
  /// Constructs an [ErrorPage].
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            SizedBox(height: AppConstants.defaultPadding),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: AppConstants.defaultPadding),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.homeRoute),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
