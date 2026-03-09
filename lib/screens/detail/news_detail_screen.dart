// lib/screens/detail/news_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:news_app/services/bookmarks_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatelessWidget {
  final Map<String, dynamic> article;
  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: size.height * 0.32,
            pinned: true,
            backgroundColor: const Color(0xFF6C63FF),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
            actions: [
              Consumer<BookmarksProvider>(
                builder: (context, bookmarks, _) {
                  final saved = bookmarks.isBookmarked(article);
                  return GestureDetector(
                    onTap: () {
                      bookmarks.toggleBookmark(article);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            saved
                                ? 'Removed from bookmarks'
                                : 'Article bookmarked!',
                          ),
                          backgroundColor: const Color(0xFF6C63FF),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                          margin: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        saved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: saved
                            ? const Color(0xFFFFD700)
                            : Colors.white,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
              GestureDetector(
                onTap: () {
                  final url = article['url'] ?? '';
                  final title = article['title'] ?? '';
                  if (url.isNotEmpty) Share.share('$title\n\n$url');
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.share_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _buildHeroImage(article['urlToImage']),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.25),
                          Colors.black.withOpacity(0.75),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              color: theme.scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Source + date
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF6C63FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: const Color(0xFF6C63FF)
                                    .withOpacity(0.2)),
                          ),
                          child: Text(
                            article['sourceName'] ??
                                article['source']?['name'] ??
                                'Unknown',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6C63FF),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.access_time_rounded,
                            size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(article['publishedAt']),
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Title
                    Text(
                      article['title'] ?? 'No Title',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.35,
                        fontSize: size.width * 0.055,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Author
                    if (article['author'] != null &&
                        article['author'].toString().isNotEmpty) ...[
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: const Color(0xFF6C63FF)
                                .withOpacity(0.12),
                            child: const Icon(Icons.person_rounded,
                                size: 16, color: Color(0xFF6C63FF)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              article['author'] ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? Colors.grey[300]
                                    : Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],

                    Divider(
                        color:
                            isDark ? Colors.white12 : Colors.grey[200]),
                    const SizedBox(height: 16),

                    if (article['description'] != null) ...[
                      Text(
                        article['description'],
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.7,
                          fontSize: 15,
                          color: isDark
                              ? Colors.grey[200]
                              : Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (article['content'] != null &&
                        article['content'].toString().isNotEmpty) ...[
                      Text(
                        _cleanContent(article['content']),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.75,
                          color: isDark
                              ? Colors.grey[300]
                              : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    if (article['url'] != null) ...[
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => _openArticle(article['url']),
                          icon: const Icon(Icons.open_in_browser_rounded),
                          label: const Text('Read Full Article'),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final url = article['url'] ?? '';
                            final title = article['title'] ?? '';
                            if (url.isNotEmpty)
                              Share.share('$title\n\n$url');
                          },
                          icon: const Icon(Icons.share_rounded,
                              color: Color(0xFF6C63FF)),
                          label: const Text('Share Article',
                              style: TextStyle(color: Color(0xFF6C63FF))),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Color(0xFF6C63FF)),
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(String? url) {
    if (url == null || url.isEmpty) {
      return Container(
        color: const Color(0xFF2A2A3E),
        child: const Center(
          child: Icon(Icons.article_rounded,
              color: Colors.white24, size: 80),
        ),
      );
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFF2A2A3E),
        child: const Center(
          child: Icon(Icons.broken_image_rounded,
              color: Colors.white24, size: 80),
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return '';
    }
  }

  String _cleanContent(String content) =>
      content.replaceAll(RegExp(r'\[\+\d+ chars\]'), '').trim();

  Future<void> _openArticle(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}