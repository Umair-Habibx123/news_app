import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/services/NewsProviderApi.dart';
import 'package:news_app/screens/DetailPage/NewsDetailPage.dart';

class VerticalNewsList extends StatelessWidget {
  const VerticalNewsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProviderApi>(
      builder: (context, newsProvider, child) {
        if (newsProvider.isFetching && newsProvider.articles.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey)),
          );
        }

        if (newsProvider.errorMessage.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(newsProvider.errorMessage),
                backgroundColor: Colors.red[800],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    Provider.of<NewsProviderApi>(
                      context,
                      listen: false,
                    ).fetchNews();
                  },
                ),
              ),
            );
          });
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: newsProvider.articles.length + 1,
          itemBuilder: (context, index) {
            if (index == newsProvider.articles.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: newsProvider.isFetching
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                        )
                      : ElevatedButton(
                          onPressed: newsProvider.fetchNews,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueGrey[800],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Load More Articles',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                ),
              );
            }
            final article = newsProvider.articles[index];
            return _NewsListItem(article: article);
          },
        );
      },
    );
  }
}

class _NewsListItem extends StatelessWidget {
  final Map<String, dynamic> article;

  const _NewsListItem({required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewsDetailPage(article: article),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isDarkMode
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey[850]!,
                      Colors.grey[900]!,
                    ],
                  )
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Container(
                  height: 120,
                  width: 120,
                  color: Colors.grey[200],
                  child: article['urlToImage'] != null
                      ? Image.network(
                          article['urlToImage'],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.article,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                        ),
                ),
              ),
              // Text Content Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        article['title'] ?? 'No Title',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              article['source']['name'] ?? 'Unknown Source',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.blueGrey[700],
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            article['publishedAt'] != null
                                ? DateTime.parse(article['publishedAt'])
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0]
                                : 'Unknown Date',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  isDarkMode ? Colors.grey[400] : Colors.grey[600],
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
}