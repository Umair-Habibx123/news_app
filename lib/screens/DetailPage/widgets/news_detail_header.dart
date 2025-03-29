import 'package:flutter/material.dart';

class NewsDetailHeader extends StatelessWidget {
  final String? title;
  final String? sourceName;
  final String? publishedAt;

  const NewsDetailHeader({
    super.key,
    required this.title,
    required this.sourceName,
    required this.publishedAt,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // News Title
          Text(
            title ?? 'No Title Available',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.3,
              color: isDarkMode ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 16),

          // News Source and Date
          Row(
            children: [
              // Source Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? colorScheme.primary.withOpacity(0.2)
                      : colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  sourceName ?? 'Unknown Source',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDarkMode 
                        ? colorScheme.primary 
                        : colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Date
              Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                _formatDate(publishedAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Divider
          Divider(
            height: 32,
            thickness: 1,
            color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown Date';
    try {
      final date = DateTime.parse(dateString).toLocal();
      return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';
    } catch (e) {
      return 'Unknown Date';
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}