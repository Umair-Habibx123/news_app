// lib/services/search_provider.dart

import 'package:flutter/material.dart';
import 'db/database_service.dart';

class SearchProvider with ChangeNotifier {
  final _db = DatabaseService();
  List<String> _history = [];
  String _currentQuery = '';

  List<String> get history => _history;
  String get currentQuery => _currentQuery;

  SearchProvider() {
    _loadHistory();
  }

  void setQuery(String query) {
    _currentQuery = query;
    notifyListeners();
  }

  Future<void> addToHistory(String query) async {
    if (query.trim().isEmpty) return;
    _history.remove(query);
    _history.insert(0, query);
    if (_history.length > 10) _history = _history.sublist(0, 10);
    notifyListeners();
    await _db.insertSearchQuery(query);
  }

  Future<void> removeFromHistory(String query) async {
    _history.remove(query);
    notifyListeners();
    await _db.deleteSearchQuery(query);
  }

  Future<void> clearHistory() async {
    _history = [];
    notifyListeners();
    await _db.clearSearchHistory();
  }

  Future<void> _loadHistory() async {
    try {
      _history = await _db.getSearchHistory();
      notifyListeners();
    } catch (e) {
      debugPrint('SearchProvider load error: $e');
    }
  }
}