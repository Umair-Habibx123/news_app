// lib/services/theme_provider.dart

import 'package:flutter/material.dart';
import 'db/database_service.dart';

class ThemeProvider with ChangeNotifier {
  static const String _key = 'theme_mode';
  final _db = DatabaseService();
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _load();
  }

  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    await _db.setSetting(_key, _themeMode.name);
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _db.setSetting(_key, mode.name);
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