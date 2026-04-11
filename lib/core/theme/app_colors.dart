import 'package:flutter/material.dart';

/// UNAD brand color palette — extracted from the React/Tailwind prototype.
///
/// Theme-dependent colors use a static [_isDark] flag set by the root widget
/// so every existing `AppColors.textPrimary` reference automatically resolves
/// to the correct value for the current brightness.
class AppColors {
  AppColors._();

  // ─── Runtime theme resolver ──────────────────────────────────────
  static bool _isDark = false;

  /// Call from the root widget's build to sync the brightness flag.
  static void updateBrightness(bool isDark) => _isDark = isDark;

  static Color _accent = const Color(0xFF026A45);

  /// Update the global accent color and its variants.
  static void updateAccent(Color color) => _accent = color;

  // ─── Primary (Dynamic Accent) ───────────────────────────────────
  static Color get primary => _accent;

  static Color get primaryLight {
    final hsl = HSLColor.fromColor(_accent);
    return hsl.withLightness((hsl.lightness + 0.1).clamp(0.0, 1.0)).toColor();
  }

  static Color get primaryDark {
    final hsl = HSLColor.fromColor(_accent);
    return hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0)).toColor();
  }

  static Color get primarySurface => _accent.withValues(alpha: 0.08);

  // ─── Accent (UNAD Gold) — fixed across themes ───────────────────
  static const Color gold = Color(0xFFF9C029);
  static const Color goldLight = Color(0xFFFAD45C);
  static const Color goldDark = Color(0xFFE5AC0E);
  static const Color goldSurface = Color(0x1AF9C029);

  // ─── Light-only constants (used internally) ─────────────────────
  static const Color _lightBackground = Color(0xFFF9FAFB);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightBorder = Color(0xFFF3F4F6);
  static const Color _lightBorderMedium = Color(0xFFE5E7EB);
  static const Color _lightDivider = Color(0xFFF3F4F6);
  static const Color _lightTextPrimary = Color(0xFF111827);
  static const Color _lightTextSecondary = Color(0xFF6B7280);
  static const Color _lightTextTertiary = Color(0xFF9CA3AF);
  static const Color _lightTextDisabled = Color(0xFFD1D5DB);

  // ─── Dark-only constants (used internally) ──────────────────────
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF64748B);
  static const Color _darkTextDisabled = Color(0xFF475569);

  // ─── Theme-aware neutrals ───────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static Color get background => _isDark ? darkBackground : _lightBackground;
  static Color get surface => _isDark ? darkSurface : _lightSurface;
  static Color get border => _isDark ? darkBorder : _lightBorder;
  static Color get borderMedium => _isDark ? darkBorder : _lightBorderMedium;
  static Color get divider => _isDark ? darkBorder : _lightDivider;
  static Color get cardColor => _isDark ? darkSurface : _lightSurface;
  static Color get inputFill => _isDark ? darkBackground : _lightBackground;

  // ─── Theme-aware text ───────────────────────────────────────────
  static Color get textPrimary => _isDark ? darkTextPrimary : _lightTextPrimary;
  static Color get textSecondary =>
      _isDark ? darkTextSecondary : _lightTextSecondary;
  static Color get textTertiary =>
      _isDark ? darkTextTertiary : _lightTextTertiary;
  static Color get textDisabled =>
      _isDark ? _darkTextDisabled : _lightTextDisabled;

  // ─── Semantic Colors — fixed across themes ──────────────────────
  static const Color success = Color(0xFF059669);
  static Color get successLight =>
      _isDark ? success.withValues(alpha: 0.2) : const Color(0xFFD1FAE5);
  static Color get successSurface =>
      _isDark ? success.withValues(alpha: 0.1) : const Color(0xFFECFDF5);
  static const Color successText = Color(0xFF047857);

  static const Color warning = Color(0xFFD97706);
  static Color get warningLight =>
      _isDark ? warning.withValues(alpha: 0.2) : const Color(0xFFFDE68A);
  static Color get warningSurface =>
      _isDark ? warning.withValues(alpha: 0.1) : const Color(0xFFFFFBEB);
  static const Color warningText = Color(0xFFB45309);

  static const Color error = Color(0xFFDC2626);
  static Color get errorLight =>
      _isDark ? error.withValues(alpha: 0.2) : const Color(0xFFFECACA);
  static Color get errorSurface =>
      _isDark ? error.withValues(alpha: 0.1) : const Color(0xFFFEF2F2);
  static const Color errorText = Color(0xFFB91C1C);

  static const Color info = Color(0xFF2563EB);
  static Color get infoLight =>
      _isDark ? info.withValues(alpha: 0.2) : const Color(0xFFBFDBFE);
  static Color get infoSurface =>
      _isDark ? info.withValues(alpha: 0.1) : const Color(0xFFEFF6FF);
  static const Color infoText = Color(0xFF1D4ED8);

  // ─── Role Gradients ──────────────────────────────────────────────
  static const List<Color> studentGradient = [
    Color(0xFF10B981),
    Color(0xFF026A45),
  ];

  static const List<Color> professorGradient = [
    Color(0xFF3B82F6),
    Color(0xFF1D4ED8),
  ];

  static const List<Color> adminGradient = [
    Color(0xFF8B5CF6),
    Color(0xFF7C3AED),
  ];

  static const List<Color> registrarGradient = [
    Color(0xFFF59E0B),
    Color(0xFFF97316),
  ];

  // ─── Role-Specific ──────────────────────────────────────────────
  static const Color professorBlue = Color(0xFF2563EB);
  static const Color adminPurple = Color(0xFF7C3AED);
  static const Color registrarAmber = Color(0xFFD97706);

  // ─── Status Badge Colors ─────────────────────────────────────────
  static const Map<String, StatusBadgeColors> statusColors = {
    'Activo': StatusBadgeColors(
      Color(0xFFECFDF5),
      Color(0xFF047857),
      Color(0xFFA7F3D0),
    ),
    'Pagado': StatusBadgeColors(
      Color(0xFFECFDF5),
      Color(0xFF047857),
      Color(0xFFA7F3D0),
    ),
    'Completada': StatusBadgeColors(
      Color(0xFFECFDF5),
      Color(0xFF047857),
      Color(0xFFA7F3D0),
    ),
    'Abierto': StatusBadgeColors(
      Color(0xFFECFDF5),
      Color(0xFF047857),
      Color(0xFFA7F3D0),
    ),
    'Emitido': StatusBadgeColors(
      Color(0xFFECFDF5),
      Color(0xFF047857),
      Color(0xFFA7F3D0),
    ),
    'En curso': StatusBadgeColors(
      Color(0xFFEFF6FF),
      Color(0xFF1D4ED8),
      Color(0xFFBFDBFE),
    ),
    'En proceso': StatusBadgeColors(
      Color(0xFFFFFBEB),
      Color(0xFFB45309),
      Color(0xFFFDE68A),
    ),
    'Pendiente': StatusBadgeColors(
      Color(0xFFFFFBEB),
      Color(0xFFB45309),
      Color(0xFFFDE68A),
    ),
    'Planificación': StatusBadgeColors(
      Color(0xFFF5F3FF),
      Color(0xFF7C3AED),
      Color(0xFFDDD6FE),
    ),
    'Probatoria': StatusBadgeColors(
      Color(0xFFFFF7ED),
      Color(0xFFC2410C),
      Color(0xFFFED7AA),
    ),
    'Suspendido': StatusBadgeColors(
      Color(0xFFFEF2F2),
      Color(0xFFB91C1C),
      Color(0xFFFECACA),
    ),
    'Inactivo': StatusBadgeColors(
      Color(0xFFF9FAFB),
      Color(0xFF6B7280),
      Color(0xFFE5E7EB),
    ),
    'Cerrado': StatusBadgeColors(
      Color(0xFFF9FAFB),
      Color(0xFF6B7280),
      Color(0xFFE5E7EB),
    ),
    'Cerrada': StatusBadgeColors(
      Color(0xFFF9FAFB),
      Color(0xFF6B7280),
      Color(0xFFE5E7EB),
    ),
    'Retiro': StatusBadgeColors(
      Color(0xFFF9FAFB),
      Color(0xFF6B7280),
      Color(0xFFE5E7EB),
    ),
    'Graduando': StatusBadgeColors(
      Color(0xFFEEF2FF),
      Color(0xFF4338CA),
      Color(0xFFC7D2FE),
    ),
    'Obligatoria': StatusBadgeColors(
      Color(0x0D026A45),
      Color(0xFF026A45),
      Color(0x33026A45),
    ),
    'Electiva': StatusBadgeColors(
      Color(0x1AF9C029),
      Color(0xFFE5AC0E),
      Color(0x4DF9C029),
    ),
    'General': StatusBadgeColors(
      Color(0xFFEFF6FF),
      Color(0xFF2563EB),
      Color(0xFFBFDBFE),
    ),
    'Aprobado': StatusBadgeColors(
      Color(0xFFECFDF5),
      Color(0xFF047857),
      Color(0xFFA7F3D0),
    ),
    'Rechazado': StatusBadgeColors(
      Color(0xFFFEF2F2),
      Color(0xFFB91C1C),
      Color(0xFFFECACA),
    ),
    'En revisión': StatusBadgeColors(
      Color(0xFFFFFBEB),
      Color(0xFFB45309),
      Color(0xFFFDE68A),
    ),
  };

  /// Get status badge colors, with a gray fallback for unknown statuses.
  static StatusBadgeColors getStatusColors(String status) {
    final base =
        statusColors[status] ??
        const StatusBadgeColors(
          Color(0xFFF9FAFB),
          Color(0xFF6B7280),
          Color(0xFFE5E7EB),
        );

    if (_isDark) {
      return StatusBadgeColors(
        base.text.withValues(alpha: 0.15),
        base.text.withAlpha(
          200,
        ), // Slightly subdued white-ish if we prefer or just text tone
        base.text.withValues(alpha: 0.3),
      );
    }

    return base;
  }
}

/// Colors for a status badge: background, text, and border.
class StatusBadgeColors {
  final Color background;
  final Color text;
  final Color border;

  const StatusBadgeColors(this.background, this.text, this.border);
}
