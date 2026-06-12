import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted theme mode controller.
///
/// Supports following the system theme, or manually forcing
/// light/dark mode. The chosen mode is persisted via SharedPreferences.
class ThemeController extends ChangeNotifier {
  static const _prefsKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  /// Load the persisted theme mode (call once at app startup).
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKey);
    switch (stored) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  /// Update and persist the theme mode.
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    switch (mode) {
      case ThemeMode.light:
        await prefs.setString(_prefsKey, 'light');
        break;
      case ThemeMode.dark:
        await prefs.setString(_prefsKey, 'dark');
        break;
      case ThemeMode.system:
        await prefs.setString(_prefsKey, 'system');
        break;
    }
  }

  /// Convenience toggle between light and dark (ignores system).
  Future<void> toggleLightDark() async {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final isCurrentlyDark = _themeMode == ThemeMode.dark ||
        (_themeMode == ThemeMode.system && brightness == Brightness.dark);
    await setThemeMode(isCurrentlyDark ? ThemeMode.light : ThemeMode.dark);
  }
}