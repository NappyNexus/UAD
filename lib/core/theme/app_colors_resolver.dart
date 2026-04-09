import 'package:flutter/material.dart';
import 'app_colors.dart';

/// A zero-overhead resolver that maps static AppColors to
/// theme-aware versions. Called once per build method:
///   final r = AppColorsResolver(context);
///   // Then use r.textPrimary, r.cardColor, etc.
class AppColorsResolver {
  final bool isDark;
  AppColorsResolver(BuildContext context)
    : isDark = Theme.of(context).brightness == Brightness.dark;

  Color get textPrimary =>
      isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
  Color get textSecondary =>
      isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
  Color get textTertiary =>
      isDark ? AppColors.darkTextTertiary : AppColors.textTertiary;
  Color get textDisabled =>
      isDark ? const Color(0xFF475569) : AppColors.textDisabled;
  Color get cardColor => isDark ? AppColors.darkSurface : Colors.white;
  Color get background =>
      isDark ? AppColors.darkBackground : AppColors.background;
  Color get surface => isDark ? AppColors.darkSurface : AppColors.surface;
  Color get inputFill =>
      isDark ? AppColors.darkBackground : AppColors.background;
  Color get border => isDark ? AppColors.darkBorder : AppColors.border;
  Color get borderMedium =>
      isDark ? AppColors.darkBorder : AppColors.borderMedium;
  Color get divider => isDark ? AppColors.darkBorder : AppColors.divider;
}
