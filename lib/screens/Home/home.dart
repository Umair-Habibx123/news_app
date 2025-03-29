import 'package:flutter/material.dart';
import 'package:news_app/screens/Home/widgets/custom_app_bar.dart';
import 'package:news_app/screens/Home/widgets/horizontal_news_cards.dart';
import 'package:news_app/screens/Home/widgets/vertical_news_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NewsAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const HorizontalNewsCards(),
          Expanded(child: VerticalNewsList()),
        ],
      ),
    );
  }
}