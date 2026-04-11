import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'viewmodels/app_preferences_viewmodel.dart';

/// Root widget for the UniPortal ADU application.
class UnadApp extends ConsumerWidget {
  const UnadApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final prefs = ref.watch(appPreferencesProvider);

    // Sync theme flags so every AppColors getter resolves correctly.
    AppColors.updateBrightness(prefs.isDarkMode);
    AppColors.updateAccent(prefs.accentColor);

    return MaterialApp.router(
      title: 'UNAD',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightWithAccent(prefs.accentColor),
      darkTheme: AppTheme.darkWithAccent(prefs.accentColor),
      themeMode: prefs.themeMode,
      routerConfig: router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(prefs.fontScaleFactor)),
          child: child!,
        );
      },
    );
  }
}
