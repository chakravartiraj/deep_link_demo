import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_router.dart';
import 'app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the themeNotifier to rebuild when the theme mode changes
    final themeMode = ref.watch(themeProvider.notifier).materialThemeMode;

    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Deep-Link Navigation App', // Consider moving title to a const
      theme: AppTheme.lightTheme, // Use light theme from AppTheme
      darkTheme: AppTheme.darkTheme, // Use dark theme from AppTheme
      themeMode: themeMode, // Use themeMode from ThemeProvider
      debugShowCheckedModeBanner: false,
    );
  }
}
