// lib/screens/settings/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:news_app/services/news_provider_api.dart';
import 'package:provider/provider.dart';
import 'package:news_app/services/theme_provider.dart';
import 'package:news_app/services/locale_provider.dart';
import 'package:news_app/services/bookmarks_provider.dart';
import 'package:news_app/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);

    return SafeArea(
      child: Column(
        children: [
          Container(
            color:
                isDark ? const Color(0xFF1A1A2E) : const Color(0xFF6C63FF),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Text(
                  l.t('settings'),
                  style: const TextStyle(
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
                // ─── Appearance ───────────────────────────────────
                _SectionHeader(title: l.t('appearance')),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) => _SettingCard(
                    children: [
                      _SettingRow(
                        icon: Icons.brightness_6_rounded,
                        iconColor: const Color(0xFF6C63FF),
                        title: l.t('theme'),
                        subtitle: l.t('themeSubtitle'),
                        trailing: const Icon(Icons.chevron_right_rounded,
                            color: Colors.grey),
                        onTap: () =>
                            _showThemePicker(context, themeProvider, l),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ─── Language ─────────────────────────────────────
                _SectionHeader(title: l.t('language')),
                Consumer<LocaleProvider>(
                  builder: (context, localeProvider, _) => _SettingCard(
                    children: [
                      _SettingRow(
                        icon: Icons.translate_rounded,
                        iconColor: const Color(0xFF00B4D8),
                        title: l.t('appLanguage'),
                        subtitle: AppLocalizations.languageNames[
                                localeProvider.locale.languageCode] ??
                            'English',
                        trailing: const Icon(Icons.chevron_right_rounded,
                            color: Colors.grey),
                        onTap: () =>
                            _showAppLanguagePicker(context, localeProvider, l),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ─── News Preferences ─────────────────────────────
                _SectionHeader(title: l.t('newsPreferences')),
                Consumer<NewsProviderApi>(
                  builder: (context, provider, _) => _SettingCard(
                    children: [
                      _SettingRow(
                        icon: Icons.newspaper_rounded,
                        iconColor: const Color(0xFFFF6B35),
                        title: l.t('preferredSource'),
                        subtitle: provider.currentSource.isEmpty
                            ? l.t('allSources')
                            : NewsProviderApi.popularSources.firstWhere(
                                (s) => s['id'] == provider.currentSource,
                                orElse: () =>
                                    {'name': provider.currentSource},
                              )['name']!,
                        trailing: const Icon(Icons.chevron_right_rounded,
                            color: Colors.grey),
                        onTap: () => _showSourcePicker(context, provider, l),
                      ),
                      const Divider(height: 1, indent: 52),
                      _SettingRow(
                        icon: Icons.language_rounded,
                        iconColor: const Color(0xFF06D6A0),
                        title: l.t('contentLanguage'),
                        subtitle: NewsProviderApi
                                .supportedLanguages[provider.currentLanguage] ??
                            'English',
                        trailing: const Icon(Icons.chevron_right_rounded,
                            color: Colors.grey),
                        onTap: () =>
                            _showContentLanguagePicker(context, provider, l),
                      ),
                      const Divider(height: 1, indent: 52),
                      _SettingRow(
                        icon: Icons.sort_rounded,
                        iconColor: const Color(0xFF6C63FF),
                        title: l.t('sortArticlesBy'),
                        subtitle: _sortName(provider.currentSortBy, l),
                        trailing: const Icon(Icons.chevron_right_rounded,
                            color: Colors.grey),
                        onTap: () => _showSortPicker(context, provider, l),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ─── Data & Storage ───────────────────────────────
                _SectionHeader(title: l.t('dataStorage')),
                Consumer<BookmarksProvider>(
                  builder: (context, bookmarks, _) => _SettingCard(
                    children: [
                      _SettingRow(
                        icon: Icons.bookmark_rounded,
                        iconColor: const Color(0xFF6C63FF),
                        title: l.t('bookmarks'),
                        subtitle:
                            '${bookmarks.count} ${l.t('saved').toLowerCase()}',
                      ),
                      const Divider(height: 1, indent: 52),
                      _SettingRow(
                        icon: Icons.delete_outline_rounded,
                        iconColor: Colors.red,
                        title: l.t('clearBookmarks'),
                        subtitle: l.t('removeAllSaved'),
                        onTap: bookmarks.count > 0
                            ? () async {
                                final ok = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text(l.t('clearAllBookmarks')),
                                    content:
                                        Text(l.t('clearBookmarksConfirm')),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text(l.t('cancel')),
                                      ),
                                      FilledButton(
                                        style: FilledButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text(l.t('clear')),
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

                // ─── About ────────────────────────────────────────
                _SectionHeader(title: l.t('about')),
                _SettingCard(
                  children: [
                    _SettingRow(
                      icon: Icons.info_outline_rounded,
                      iconColor: Colors.blueGrey,
                      title: l.t('appName'),
                      subtitle: 'Version 2.0.0 • Powered by NewsAPI',
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

  String _sortName(SortBy sort, AppLocalizations l) {
    switch (sort) {
      case SortBy.publishedAt:
        return l.t('latestFirst');
      case SortBy.popularity:
        return l.t('mostPopular');
      case SortBy.relevancy:
        return l.t('mostRelevant');
    }
  }

  // ─── Pickers ──────────────────────────────────────────────────

  void _showThemePicker(
      BuildContext context, ThemeProvider provider, AppLocalizations l) {
    final options = <ThemeMode, ({String label, IconData icon})>{
      ThemeMode.light: (label: l.t('light'), icon: Icons.light_mode_rounded),
      ThemeMode.dark: (label: l.t('dark'), icon: Icons.dark_mode_rounded),
      ThemeMode.system:
          (label: l.t('system'), icon: Icons.brightness_auto_rounded),
    };
    _bottomSheet(
      context,
      title: l.t('theme'),
      children: options.entries.map((e) {
        final selected = provider.themeMode == e.key;
        return ListTile(
          leading: Icon(e.value.icon,
              color: selected ? const Color(0xFF6C63FF) : Colors.grey),
          title: Text(e.value.label),
          trailing: selected
              ? const Icon(Icons.check_rounded, color: Color(0xFF6C63FF))
              : null,
          onTap: () {
            provider.setTheme(e.key);
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }

  void _showAppLanguagePicker(
      BuildContext context, LocaleProvider provider, AppLocalizations l) {
    _bottomSheet(
      context,
      title: l.t('appLanguage'),
      children: AppLocalizations.languageNames.entries.map((e) {
        final selected = provider.locale.languageCode == e.key;
        return ListTile(
          title: Text(e.value),
          trailing: selected
              ? const Icon(Icons.check_rounded, color: Color(0xFF6C63FF))
              : null,
          onTap: () {
            provider.setLocale(Locale(e.key));
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }

  void _showSourcePicker(
      BuildContext context, NewsProviderApi provider, AppLocalizations l) {
    _bottomSheet(
      context,
      title: l.t('selectSource'),
      children: NewsProviderApi.popularSources.map((s) {
        final selected = provider.currentSource == s['id'];
        return ListTile(
          title: Text(s['id']!.isEmpty ? l.t('allSources') : s['name']!),
          trailing: selected
              ? const Icon(Icons.check_rounded, color: Color(0xFF6C63FF))
              : null,
          onTap: () {
            provider.setSource(s['id']!);
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }

  void _showContentLanguagePicker(
      BuildContext context, NewsProviderApi provider, AppLocalizations l) {
    _bottomSheet(
      context,
      title: l.t('selectLanguage'),
      children: NewsProviderApi.supportedLanguages.entries.map((e) {
        final selected = provider.currentLanguage == e.key;
        return ListTile(
          title: Text(e.value),
          trailing: selected
              ? const Icon(Icons.check_rounded, color: Color(0xFF6C63FF))
              : null,
          onTap: () {
            provider.setLanguage(e.key);
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }

  void _showSortPicker(
      BuildContext context, NewsProviderApi provider, AppLocalizations l) {
    _bottomSheet(
      context,
      title: l.t('sortBy'),
      children: SortBy.values.map((s) {
        final selected = provider.currentSortBy == s;
        return ListTile(
          title: Text(_sortName(s, l)),
          trailing: selected
              ? const Icon(Icons.check_rounded, color: Color(0xFF6C63FF))
              : null,
          onTap: () {
            provider.setSortBy(s);
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }

  void _bottomSheet(BuildContext context,
      {required String title, required List<Widget> children}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            Flexible(child: ListView(shrinkWrap: true, children: children)),
            const SizedBox(height: 8),
          ],
        ),
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
          style:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: subtitle.isEmpty
          ? null
          : Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
