import 'package:flutter/foundation.dart';
import '../data/models/category_model.dart';
import '../data/repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository = CategoryRepository();

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CategoryProvider() {
    loadCategories();
  }

  // Load all categories
  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Sync from Supabase to get cloud data
      await _repository.syncFromSupabase();
      // Then load all categories
      _categories = _repository.getAllCategories();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add category
  Future<bool> addCategory(CategoryModel category) async {
    try {
      // Try to sync to Supabase first
      await _repository.createCategorySupabase(category);
      await loadCategories();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update category
  Future<bool> updateCategory(CategoryModel category) async {
    try {
      await _repository.addCategory(category);
      await loadCategories();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete category
  Future<bool> deleteCategory(String id) async {
    try {
      await _repository.deleteCategory(id);
      await loadCategories();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Get categories by type
  List<CategoryModel> getExpenseCategories() {
    return _categories;
  }

  List<CategoryModel> getIncomeCategories() {
    return _categories;
  }

  // Get all categories
  List<CategoryModel> getAllCategories() {
    return _categories;
  }

  // Get category by id
  CategoryModel? getCategoryById(String id) {
    return _repository.getCategoryById(id);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
