
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A page displaying report details, often reached via a deep link with
/// both path and query parameters.
class ReportPage extends StatelessWidget {
  /// The ID of the report.
  final String? reportId;

  /// The query parameters associated with the report.
  final Map<String, String> queryParams;

  /// Constructs a [ReportPage].
  const ReportPage({
    required this.reportId,
    required this.queryParams,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Screen'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Report ID: ${reportId ?? "N/A"}',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 10),
              Text('Query Parameters:',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 5),
              if (queryParams.isEmpty)
                const Text('No query parameters found.')
              else
                ...queryParams.entries
                    .map<Widget>((MapEntry<String, String> entry) {
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
                onPressed: () => context.go('/'),
                child: const Text('Return to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}