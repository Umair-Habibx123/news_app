// lib/services/theme_provider.dart

import 'package:flutter/material.dart';
import 'db/database_service.dart';

/// Manages the app's light/dark/system theme and persists the choice.
///
/// Fixes the "click twice to switch theme" bug: previously the toggle only
/// compared against [ThemeMode.dark], so when the app was following the system
/// theme (the default) the first tap produced no visible change. We now resolve
/// the *effective* brightness — including the OS setting when in system mode —
/// so a single tap always flips what the user actually sees.
class ThemeProvider with ChangeNotifier {
  static const String _key = 'theme_mode';
  final _db = DatabaseService();
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    _load();
  }

  ThemeMode get themeMode => _themeMode;

  /// The brightness actually shown on screen right now, accounting for the OS
  /// setting when [_themeMode] is [ThemeMode.system].
  bool get isDark {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  /// Flips between light and dark based on what is *currently visible*, so the
  /// first tap always works even when starting from system mode.
  Future<void> toggleTheme() async {
    await setTheme(isDark ? ThemeMode.light : ThemeMode.dark);
  }

  Future<void> setTheme(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    try {
      await _db.setSetting(_key, mode.name);
    } catch (e) {
      debugPrint('ThemeProvider save error: $e');
    }
  }

  Future<void> _load() async {
    try {
      final saved = await _db.getSetting(_key);
      if (saved != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (e) => e.name == saved,
          orElse: () => ThemeMode.system,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('ThemeProvider load error: $e');
    }
  }
}
