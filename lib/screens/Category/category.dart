import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/services/NewsProviderApi.dart';
import 'package:news_app/screens/Category/widgets/category_app_bar.dart';
import 'package:news_app/screens/Category/widgets/category_buttons.dart';
import 'package:news_app/screens/Category/widgets/news_list.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _selectedCategory = 'General';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CategoryAppBar(),
      body: Column(
        children: [
          CategoryButtons(
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
              Provider.of<NewsProviderApi>(context, listen: false)
                  .setCategory(category.toLowerCase());
            },
          ),
          const Expanded(
            child: NewsList(),
          ),
        ],
      ),
    );
  }
}