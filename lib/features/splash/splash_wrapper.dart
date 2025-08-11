import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'pages/splash_page.dart';
import 'package:myapp/features/home/home.dart';
import 'package:myapp/features/landing/landing.dart';

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _showSplash = true;

  void _onSplashComplete() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashPage(onComplete: _onSplashComplete);
    }

    // After splash, show appropriate page based on platform
    if (kIsWeb) {
      return const LandingPage();
    }
    return const HomePage();
  }
}
