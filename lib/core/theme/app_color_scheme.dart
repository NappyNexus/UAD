import 'package:flutter/material.dart';

/// Custom theme extension carrying the full UNAD color palette.
/// Access via: `Theme.of(context).extension<AppColorScheme>()!`
/// Or shorthand: `context.appColors`
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;
  final Color cardColor;
  final Color inputFill;
  final Color border;
  final Color borderMedium;
  final Color divider;
  final Color background;
  final Color surface;

  const AppColorScheme({
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.cardColor,
    required this.inputFill,
    required this.border,
    required this.borderMedium,
    required this.divider,
    required this.background,
    required this.surface,
  });

  /// Light mode instance.
  static const light = AppColorScheme(
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF6B7280),
    textTertiary: Color(0xFF9CA3AF),
    textDisabled: Color(0xFFD1D5DB),
    cardColor: Color(0xFFFFFFFF),
    inputFill: Color(0xFFF9FAFB),
    border: Color(0xFFF3F4F6),
    borderMedium: Color(0xFFE5E7EB),
    divider: Color(0xFFF3F4F6),
    background: Color(0xFFF9FAFB),
    surface: Color(0xFFFFFFFF),
  );

  /// Dark mode instance.
  static const dark = AppColorScheme(
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF94A3B8),
    textTertiary: Color(0xFF64748B),
    textDisabled: Color(0xFF475569),
    cardColor: Color(0xFF1E293B),
    inputFill: Color(0xFF0F172A),
    border: Color(0xFF334155),
    borderMedium: Color(0xFF334155),
    divider: Color(0xFF334155),
    background: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
  );

  @override
  AppColorScheme copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? cardColor,
    Color? inputFill,
    Color? border,
    Color? borderMedium,
    Color? divider,
    Color? background,
    Color? surface,
  }) {
    return AppColorScheme(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      cardColor: cardColor ?? this.cardColor,
      inputFill: inputFill ?? this.inputFill,
      border: border ?? this.border,
      borderMedium: borderMedium ?? this.borderMedium,
      divider: divider ?? this.divider,
      background: background ?? this.background,
      surface: surface ?? this.surface,
    );
  }

  @override
  AppColorScheme lerp(
    covariant ThemeExtension<AppColorScheme>? other,
    double t,
  ) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderMedium: Color.lerp(borderMedium, other.borderMedium, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
    );
  }
}

/// Shorthand to access [AppColorScheme] from [BuildContext].
extension AppColorSchemeContext on BuildContext {
  AppColorScheme get appColors =>
      Theme.of(this).extension<AppColorScheme>() ?? AppColorScheme.light;
}
