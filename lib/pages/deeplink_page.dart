import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A page specifically designed to display deep link parameters.
///
/// This simulates a deep link target that might be opened via an external
/// service like flowlinks.app.
class DeepLinkPage extends StatelessWidget {
  /// The query parameters extracted from the deep link URL.
  final Map<String, String> queryParams;

  /// Constructs a [DeepLinkPage].
  const DeepLinkPage({required this.queryParams, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep Link Screen'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Deep Link Data Received:',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 10),
              if (queryParams.isEmpty)
                const Text('No query parameters found.')
              else
                ...queryParams.entries.map<Widget>((MapEntry<String, String> entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '${entry.key}: ${entry.value}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => context.go('/'), // Navigate back to home, replacing the stack
                child: const Text('Return to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}