// lib/screens/search/search_screen.dart

import 'package:flutter/material.dart';
import 'package:news_app/screens/home/widgets/vertical_news_list.dart';
import 'package:provider/provider.dart';
import 'package:news_app/services/news_provider_api.dart';
import 'package:news_app/services/search_provider.dart';
import 'package:news_app/l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isSearching = false;

  static const _sortOptions = [
    ('publishedAt', 'latestFirst'),
    ('popularity', 'mostPopular'),
    ('relevancy', 'mostRelevant'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _doSearch(String query) {
    if (query.trim().isEmpty) return;
    context.read<SearchProvider>().addToHistory(query);
    context.read<NewsProviderApi>().search(query);
    setState(() => _isSearching = true);
    _focusNode.unfocus();
  }

  void _clearSearch() {
    _controller.clear();
    context.read<NewsProviderApi>().clearSearch();
    setState(() => _isSearching = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);

    return SafeArea(
      child: Column(
        children: [
          // Search bar
          Container(
            color: isDark
                ? const Color(0xFF1A1A2E)
                : const Color(0xFF6C63FF),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2A2A3E)
                          : Colors.white.withOpacity(0.96),
                      borderRadius: BorderRadius.circular(23),
                    ),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      onSubmitted: _doSearch,
                      textInputAction: TextInputAction.search,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: l.t('searchHint'),
                        hintStyle: TextStyle(
                            color: Colors.grey[400], fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: Color(0xFF6C63FF), size: 20),
                        suffixIcon: _controller.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded,
                                    size: 18, color: Colors.grey),
                                onPressed: _clearSearch,
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 13),
                      ),
                      onChanged: (v) => setState(() {}),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _doSearch(_controller.text),
                  child: Container(
                    height: 46,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(23),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      l.t('search'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sort chips
          if (_isSearching)
            Consumer<NewsProviderApi>(
              builder: (context, provider, _) => Container(
                height: 42,
                color: isDark
                    ? const Color(0xFF16162A)
                    : const Color(0xFFF0F2FF),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Text(
                      '${l.t('sortBy')}: ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.grey[400]
                            : Colors.grey[600],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: _sortOptions.map((opt) {
                      final isActive =
                          provider.currentSortBy.name == opt.$1;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Center(
                        child: GestureDetector(
                          onTap: () {
                            final sort = SortBy.values.firstWhere(
                              (s) => s.name == opt.$1,
                              orElse: () => SortBy.publishedAt,
                            );
                            provider.setSortBy(sort);
                            if (_controller.text.isNotEmpty) {
                              provider.search(_controller.text);
                            }
                          },
                          child: AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFF6C63FF)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isActive
                                    ? const Color(0xFF6C63FF)
                                    : Colors.grey.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              l.t(opt.$2),
                              style: TextStyle(
                                fontSize: 11,
                                color: isActive
                                    ? Colors.white
                                    : Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        ),
                      );
                    }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          Expanded(
            child: _isSearching
                ? _SearchResults(query: _controller.text)
                : _SearchHistory(
                    onTap: (q) {
                      _controller.text = q;
                      _doSearch(q);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final String query;
  const _SearchResults({required this.query});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Consumer<NewsProviderApi>(
      builder: (context, provider, _) {
        if (provider.isFetching && provider.articles.isEmpty) {
          return const Center(
            child:
                CircularProgressIndicator(color: Color(0xFF6C63FF)),
          );
        }
        if (provider.articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off_rounded,
                    size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text('${l.t('noArticles')}\n"$query"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          physics: const BouncingScrollPhysics(),
          itemCount: provider.articles.length + 1,
          itemBuilder: (context, index) {
            if (index == provider.articles.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: provider.isFetching
                      ? const CircularProgressIndicator(
                          color: Color(0xFF6C63FF))
                      : provider.hasMore
                          ? FilledButton(
                              onPressed: provider.loadMore,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF6C63FF),
                              ),
                              child: Text(l.t('loadMore')),
                            )
                          : Text(l.t('allCaughtUp'),
                              style: const TextStyle(color: Colors.grey)),
                ),
              );
            }
            return VerticalNewsListItem(
                article: provider.articles[index]);
          },
        );
      },
    );
  }
}

class _SearchHistory extends StatelessWidget {
  final ValueChanged<String> onTap;
  const _SearchHistory({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Consumer<SearchProvider>(
      builder: (context, search, _) {
        if (search.history.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.manage_search_rounded,
                    size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  l.t('searchPrompt'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(l.t('recentSearches'),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                  const Spacer(),
                  TextButton(
                    onPressed: search.clearHistory,
                    child: Text(l.t('clear'),
                        style: const TextStyle(
                            color: Color(0xFF6C63FF), fontSize: 12)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: search.history.length,
                itemBuilder: (context, i) {
                  final q = search.history[i];
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.history_rounded,
                        color: Colors.grey, size: 18),
                    title:
                        Text(q, style: const TextStyle(fontSize: 14)),
                    trailing: IconButton(
                      icon: const Icon(Icons.close,
                          size: 16, color: Colors.grey),
                      onPressed: () => search.removeFromHistory(q),
                    ),
                    onTap: () => onTap(q),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}