import 'package:flutter/material.dart';

class NewsDetailContent extends StatelessWidget {
  final String? content;

  const NewsDetailContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        content ?? 'No content available for this news article.',
        style: const TextStyle(
          fontSize: 16,
          height: 1.6,
          color: Colors.black87,
        ),
      ),
    );
  }
}