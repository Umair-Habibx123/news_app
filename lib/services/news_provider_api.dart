// lib/services/news_provider_api.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

enum NewsEndpoint { topHeadlines, everything }

enum SortBy { publishedAt, relevancy, popularity }

class NewsProviderApi with ChangeNotifier {
  static const String _baseUrl = 'https://newsapi.org/v2';
  final String _apiKey = dotenv.env['API_KEY_UMAIR'] ?? '';

  String _category = 'general';
  String _source = '';
  String _searchQuery = '';
  String _country = 'us';

  // Language is ONLY used with /v2/everything — not supported by /top-headlines
  // Default: 'en'. Must be one of the 14 supported codes below.
  String _language = 'en';

  SortBy _sortBy = SortBy.publishedAt;
  NewsEndpoint _endpoint = NewsEndpoint.topHeadlines;
  int _page = 1;
  int _totalResults = 0;
  bool _isFetching = false;
  String _errorMessage = '';
  List<Map<String, dynamic>> _articles = [];
  List<Map<String, dynamic>> _trendingArticles = [];

  Timer? _debounceTimer;
  http.Client? _httpClient;

  List<Map<String, dynamic>> get articles => _articles;
  List<Map<String, dynamic>> get trendingArticles => _trendingArticles;
  bool get isFetching => _isFetching;
  String get errorMessage => _errorMessage;
  int get totalResults => _totalResults;
  bool get hasMore => _articles.length < _totalResults;
  String get currentCategory => _category;
  String get currentSource => _source;
  String get currentLanguage => _language;
  SortBy get currentSortBy => _sortBy;

  /// Whether language filtering is active (only applies on /everything)
  bool get isLanguageFilterActive => _endpoint == NewsEndpoint.everything || _searchQuery.isNotEmpty;

  static const List<String> categories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  /// Supported language codes for /v2/everything.
  /// Parsed from the API's documented string: "ardeenesfrheitnlnoptrusvudzh"
  /// → ar, de, en, es, fr, he, it, nl, no, pt, ru, sv, ud, zh
  ///
  /// NOTE: /v2/top-headlines does NOT accept a language parameter at all.
  static const Map<String, String> supportedLanguages = {
    'ar': 'Arabic',
    'de': 'German',
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'he': 'Hebrew',
    'it': 'Italian',
    'nl': 'Dutch',
    'no': 'Norwegian',
    'pt': 'Portuguese',
    'ru': 'Russian',
    'sv': 'Swedish',
    'ud': 'Urdu',
    'zh': 'Chinese',
  };

  static const List<Map<String, String>> popularSources = [
    {'id': '', 'name': 'All Sources'},
    {'id': 'bbc-news', 'name': 'BBC News'},
    {'id': 'cnn', 'name': 'CNN'},
    {'id': 'the-verge', 'name': 'The Verge'},
    {'id': 'techcrunch', 'name': 'TechCrunch'},
    {'id': 'reuters', 'name': 'Reuters'},
    {'id': 'al-jazeera-english', 'name': 'Al Jazeera'},
    {'id': 'ars-technica', 'name': 'Ars Technica'},
    {'id': 'wired', 'name': 'Wired'},
    {'id': 'bloomberg', 'name': 'Bloomberg'},
    {'id': 'engadget', 'name': 'Engadget'},
    {'id': 'the-guardian-uk', 'name': 'The Guardian'},
  ];

