import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/services/NewsProviderApi.dart';
import 'package:news_app/screens/Category/category.dart';

class NewsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NewsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF561EBE), // Purple primary color
      elevation: 4, // Subtle shadow
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16), // Rounded bottom corners
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Categories Button
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.widgets_rounded, // More modern icon
                color: Colors.white,
                size: 26,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CategoryScreen(),
                  ),
                );
              },
              splashRadius: 24, // Better touch feedback
              tooltip: 'Categories', // Accessibility
            ),
          ),
          
          // App Title
          const Text(
            'News',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          
          // News Source Dropdown
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: PopupMenuButton<String>(
              onSelected: (String result) {
                Provider.of<NewsProviderApi>(context, listen: false)
                    .setSource(result);
              },
              icon: const Icon(
                Icons.tune_rounded, // More appropriate icon
                color: Colors.white,
                size: 26,
              ),
              offset: const Offset(0, 50), // Better positioning
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                _buildPopupMenuItem('bbc-news', 'BBC News', Icons.public),
                _buildPopupMenuItem('ary-news', 'ARY News', Icons.language),
                _buildPopupMenuItem('al-jazeera-english', 'Al-Jazeera English', Icons.language),
              ],
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String value, String text, IconData icon) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF561EBE)),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8); // Slightly taller
}