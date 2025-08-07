import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Minimal web-specific optimizations
  if (kIsWeb) {
    // Basic web optimization
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  // Set preferred orientations for mobile only
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  runApp(ProviderScope(child: MyApp()));
}
