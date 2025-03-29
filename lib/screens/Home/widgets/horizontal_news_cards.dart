import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/services/NewsProviderApi.dart';
import 'package:news_app/screens/DetailPage/NewsDetailPage.dart';

class HorizontalNewsCards extends StatelessWidget {
  const HorizontalNewsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380.0,
      child: Consumer<NewsProviderApi>(
        builder: (context, newsProvider, _) => ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          itemCount: newsProvider.articles.length,
          itemBuilder: (BuildContext context, int index) {
            var article = newsProvider.articles[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NewsDetailPage(article: article),
                  ),
                );
              },
              child: Container(
                width: 280.0,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12.0,
                      spreadRadius: 1.0,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // News Image
                      article['urlToImage'] != null
                          ? Image.network(
                              article['urlToImage'],
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                    'assets/image_not_found.png',
                                    fit: BoxFit.cover,
                                  ),
                            )
                          : Image.asset(
                              'assets/image_not_found.png',
                              fit: BoxFit.cover,
                            ),

                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category Chip
                            if (article['category'] != null)
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 6.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF561EBE),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Text(
                                    article['category'].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),

                            const Spacer(),

                            // Title
                            Text(
                              article['title'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 6.0),
                            
                            // Source and Date Row - FIXED OVERFLOW
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.newspaper,
                                          color: Colors.white70,
                                          size: 16.0,
                                        ),
                                        const SizedBox(width: 6.0),
                                        Flexible(
                                          child: Text(
                                            article['sourceName'] ?? 'Unknown Source',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14.0,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          color: Colors.white70,
                                          size: 16.0,
                                        ),
                                        const SizedBox(width: 6.0),
                                        Flexible(
                                          child: Text(
                                            article['publishedAt'] != null
                                                ? _formatDate(article['publishedAt'])
                                                : 'Unknown Date',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14.0,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
          },
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString).toLocal();
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown Date';
    }
  }
}