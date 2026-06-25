// lib/services/locale_provider.dart

import 'package:flutter/material.dart';
import 'db/database_service.dart';
import '../l10n/app_localizations.dart';

/// Manages the app's UI language and persists the choice.
///
/// This is the *app interface* language (buttons, labels, settings). It is
/// separate from the news-content language used by the NewsAPI requests.
class LocaleProvider with ChangeNotifier {
  static const String _key = 'app_locale';
  final _db = DatabaseService();
  Locale _locale = const Locale('en');

  LocaleProvider() {
    _load();
  }

  Locale get locale => _locale;

  bool get isRtl => AppLocalizations.isRtl(_locale.languageCode);

  Future<void> setLocale(Locale locale) async {
    if (!AppLocalizations.supportedLocales
        .any((l) => l.languageCode == locale.languageCode)) {
      return;
    }
    if (_locale.languageCode == locale.languageCode) return;
    _locale = locale;
    notifyListeners();
    try {
      await _db.setSetting(_key, locale.languageCode);
    } catch (e) {
      debugPrint('LocaleProvider save error: $e');
    }
  }

  Future<void> _load() async {
    try {
      final saved = await _db.getSetting(_key);
      if (saved != null &&
          AppLocalizations.supportedLocales
              .any((l) => l.languageCode == saved)) {
        _locale = Locale(saved);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('LocaleProvider load error: $e');
    }
  }
}
