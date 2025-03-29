import 'package:flutter/material.dart';

class CategoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CategoryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AppBar(
      backgroundColor: isDarkMode 
          ? const Color(0xFF4A1CAE)  // Darker purple for dark mode
          : const Color(0xFF673AB7), // Material Design deep purple
      elevation: 0,
      scrolledUnderElevation: 4, // Elevation when content scrolls behind
      surfaceTintColor: Colors.transparent,
      title: Text(
        'Categories',
        style: theme.textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 28, // Slightly larger icons
      ),
      actionsIconTheme: const IconThemeData(
        color: Colors.white,
        size: 28,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16), // Soft rounded bottom corners
        ),
      ),
      toolbarHeight: kToolbarHeight + 8, // Slightly taller app bar
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);
}