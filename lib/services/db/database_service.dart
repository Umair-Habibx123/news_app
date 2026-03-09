// lib/services/database_service.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'news_app.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE if NOT EXISTS bookmarks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            url TEXT UNIQUE NOT NULL,
            data TEXT NOT NULL,
            bookmarked_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE if NOT EXISTS search_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            query TEXT UNIQUE NOT NULL,
            searched_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE if NOT EXISTS app_settings (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // ─── Bookmarks ─────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getBookmarks() async {
    final db = await database;
    final rows = await db.query(
      'bookmarks',
      orderBy: 'bookmarked_at DESC',
    );
    return rows.map((row) {
      final article = Map<String, dynamic>.from(
        json.decode(row['data'] as String),
      );
      article['bookmarkedAt'] = row['bookmarked_at'];
      return article;
    }).toList();
  }

  Future<bool> isBookmarked(String url) async {
    final db = await database;
    final result = await db.query(
      'bookmarks',
      where: 'url = ?',
      whereArgs: [url],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<void> insertBookmark(Map<String, dynamic> article) async {
    final db = await database;
    final articleCopy = Map<String, dynamic>.from(article);
    final url = articleCopy['url'] as String? ?? '';
    if (url.isEmpty) return;

    await db.insert(
      'bookmarks',
      {
        'url': url,
        'data': json.encode(articleCopy),
        'bookmarked_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteBookmark(String url) async {
    final db = await database;
    await db.delete('bookmarks', where: 'url = ?', whereArgs: [url]);
  }

  Future<void> clearBookmarks() async {
    final db = await database;
    await db.delete('bookmarks');
  }

  // ─── Search History ────────────────────────────────────────────

  Future<List<String>> getSearchHistory() async {
    final db = await database;
    final rows = await db.query(
      'search_history',
      orderBy: 'searched_at DESC',
      limit: 10,
    );
    return rows.map((row) => row['query'] as String).toList();
  }

  Future<void> insertSearchQuery(String query) async {
    if (query.trim().isEmpty) return;
    final db = await database;
    await db.insert(
      'search_history',
      {
        'query': query.trim(),
        'searched_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // Keep only last 10
    await db.rawDelete('''
      DELETE FROM search_history
      WHERE id NOT IN (
        SELECT id FROM search_history ORDER BY searched_at DESC LIMIT 10
      )
    ''');
  }

  Future<void> deleteSearchQuery(String query) async {
    final db = await database;
    await db.delete('search_history', where: 'query = ?', whereArgs: [query]);
  }

  Future<void> clearSearchHistory() async {
    final db = await database;
    await db.delete('search_history');
  }

  // ─── App Settings ──────────────────────────────────────────────

  Future<String?> getSetting(String key) async {
    final db = await database;
    final rows = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['value'] as String?;
  }

  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'app_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> close() async {
    final db = _db;
    if (db != null) {
      await db.close();
      _db = null;
    }
  }
}