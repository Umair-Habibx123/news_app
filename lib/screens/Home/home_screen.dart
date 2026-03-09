// lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:news_app/screens/home/widgets/vertical_news_list.dart';
import 'package:news_app/services/news_provider_api.dart';
import 'package:provider/provider.dart';
import 'package:news_app/services/theme_provider.dart';
import 'package:news_app/screens/home/widgets/category_chip_bar.dart';
import 'package:news_app/screens/home/widgets/horizontal_news_cards.dart';
import 'package:news_app/screens/bookmarks/bookmarks_screen.dart';
import 'package:news_app/screens/search/search_screen.dart';
import 'package:news_app/screens/settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    _NewsTab(),
    SearchScreen(),
    BookmarksScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  index: 0,
                  selectedIndex: _selectedIndex,
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                _NavItem(
                  icon: Icons.search_rounded,
                  label: 'Search',
                  index: 1,
                  selectedIndex: _selectedIndex,
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
                _NavItem(
                  icon: Icons.bookmark_rounded,
                  label: 'Saved',
                  index: 2,
                  selectedIndex: _selectedIndex,
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
                _NavItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  index: 3,
                  selectedIndex: _selectedIndex,
                  onTap: () => setState(() => _selectedIndex = 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;
    const purple = Color(0xFF6C63FF);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? purple.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? purple : Colors.grey, size: 24),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? purple : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── News Tab ───────────────────────────────────────────────────

class _NewsTab extends StatelessWidget {
  const _NewsTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: theme.appBarTheme.backgroundColor,
            expandedHeight: 58,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'News App',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
            ),
            actions: [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) => IconButton(
                  icon: Icon(
                    themeProvider.isDark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    color: Colors.white,
                  ),
                  onPressed: themeProvider.toggleTheme,
                  tooltip: 'Toggle theme',
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ],
        body: Column(
          children: [
            const CategoryChipBar(),
            Expanded(
              child: Consumer<NewsProviderApi>(
                builder: (context, provider, _) {
                  if (provider.isFetching && provider.articles.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFF6C63FF)),
                    );
                  }

                  if (provider.errorMessage.isNotEmpty &&
                      provider.articles.isEmpty) {
                    return _ErrorView(
                      message: provider.errorMessage,
                      onRetry: provider.refreshNews,
                    );
                  }

                  return RefreshIndicator(
                    color: const Color(0xFF6C63FF),
                    onRefresh: provider.refreshNews,
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      slivers: [
                        if (provider.trendingArticles.isNotEmpty) ...[
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Row(
                                children: [
                                  Icon(Icons.local_fire_department_rounded,
                                      color: Color(0xFFFF6B35), size: 20),
                                  SizedBox(width: 6),
                                  Text(
                                    'Trending',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(
                              child: HorizontalNewsCards()),
                        ],
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Row(
                              children: [
                                Icon(Icons.article_rounded,
                                    color: Color(0xFF6C63FF), size: 20),
                                SizedBox(width: 6),
                                Text(
                                  'Latest News',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index == provider.articles.length) {
                                  return _LoadMoreWidget(
                                      provider: provider);
                                }
                                return VerticalNewsListItem(
                                    article: provider.articles[index]);
                              },
                              childCount: provider.articles.length + 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadMoreWidget extends StatelessWidget {
  final NewsProviderApi provider;
  const _LoadMoreWidget({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: provider.isFetching
            ? const CircularProgressIndicator(color: Color(0xFF6C63FF))
            : provider.hasMore
                ? FilledButton.icon(
                    onPressed: provider.loadMore,
                    icon: const Icon(Icons.expand_more_rounded),
                    label: const Text('Load More'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                  )
                : const Text("You're all caught up! ✓",
                    style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}