// lib/services/bookmarks_provider.dart

import 'package:flutter/material.dart';
import 'db/database_service.dart';

class BookmarksProvider with ChangeNotifier {
  final _db = DatabaseService();
  List<Map<String, dynamic>> _bookmarks = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get bookmarks => _bookmarks;
  int get count => _bookmarks.length;
  bool get isLoading => _isLoading;

  BookmarksProvider() {
    _load();
  }

  bool isBookmarked(Map<String, dynamic> article) {
    final url = article['url'] as String? ?? '';
    return _bookmarks.any((b) => b['url'] == url);
  }

  Future<void> toggleBookmark(Map<String, dynamic> article) async {
    final url = article['url'] as String? ?? '';
    if (url.isEmpty) return;

    if (isBookmarked(article)) {
      _bookmarks.removeWhere((b) => b['url'] == url);
      notifyListeners();
      await _db.deleteBookmark(url);
    } else {
      final copy = Map<String, dynamic>.from(article)
        ..['bookmarkedAt'] = DateTime.now().toIso8601String();
      _bookmarks.insert(0, copy);
      notifyListeners();
      await _db.insertBookmark(article);
    }
  }

  Future<void> removeBookmark(String url) async {
    _bookmarks.removeWhere((b) => b['url'] == url);
    notifyListeners();
    await _db.deleteBookmark(url);
  }

  Future<void> clearAll() async {
    _bookmarks = [];
    notifyListeners();
    await _db.clearBookmarks();
  }

  Future<void> _load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _bookmarks = await _db.getBookmarks();
    } catch (e) {
      debugPrint('BookmarksProvider load error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}