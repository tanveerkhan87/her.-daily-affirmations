import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider extends ChangeNotifier {
  static const String _key = 'selected_category_id';
  String _selectedCategoryId = 'all_kinds';

  String get selectedCategoryId => _selectedCategoryId;

  CategoryProvider() {
    _loadSelectedCategory();
  }

  Future<void> _loadSelectedCategory() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCategoryId = prefs.getString(_key) ?? 'all_kinds';
    notifyListeners();
  }

  Future<void> setCategory(String categoryId) async {
    if (_selectedCategoryId == categoryId) return;
    _selectedCategoryId = categoryId;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, categoryId);
  }
}
