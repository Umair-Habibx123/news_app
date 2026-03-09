// lib/screens/home/widgets/horizontal_news_cards.dart

import 'package:flutter/material.dart';
import 'package:news_app/screens/detail/news_detail_screen.dart';
import 'package:news_app/services/news_provider_api.dart';
import 'package:provider/provider.dart';
import 'package:news_app/services/bookmarks_provider.dart';

class HorizontalNewsCards extends StatelessWidget {
  const HorizontalNewsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProviderApi>(
      builder: (context, provider, _) {
        final articles = provider.trendingArticles;
        if (articles.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: articles.length,
            itemBuilder: (context, index) =>
                _TrendingCard(article: articles[index]),
          ),
        );
      },
    );
  }
}

class _TrendingCard extends StatelessWidget {
  final Map<String, dynamic> article;
  const _TrendingCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => NewsDetailScreen(article: article)),
      ),
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 12, bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _ArticleImage(url: article['urlToImage']),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: const [0.35, 1.0],
                  ),
                ),
              ),
              // Bookmark
              Positioned(
                top: 10,
                right: 10,
                child: Consumer<BookmarksProvider>(
                  builder: (context, bookmarks, _) {
                    final saved = bookmarks.isBookmarked(article);
                    return GestureDetector(
                      onTap: () => bookmarks.toggleBookmark(article),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          saved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: saved
                              ? const Color(0xFFFFD700)
                              : Colors.white,
                          size: 18,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Text content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C63FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          article['sourceName'] ?? 'Unknown',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        article['title'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 10,
                            color: Colors.white.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _timeAgo(article['publishedAt']),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _timeAgo(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) {
      return '';
    }
  }
}

class _ArticleImage extends StatelessWidget {
  final String? url;
  const _ArticleImage({this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Container(
        color: const Color(0xFF2A2A3E),
        child: const Center(
          child: Icon(Icons.article_rounded, color: Colors.white24, size: 48),
        ),
      );
    }
    return Image.network(
      url!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFF2A2A3E),
        child: const Center(
          child: Icon(Icons.broken_image_rounded,
              color: Colors.white24, size: 48),
        ),
      ),
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          color: const Color(0xFF2A2A3E),
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
}