import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The home page of the application.
///
/// This page provides navigation options to other pages, a dialog, and a
/// bottom sheet.
class HomePage extends StatelessWidget {
  /// Constructs a [HomePage].
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => context.go('/profile'),
              child: const Text('Go to Profile (Replace)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/details/custom_item'),
              child: const Text('Go to Details (Push)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showConfirmationDialog(context),
              child: const Text('Show Dialog'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showCustomBottomSheet(context),
              child: const Text('Show Bottom Sheet'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/deeplink?source=homepage&data=abc'),
              child: const Text('Simulate Deep Link Nav'),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows a confirmation dialog.
  ///
  /// This dialog demonstrates an "on tap dialog navigation" experience.
  void _showConfirmationDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Dialog Example'),
          content: const Text('This is a custom dialog invoked from a route.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Action confirmed!')),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Shows a custom bottom sheet.
  ///
  /// This bottom sheet demonstrates an "on tap bottomsheet navigation" experience.
  void _showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext bottomSheetContext) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('This is a custom bottom sheet.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  child: const Text('Close Bottom Sheet'),
                  onPressed: () => Navigator.pop(bottomSheetContext),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}