  NewsProviderApi() {
    _httpClient = http.Client();
    // Schedule first fetch after construction completes
    Future.microtask(() {
      _fetchNewsDebounced();
      _fetchTrending();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _httpClient?.close();
    super.dispose();
  }

  void _fetchNewsDebounced() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), fetchNews);
  }

  // ─── Public API ────────────────────────────────────────────────

  Future<void> fetchNews({bool refresh = false}) async {
    if (_isFetching) return;
    if (refresh) _resetState();
    _isFetching = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final url = _buildApiUrl();
      final response = await _httpClient!.get(Uri.parse(url));
      final data = _parseResponse(response);
      if (data != null) _handleSuccessfulResponse(data);
    } catch (e) {
      _handleError(e);
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  Future<void> refreshNews() => fetchNews(refresh: true);

  Future<void> loadMore() async {
    if (_isFetching || !hasMore) return;
    await fetchNews();
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }
    _searchQuery = query.trim();
    _endpoint = NewsEndpoint.everything;
    _resetState();
    await fetchNews();
  }

  void clearSearch() {
    _searchQuery = '';
    _endpoint = NewsEndpoint.topHeadlines;
    _resetState();
    _fetchNewsDebounced();
  }

  void setCategory(String category) {
    if (_category == category && _source.isEmpty) return;
    _source = '';
    _searchQuery = '';
    _endpoint = NewsEndpoint.topHeadlines;
    _category = category;
    _resetState();
    _fetchNewsDebounced();
  }

  void setSource(String source) {
    if (_source == source) return;
    _source = source;
    _searchQuery = '';
    _endpoint = NewsEndpoint.topHeadlines;
    _resetState();
    _fetchNewsDebounced();
  }

  /// Sets the language filter — only takes effect on /v2/everything.
  /// Silently ignores codes not in [supportedLanguages].
  void setLanguage(String language) {
    if (!supportedLanguages.containsKey(language)) return;
    if (_language == language) return;
    _language = language;
    _resetState();
    _fetchNewsDebounced();
  }

  void setSortBy(SortBy sortBy) {
    if (_sortBy == sortBy) return;
    _sortBy = sortBy;
    _resetState();
    _fetchNewsDebounced();
  }

  void setCountry(String country) {
    if (_country == country) return;
    _country = country;
    _resetState();
    _fetchNewsDebounced();
  }

  // ─── URL Builder ──────────────────────────────────────────────

  String _buildApiUrl() {
    // Use /everything when searching or when endpoint is explicitly set
    if (_endpoint == NewsEndpoint.everything || _searchQuery.isNotEmpty) {
      final params = <String, String>{
        'q': _searchQuery.isNotEmpty ? _searchQuery : _category,
        'language': _language, // ✅ only /everything supports this
        'sortBy': _sortByString,
        'apiKey': _apiKey,
        'page': _page.toString(),
        'pageSize': '20',
      };
      return Uri.parse('$_baseUrl/everything')
          .replace(queryParameters: params)
          .toString();
    }

    // /top-headlines: language param is NOT supported — never include it
    final params = <String, String>{
      'apiKey': _apiKey,
      'page': _page.toString(),
      'pageSize': '20',
    };

    if (_source.isNotEmpty) {
      // sources cannot be mixed with country or category
      params['sources'] = _source;
    } else {
      params['category'] = _category;
      params['country'] = _country;
    }

    return Uri.parse('$_baseUrl/top-headlines')
        .replace(queryParameters: params)
        .toString();
  }

  String get _sortByString {
    switch (_sortBy) {
      case SortBy.relevancy:
        return 'relevancy';
      case SortBy.popularity:
        return 'popularity';
      case SortBy.publishedAt:
        return 'publishedAt';
    }
  }

  // ─── Response Handling ─────────────────────────────────────────

  Map<String, dynamic>? _parseResponse(http.Response response) {
    if (response.statusCode == 200) return json.decode(response.body);
    _handleErrorResponse(response);
    return null;
  }

  void _handleSuccessfulResponse(Map<String, dynamic> data) {
    _totalResults = data['totalResults'] ?? 0;
    final newArticles = (data['articles'] as List? ?? [])
        .map((a) => Map<String, dynamic>.from(a)
          ..['sourceName'] = a['source']?['name'] ?? 'Unknown'
          ..['sourceId'] = a['source']?['id'] ?? '')
        .where((a) => a['title'] != null && a['title'] != '[Removed]')
        .toList();

    _articles.addAll(newArticles);
    _page++;

    if (_articles.isEmpty) {
      _errorMessage = 'No articles found. Try a different search or category.';
    }
  }

  void _handleErrorResponse(http.Response response) {
    try {
      final body = json.decode(response.body);
      _errorMessage = switch (response.statusCode) {
        400 => 'Bad request: ${body['message'] ?? 'Check your parameters'}',
        401 => 'Invalid API Key. Please update your credentials.',
        429 => 'Rate limit exceeded. Please wait before trying again.',
        500 => 'Server error. Please try again later.',
        _ => body['message'] ?? 'Unexpected error (${response.statusCode}).',
      };
    } catch (_) {
      _errorMessage = 'Error ${response.statusCode}. Please try again.';
    }
  }

  void _handleError(dynamic e) {
    debugPrint('NewsProviderApi Error: $e');
    _errorMessage = 'Failed to connect. Please check your internet connection.';
  }

  void _resetState() {
    _page = 1;
    _articles = [];
    _errorMessage = '';
    _totalResults = 0;
  }

  // ─── Trending (/top-headlines, no language param) ──────────────

  Future<void> _fetchTrending() async {
    try {
      final params = <String, String>{
        'category': 'technology',
        'country': 'us',
        'apiKey': _apiKey,
        'pageSize': '10',
      };
      final url = Uri.parse('$_baseUrl/top-headlines')
          .replace(queryParameters: params)
          .toString();
      final response = await _httpClient!.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _trendingArticles = (data['articles'] as List? ?? [])
            .map((a) => Map<String, dynamic>.from(a)
              ..['sourceName'] = a['source']?['name'] ?? 'Unknown')
            .where((a) => a['title'] != null && a['title'] != '[Removed]')
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Trending fetch error: $e');
    }
  }
}