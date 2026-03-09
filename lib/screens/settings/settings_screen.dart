// lib/screens/settings/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:news_app/services/news_provider_api.dart';
import 'package:provider/provider.dart';
import 'package:news_app/services/theme_provider.dart';
import 'package:news_app/services/bookmarks_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Column(
        children: [
          Container(
            color: isDark
                ? const Color(0xFF1A1A2E)
                : const Color(0xFF6C63FF),
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            child: const Row(
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _SectionHeader(title: 'Appearance'),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) => _SettingCard(
                    children: [
                      _SettingRow(
                        icon: Icons.dark_mode_rounded,
                        iconColor: const Color(0xFF6C63FF),
                        title: 'Dark Mode',
                        subtitle: 'Toggle dark/light theme',
                        trailing: Switch(
                          value: themeProvider.isDark,
                          onChanged: (_) => themeProvider.toggleTheme(),
                          activeColor: const Color(0xFF6C63FF),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                _SectionHeader(title: 'News Preferences'),
                Consumer<NewsProviderApi>(
                  builder: (context, provider, _) => _SettingCard(
                    children: [
                      _SettingRow(
                        icon: Icons.newspaper_rounded,
                        iconColor: const Color(0xFFFF6B35),
                        title: 'Preferred Source',
                        subtitle: provider.currentSource.isEmpty
                            ? 'All Sources'
                            : NewsProviderApi.popularSources
                                .firstWhere(
                                  (s) => s['id'] == provider.currentSource,
                                  orElse: () =>
                                      {'name': provider.currentSource},
                                )['name']!,
                        trailing: const Icon(Icons.chevron_right_rounded,
                            color: Colors.grey),
                        onTap: () =>
                            _showSourcePicker(context, provider),
                      ),
                      const Divider(height: 1, indent: 52),
                      _SettingRow(
                        icon: Icons.language_rounded,
                        iconColor: const Color(0xFF00B4D8),
                        title: 'Language',
                        subtitle: NewsProviderApi
                                .supportedLanguages[provider.currentLanguage] ??
                            'English',
                        trailing: const Icon(Icons.chevron_right_rounded,
                            color: Colors.grey),
                        onTap: () =>
                            _showLanguagePicker(context, provider),
                      ),
                      const Divider(height: 1, indent: 52),
                      _SettingRow(
                        icon: Icons.sort_rounded,
                        iconColor: const Color(0xFF06D6A0),
                        title: 'Sort Articles By',
                        subtitle: _sortName(provider.currentSortBy),
                        trailing: const Icon(Icons.chevron_right_rounded,
                            color: Colors.grey),
                        onTap: () => _showSortPicker(context, provider),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                _SectionHeader(title: 'Data & Storage'),
                Consumer<BookmarksProvider>(
                  builder: (context, bookmarks, _) => _SettingCard(
                    children: [
                      _SettingRow(
                        icon: Icons.bookmark_rounded,
                        iconColor: const Color(0xFF6C63FF),
                        title: 'Bookmarks',
                        subtitle:
                            '${bookmarks.count} article${bookmarks.count == 1 ? '' : 's'} saved',
                      ),
                      const Divider(height: 1, indent: 52),
                      _SettingRow(
                        icon: Icons.delete_outline_rounded,
                        iconColor: Colors.red,
                        title: 'Clear Bookmarks',
                        subtitle: 'Remove all saved articles',
                        onTap: bookmarks.count > 0
                            ? () async {
                                final ok = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text(
                                        'Clear All Bookmarks'),
                                    content: const Text(
                                        'This will remove all saved articles permanently.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      FilledButton(
                                        style: FilledButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Clear'),
                                      ),
                                    ],
                                  ),
                                );
                                if (ok == true) bookmarks.clearAll();
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                _SectionHeader(title: 'About'),
                _SettingCard(
                  children: [
                    _SettingRow(
                      icon: Icons.info_outline_rounded,
                      iconColor: Colors.blueGrey,
                      title: 'News App',
                      subtitle: 'Version 2.0.0 • Powered by NewsAPI',
                    ),
                    const Divider(height: 1, indent: 52),
                    _SettingRow(
                      icon: Icons.storage_rounded,
                      iconColor: const Color(0xFF06D6A0),
                      title: 'Database', subtitle: '',
                      // subtitle: 'SQLite — local persistent storage',
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _sortName(SortBy sort) {
    switch (sort) {
      case SortBy.publishedAt:
        return 'Latest First';
      case SortBy.popularity:
        return 'Most Popular';
      case SortBy.relevancy:
        return 'Most Relevant';
    }
  }

  void _showSourcePicker(BuildContext context, NewsProviderApi provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Select Source',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
          ),
          Expanded(
            child: ListView(
              children: NewsProviderApi.popularSources.map((s) {
                final isSelected = provider.currentSource == s['id'];
                return ListTile(
                  title: Text(s['name']!),
                  trailing: isSelected
                      ? const Icon(Icons.check_rounded,
                          color: Color(0xFF6C63FF))
                      : null,
                  onTap: () {
                    provider.setSource(s['id']!);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(
      BuildContext context, NewsProviderApi provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Select Language',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
          ),
          Expanded(
            child: ListView(
              children: NewsProviderApi.supportedLanguages.entries.map((e) {
                final isSelected = provider.currentLanguage == e.key;
                return ListTile(
                  title: Text(e.value),
                  subtitle: Text(e.key),
                  trailing: isSelected
                      ? const Icon(Icons.check_rounded,
                          color: Color(0xFF6C63FF))
                      : null,
                  onTap: () {
                    provider.setLanguage(e.key);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortPicker(BuildContext context, NewsProviderApi provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Sort By',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
          ),
          ...SortBy.values.map((s) {
            final isSelected = provider.currentSortBy == s;
            return ListTile(
              title: Text(_sortName(s)),
              trailing: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: Color(0xFF6C63FF))
                  : null,
              onTap: () {
                provider.setSortBy(s);
                Navigator.pop(context);
              },
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF6C63FF),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 12)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}