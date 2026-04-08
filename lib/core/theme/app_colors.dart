import 'package:flutter/material.dart';

/// UNAD brand color palette — extracted from the React/Tailwind prototype.
class AppColors {
  AppColors._();

  // ─── Primary (UNAD Green) ────────────────────────────────────────
  static const Color primary = Color(0xFF026A45);
  static const Color primaryLight = Color(0xFF038556);
  static const Color primaryDark = Color(0xFF015A3A);
  static const Color primarySurface = Color(0x0D026A45); // 5% opacity

  // ─── Accent (UNAD Gold) ──────────────────────────────────────────
  static const Color gold = Color(0xFFF9C029);
  static const Color goldLight = Color(0xFFFAD45C);
  static const Color goldDark = Color(0xFFE5AC0E);
  static const Color goldSurface = Color(0x1AF9C029); // 10% opacity

  // ─── Neutrals (Light mode) ───────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF9FAFB); // gray-50
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFF3F4F6); // gray-100
  static const Color borderMedium = Color(0xFFE5E7EB); // gray-200
  static const Color divider = Color(0xFFF3F4F6);

  // ─── Text (Light mode) ───────────────────────────────────────────
  static const Color textPrimary = Color(0xFF111827); // gray-900
  static const Color textSecondary = Color(0xFF6B7280); // gray-500
  static const Color textTertiary = Color(0xFF9CA3AF); // gray-400
  static const Color textDisabled = Color(0xFFD1D5DB); // gray-300

  // ─── Dark Mode ───────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF94A3B8); // slate-400
  static const Color darkTextTertiary = Color(0xFF64748B); // slate-500

  // ─── Semantic Colors ─────────────────────────────────────────────
  static const Color success = Color(0xFF059669); // emerald-600
  static const Color successLight = Color(0xFFD1FAE5); // emerald-100
  static const Color successSurface = Color(0xFFECFDF5); // emerald-50
  static const Color successText = Color(0xFF047857); // emerald-700

  static const Color warning = Color(0xFFD97706); // amber-600
  static const Color warningLight = Color(0xFFFDE68A); // amber-200
  static const Color warningSurface = Color(0xFFFFFBEB); // amber-50
  static const Color warningText = Color(0xFFB45309); // amber-700

  static const Color error = Color(0xFFDC2626); // red-600
  static const Color errorLight = Color(0xFFFECACA); // red-200
  static const Color errorSurface = Color(0xFFFEF2F2); // red-50
  static const Color errorText = Color(0xFFB91C1C); // red-700

  static const Color info = Color(0xFF2563EB); // blue-600
  static const Color infoLight = Color(0xFFBFDBFE); // blue-200
  static const Color infoSurface = Color(0xFFEFF6FF); // blue-50
  static const Color infoText = Color(0xFF1D4ED8); // blue-700

  // ─── Role Gradients ──────────────────────────────────────────────
  static const List<Color> studentGradient = [
    Color(0xFF10B981), // emerald-500
    Color(0xFF026A45), // primary
  ];

  static const List<Color> professorGradient = [
    Color(0xFF3B82F6), // blue-500
    Color(0xFF1D4ED8), // blue-700
  ];

  static const List<Color> adminGradient = [
    Color(0xFF8B5CF6), // violet-500
    Color(0xFF7C3AED), // purple-600
  ];

  static const List<Color> registrarGradient = [
    Color(0xFFF59E0B), // amber-400
    Color(0xFFF97316), // orange-500
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
    return statusColors[status] ??
        const StatusBadgeColors(
          Color(0xFFF9FAFB),
          Color(0xFF6B7280),
          Color(0xFFE5E7EB),
        );
  }
}

/// Colors for a status badge: background, text, and border.
class StatusBadgeColors {
  final Color background;
  final Color text;
  final Color border;

  const StatusBadgeColors(this.background, this.text, this.border);
}
