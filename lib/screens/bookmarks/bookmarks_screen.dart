// lib/screens/bookmarks/bookmarks_screen.dart

import 'package:flutter/material.dart';
import 'package:news_app/screens/home/widgets/vertical_news_list.dart';
import 'package:provider/provider.dart';
import 'package:news_app/services/bookmarks_provider.dart';
import 'package:news_app/l10n/app_localizations.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final l = AppLocalizations.of(context);

    return SafeArea(
      child: Column(
        children: [
          Container(
            color: isDark
                ? const Color(0xFF1A1A2E)
                : const Color(0xFF6C63FF),
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Text(
                  l.t('saved'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Consumer<BookmarksProvider>(
                  builder: (context, bookmarks, _) {
                    if (bookmarks.count == 0) {
                      return const SizedBox.shrink();
                    }
                    return TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(l.t('clearAllBookmarks')),
                            content: Text(l.t('clearBookmarksConfirm')),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context),
                                child: Text(l.t('cancel')),
                              ),
                              FilledButton(
                                onPressed: () {
                                  bookmarks.clearAll();
                                  Navigator.pop(context);
                                },
                                style: FilledButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: Text(l.t('clear')),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: Colors.white70, size: 16),
                      label: Text(l.t('clearBookmarks'),
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12)),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<BookmarksProvider>(
              builder: (context, bookmarks, _) {
                if (bookmarks.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF6C63FF)),
                  );
                }

                if (bookmarks.bookmarks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width * 0.28,
                          height: size.width * 0.28,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C63FF)
                                .withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.bookmark_border_rounded,
                            size: 56,
                            color: Color(0xFF6C63FF),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          l.t('noBookmarks'),
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l.t('noBookmarksHint'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Text(
                        '${bookmarks.count} ${l.t('saved').toLowerCase()}',
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 12),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        physics: const BouncingScrollPhysics(),
                        itemCount: bookmarks.bookmarks.length,
                        itemBuilder: (context, index) =>
                            VerticalNewsListItem(
                          article: bookmarks.bookmarks[index],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}