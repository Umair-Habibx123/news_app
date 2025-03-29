import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class NewsProviderApi with ChangeNotifier {
  static const String _baseUrl = 'https://newsapi.org/v2/top-headlines';
  final String apiKey = dotenv.env['API_KEY_UMAIR_1'] ?? 'No API key found';

  String _category = 'general';
  String _source = '';
  int _page = 1;
  bool _isFetching = false;
  String _errorMessage = '';
  List<dynamic> _articles = [];
  Timer? _debounceTimer;
  http.Client? _httpClient;

  List<dynamic> get articles => _articles;
  bool get isFetching => _isFetching;
  String get errorMessage => _errorMessage;

  NewsProviderApi({String? category, String? source}) {
    _httpClient = http.Client();
    if (category != null) _category = category;
    if (source != null) _source = source;
    _fetchNewsDebounced();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _httpClient?.close();
    super.dispose();
  }

  Future<void> fetchNews() async {
    if (_isFetching) return;
    _isFetching = true;
    notifyListeners();

    try {
      final response = await _httpClient!.get(Uri.parse(_buildApiUrl()));
      final data = _parseResponse(response);

      if (data != null) {
        _handleSuccessfulResponse(data);
      }
    } catch (e) {
      _handleError(e);
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  void _fetchNewsDebounced() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), fetchNews);
  }

  String _buildApiUrl() {
    final params = {
      if (_source.isNotEmpty) 'sources': _source,
      if (_source.isEmpty) 'category': _category,
      if (_source.isEmpty) 'language': 'en',
      'apiKey': apiKey,
      'page': _page.toString(),
    };

    return Uri.parse(_baseUrl).replace(queryParameters: params).toString();
  }

  Map<String, dynamic>? _parseResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      _handleErrorResponse(response);
      return null;
    }
  }

  void _handleSuccessfulResponse(Map<String, dynamic> data) {
    if (data['articles'] == null || data['articles'].isEmpty) {
      _errorMessage = 'No news articles found.';
      return;
    }

    _errorMessage = '';
    _articles.addAll(data['articles'].map((article) {
      article['sourceName'] = article['source']['name'];
      return article;
    }).toList());
    _page++;
  }

  void _handleErrorResponse(http.Response response) {
    final errorData = json.decode(response.body);
    _errorMessage = switch (response.statusCode) {
      401 => 'Invalid API Key. Please update your credentials.',
      429 => 'API Rate limit exceeded. Try again later.',
      _ => errorData['message'] ?? 'Error fetching news.',
    };
  }

  void _handleError(dynamic e) {
    debugPrint('Error: $e');
    _errorMessage = 'Error connecting to server.';
  }

  void setCategory(String category) {
    if (_category == category) return;
    _resetState();
    _category = category;
    _fetchNewsDebounced();
  }

  void setSource(String source) {
    if (_source == source) return;
    _resetState();
    _source = source;
    _fetchNewsDebounced();
  }

  void _resetState() {
    _page = 1;
    _articles = [];
    _errorMessage = '';
  }
}