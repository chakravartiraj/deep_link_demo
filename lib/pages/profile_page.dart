import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A simple profile page.
class ProfilePage extends StatelessWidget {
  /// Constructs a [ProfilePage].
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Your Profile',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            ElevatedButton(
              // Changed from context.pop() to context.go('/') to prevent "nothing to pop" error
              // when ProfilePage is reached via context.go() from HomePage.
              onPressed: () => context.go('/'),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}