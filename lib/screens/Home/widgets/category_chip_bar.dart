// lib/screens/home/widgets/category_chip_bar.dart

import 'package:flutter/material.dart';
import 'package:news_app/services/news_provider_api.dart';
import 'package:provider/provider.dart';

const _categoryIcons = {
  'general': Icons.public_rounded,
  'business': Icons.trending_up_rounded,
  'entertainment': Icons.movie_filter_rounded,
  'health': Icons.favorite_rounded,
  'science': Icons.science_rounded,
  'sports': Icons.sports_soccer_rounded,
  'technology': Icons.memory_rounded,
};

class CategoryChipBar extends StatelessWidget {
  const CategoryChipBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFF6C63FF),
      child: Consumer<NewsProviderApi>(
        builder: (context, provider, _) {
          return SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              physics: const BouncingScrollPhysics(),
              itemCount: NewsProviderApi.categories.length,
              itemBuilder: (context, index) {
                final cat = NewsProviderApi.categories[index];
                final isSelected = provider.currentCategory == cat &&
                    provider.currentSource.isEmpty;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => provider.setCategory(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _categoryIcons[cat] ?? Icons.article_rounded,
                            size: 14,
                            color: isSelected
                                ? const Color(0xFF6C63FF)
                                : Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _capitalize(cat),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFF6C63FF)
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}