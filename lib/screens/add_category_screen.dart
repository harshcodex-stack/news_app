import 'package:flutter/material.dart';
import 'package:news_app_world/models/category_model.dart';
import 'package:news_app_world/services/category_service.dart';

class AddCategoryScreen extends StatefulWidget {
  final CategoryModel? category;
  final Function onUpdate;

  const AddCategoryScreen({super.key, this.category, required this.onUpdate});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _categoryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _categoryNameController.text = widget.category!.categoryName;
    }
  }

  void _saveCategory() async {
    if (widget.category != null) {
      int categoryId = widget.category!.id!;
      await CategoryService().updateCategory(categoryId, _categoryNameController.text);
    } else {

      CategoryService().addCategory(
        CategoryModel(categoryName: _categoryNameController.text),
      );
    }
    widget.onUpdate();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? 'Add Category' : 'Edit Category'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _categoryNameController,
              decoration: const InputDecoration(labelText: 'Category Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveCategory,
              child: Text(widget.category == null ? 'Add Category' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
