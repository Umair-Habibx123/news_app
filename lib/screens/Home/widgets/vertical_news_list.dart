// lib/screens/home/widgets/vertical_news_list.dart

import 'package:flutter/material.dart';
import 'package:news_app/screens/detail/news_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:news_app/services/bookmarks_provider.dart';

class VerticalNewsListItem extends StatelessWidget {
  final Map<String, dynamic> article;
  const VerticalNewsListItem({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewsDetailScreen(article: article),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: size.width * 0.24,
                  height: size.width * 0.22,
                  child: _buildImage(),
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Source + time
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFF6C63FF).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              article['sourceName'] ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF6C63FF),
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _timeAgo(article['publishedAt']),
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark
                                ? Colors.grey[500]
                                : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),

                    // Title
                    Text(
                      article['title'] ?? 'No Title',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                        fontSize: 13,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Bookmark
                    Align(
                      alignment: Alignment.centerRight,
                      child: Consumer<BookmarksProvider>(
                        builder: (context, bookmarks, _) {
                          final saved = bookmarks.isBookmarked(article);
                          return GestureDetector(
                            onTap: () {
                              bookmarks.toggleBookmark(article);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    saved
                                        ? 'Removed from bookmarks'
                                        : 'Article bookmarked!',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: const Color(0xFF6C63FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: const EdgeInsets.all(12),
                                ),
                              );
                            },
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                saved
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_border_rounded,
                                key: ValueKey(saved),
                                size: 20,
                                color: saved
                                    ? const Color(0xFF6C63FF)
                                    : Colors.grey[400],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    final url = article['urlToImage'];
    if (url == null || url.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF6C63FF).withOpacity(0.08),
        ),
        child: const Center(
          child: Icon(Icons.article_rounded,
              color: Color(0xFF6C63FF), size: 28),
        ),
      );
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image_rounded, color: Colors.grey),
      ),
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          color: Colors.grey[100],
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF6C63FF),
            ),
          ),
        );
      },
    );
  }

  String _timeAgo(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }
}