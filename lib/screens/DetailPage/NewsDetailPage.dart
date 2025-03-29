import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:news_app/screens/DetailPage/widgets/news_detail_button.dart';
import 'package:news_app/screens/DetailPage/widgets/news_detail_content.dart';
import 'package:news_app/screens/DetailPage/widgets/news_detail_image.dart';
import 'package:news_app/screens/DetailPage/widgets/news_detail_header.dart';

class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> article;

  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30), 
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 10,
                    sigmaY: 10,
                  ), 
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(
                        0.2,
                      ), 
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  NewsDetailImage(imageUrl: article['urlToImage']),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.5), 
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NewsDetailHeader(
                    title: article['title'],
                    sourceName: article['sourceName'],
                    publishedAt: article['publishedAt'],
                  ),
                  NewsDetailContent(content: article['content']),
                  NewsDetailButton(url: article['url']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
