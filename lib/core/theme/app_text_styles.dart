import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable text styles for the UNAD design system.
///
/// Based on the React prototype's usage of Inter/system fonts,
/// uppercase labels, and specific font-weight patterns.
class AppTextStyles {
  AppTextStyles._();

  // ─── Heading ─────────────────────────────────────────────────────
  static TextStyle heading1(BuildContext context) => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.2,
  );

  static TextStyle heading2(BuildContext context) => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.2,
  );

  static TextStyle heading3(BuildContext context) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.3,
  );

  // ─── Body ────────────────────────────────────────────────────────
  static TextStyle bodyLarge(BuildContext context) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.5,
  );

  static TextStyle bodyMedium(BuildContext context) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.5,
  );

  static TextStyle bodySmall(BuildContext context) => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
    height: 1.5,
  );

  // ─── Labels ──────────────────────────────────────────────────────
  /// Uppercase tracking label (10px) — used for stat cards, section headers.
  static TextStyle labelUppercase(BuildContext context) => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
    letterSpacing: 1.5,
    height: 1.3,
  );

  static TextStyle labelSmall(BuildContext context) => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
    height: 1.3,
  );

  static TextStyle labelMedium(BuildContext context) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
    height: 1.3,
  );

  // ─── Stat Values ─────────────────────────────────────────────────
  /// Large bold value used in stat cards (xl font, bold).
  static TextStyle statValue(BuildContext context) => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.1,
  );

  /// Big stat value used in reports (2xl font, bold).
  static TextStyle statValueLarge(BuildContext context) => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.1,
  );

  // ─── Titles (card titles, list item titles) ──────────────────────
  static TextStyle cardTitle(BuildContext context) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.3,
  );

  static TextStyle listTitle(BuildContext context) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.3,
  );

  // ─── Subtitles ───────────────────────────────────────────────────
  static TextStyle subtitle(BuildContext context) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
    height: 1.4,
  );

  static TextStyle subtitleSmall(BuildContext context) => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
    height: 1.3,
  );

  // ─── Button ──────────────────────────────────────────────────────
  static TextStyle buttonMedium(BuildContext context) =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, height: 1.2);

  static TextStyle buttonSmall(BuildContext context) =>
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, height: 1.2);

  // ─── Navigation ──────────────────────────────────────────────────
  static TextStyle navLabel(BuildContext context) =>
      GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, height: 1.2);

  static TextStyle drawerItem(BuildContext context) =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, height: 1.3);

  // ─── Badge ───────────────────────────────────────────────────────
  static TextStyle badge(BuildContext context) =>
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, height: 1.0);

  static TextStyle badgeSmall(BuildContext context) =>
      GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, height: 1.0);
}
