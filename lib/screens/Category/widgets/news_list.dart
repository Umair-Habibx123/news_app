import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/services/NewsProviderApi.dart';
import 'package:news_app/screens/Category/widgets/news_list_item.dart';

class NewsList extends StatelessWidget {
  const NewsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProviderApi>(
      builder: (context, newsProvider, child) {
        if (newsProvider.isFetching && newsProvider.articles.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF6A5AE0)),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          itemCount: newsProvider.articles.length + 1,
          itemBuilder: (context, index) {
            if (index == newsProvider.articles.length) {
              return _buildLoadMoreButton(newsProvider);
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: NewsListItem(article: newsProvider.articles[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildLoadMoreButton(NewsProviderApi newsProvider) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child:
            newsProvider.isFetching
                ? const CircularProgressIndicator(color: Color(0xFF6A5AE0))
                : ElevatedButton(
                  onPressed: newsProvider.fetchNews,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A5AE0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Load More',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
      ),
    );
  }
}
