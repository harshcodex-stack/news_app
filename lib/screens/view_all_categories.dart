import 'package:flutter/material.dart';
import 'package:news_app_world/models/category_model.dart';
import 'package:news_app_world/services/category_service.dart';
import 'add_category_screen.dart';

class ViewAllCategoryScreen extends StatefulWidget {
  const ViewAllCategoryScreen({super.key, required List<CategoryModel> categories});

  @override
  _ViewAllCategoryScreenState createState() => _ViewAllCategoryScreenState();
}

class _ViewAllCategoryScreenState extends State<ViewAllCategoryScreen> {
  late List<CategoryModel> categories;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    categories = await CategoryService().fetchCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
        centerTitle: true,
      ),
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index].categoryName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCategoryScreen(
                          category: categories[index],
                          onUpdate: _loadCategories,
                        ),
                      ),
                    );
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await CategoryService().deleteCategory(categories[index].id!);
                    _loadCategories();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
