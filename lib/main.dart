import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
import 'app.dart';
import 'viewmodels/app_preferences_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-load preferences before the app starts to prevent flickering and black screens.
  final initialPrefs = await AppPreferencesNotifier.loadFromDisk();

  // Enable runtime fetching so fonts can be downloaded if not bundled.
  GoogleFonts.config.allowRuntimeFetching = true;

  // Set system UI overlay style for green status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Global error handler for Flutter frame errors.
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
  };

  // Global error handler for all asynchronous and platform-level errors.
  // Returning true prevents the error from being treated as an uncaught exception,
  // which stops the debugger from pausing the app mid-flow.
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    debugPrint('Uncaught Async Error: $error');
    return true;
  };

  runApp(
    ProviderScope(
      overrides: [
        appPreferencesProvider.overrideWith(
          (ref) => AppPreferencesNotifier(initialPrefs),
        ),
      ],
      child: const UnadApp(),
    ),
  );
}
