import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// State class holding all appearance preferences.
class AppPreferencesState {
  final ThemeMode themeMode;
  final int fontSizeIndex; // 0=small, 1=medium, 2=large
  final String accentColorHex;

  const AppPreferencesState({
    this.themeMode = ThemeMode.light,
    this.fontSizeIndex = 1,
    this.accentColorHex = '#026a45',
  });

  bool get isDarkMode => themeMode == ThemeMode.dark;

  double get fontScaleFactor {
    switch (fontSizeIndex) {
      case 0:
        return 0.85;
      case 2:
        return 1.15;
      default:
        return 1.0;
    }
  }

  Color get accentColor =>
      Color(int.parse(accentColorHex.replaceFirst('#', '0xFF')));

  AppPreferencesState copyWith({
    ThemeMode? themeMode,
    int? fontSizeIndex,
    String? accentColorHex,
  }) {
    return AppPreferencesState(
      themeMode: themeMode ?? this.themeMode,
      fontSizeIndex: fontSizeIndex ?? this.fontSizeIndex,
      accentColorHex: accentColorHex ?? this.accentColorHex,
    );
  }
}

/// ViewModel that persists appearance preferences using SharedPreferences.
class AppPreferencesNotifier extends StateNotifier<AppPreferencesState> {
  AppPreferencesNotifier([AppPreferencesState? initialState])
    : super(initialState ?? const AppPreferencesState()) {
    if (initialState == null) {
      _loadPreferences();
    }
  }

  static const _keyDarkMode = 'unad_dark_mode';
  static const _keyFontSize = 'unad_font_size';
  static const _keyAccentColor = 'unad_accent_color';

  /// Static helper to load preferences directly from disk without creating a notifier.
  /// Useful for pre-loading state in main().
  static Future<AppPreferencesState> loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_keyDarkMode) ?? false;
    final fontSize = prefs.getInt(_keyFontSize) ?? 1;
    final accent = prefs.getString(_keyAccentColor) ?? '#026a45';

    return AppPreferencesState(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      fontSizeIndex: fontSize,
      accentColorHex: accent,
    );
  }

  Future<void> _loadPreferences() async {
    final loaded = await loadFromDisk();
    state = loaded;
  }

  Future<void> setDarkMode(bool enabled) async {
    state = state.copyWith(
      themeMode: enabled ? ThemeMode.dark : ThemeMode.light,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, enabled);
  }

  Future<void> setFontSize(int index) async {
    state = state.copyWith(fontSizeIndex: index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyFontSize, index);
  }

  Future<void> setAccentColor(String hex) async {
    state = state.copyWith(accentColorHex: hex);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccentColor, hex);
  }
}

/// Provider for [AppPreferencesNotifier].
final appPreferencesProvider =
    StateNotifierProvider<AppPreferencesNotifier, AppPreferencesState>(
      (ref) => AppPreferencesNotifier(),
    );
