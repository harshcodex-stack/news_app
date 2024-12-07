import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category_model.dart';

class CategoryService {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'news_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE categories_new(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            categoryName TEXT
          )
        ''');
      },
    );
  }

  Future<void> addCategory(CategoryModel category) async {
    final db = await database;
    await db.insert('categories_new', category.toMap());
  }

  Future<void> deleteCategory(int id) async {
    final db = await database;
    await db.delete(
      'categories_new',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateCategory(int id, String newCategoryName) async {
    final db = await database;
    await db.update(
      'categories_new',
      {'categoryName': newCategoryName},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<CategoryModel>> fetchCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories_new');
    return List.generate(maps.length, (i) {
      return CategoryModel(
        id: maps[i]['id'],
        categoryName: maps[i]['categoryName'],
      );
    });
  }
}
