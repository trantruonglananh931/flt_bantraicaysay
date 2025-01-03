import 'package:flutter/material.dart';
import '../services/category_service.dart';
import '../models/category.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  List<Category> _categories = [];

  List<Category> get categories => _categories;

  Future<void> fetchCategories() async {
    final response = await _categoryService.getCategories();
    _categories = response.map<Category>((item) => Category.fromJson(item)).toList();
    notifyListeners();
  }

  Future<void> addCategory(String token, Map<String, dynamic> categoryData) async {
    await _categoryService.createCategory(token, categoryData);
    await fetchCategories();
  }

  Future<void> updateCategory(String token, String id, Map<String, dynamic> categoryData) async {
    await _categoryService.updateCategory(token, id, categoryData);
    await fetchCategories();
  }

  Future<void> deleteCategory(String token, String id) async {
    await _categoryService.deleteCategory(token, id);
    await fetchCategories();
  }
}
