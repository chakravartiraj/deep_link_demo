import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A page displaying details based on a passed ID.
class DetailsPage extends StatelessWidget {
  /// The ID of the item to display details for.\n
  final String? detailId;

  /// Constructs a [DetailsPage].\n
  const DetailsPage({required this.detailId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Detail ID: ${detailId ?? "N/A"}',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}