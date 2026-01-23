import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/category_model.dart';
import 'supabase_repository.dart';

class CategoryRepository {
  static const String _boxName = 'categories';
  final _supabaseRepo = SupabaseRepository();

  Box<CategoryModel> get _box => Hive.box<CategoryModel>(_boxName);

  // Initialize default categories
  Future<void> initializeDefaultCategories() async {
    if (_box.isEmpty) {
      final defaultCategories = [
        CategoryModel.create(name: 'Food', icon: '🍔'),
        CategoryModel.create(name: 'Transportation', icon: '🚗'),
        CategoryModel.create(name: 'Shopping', icon: '🛒'),
        CategoryModel.create(name: 'Housing', icon: '🏠'),
        CategoryModel.create(name: 'Bills', icon: '📱'),
        CategoryModel.create(name: 'Health', icon: '🏥'),
        CategoryModel.create(name: 'Entertainment', icon: '🎬'),
        CategoryModel.create(name: 'Education', icon: '🎓'),
        CategoryModel.create(name: 'Salary', icon: '💰'),
        CategoryModel.create(name: 'Bonus', icon: '🎁'),
        CategoryModel.create(name: 'Freelance', icon: '💼'),
        CategoryModel.create(name: 'Investment', icon: '📈'),
      ];

      for (var category in defaultCategories) {
        await _box.put(category.id, category);
      }
    }
  }

  // Create locally
  Future<void> addCategory(CategoryModel category) async {
    await _box.put(category.id, category);
    await _syncCategoryToSupabase(category);
  }

  // Create and sync to Supabase
  Future<bool> createCategorySupabase(CategoryModel category) async {
    try {
      if (kDebugMode) print('🎯 Creating category: ${category.name}');
      if (!_supabaseRepo.isAuthenticated) {
        if (kDebugMode) print('❌ Error: User not authenticated');
        // Still save locally even if not authenticated
        await _box.put(category.id, category);
        return true;
      }

      final data = {
        'id': category.id,
        'user_id': _supabaseRepo.currentUserId,
        'name': category.name,
        'icon': category.icon,
        'created_at': category.createdAt.toIso8601String(),
      };
      
      if (kDebugMode) {
        print('📤 Sending to Supabase: $data');
      }

      await _supabaseRepo.client.from('categories').insert(data);

      await _box.put(category.id, category);
      if (kDebugMode) print('🟢 Category synced to Supabase: ${category.name}');
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ Error creating category in Supabase: $e');
      await _box.put(category.id, category);
      return true; // Still return true because saved locally
    }
  }

  // Sync category to Supabase
  Future<void> _syncCategoryToSupabase(CategoryModel category) async {
    try {
      if (!_supabaseRepo.isAuthenticated) return;

      await _supabaseRepo.client.from('categories').upsert({
        'id': category.id,
        'user_id': _supabaseRepo.currentUserId,
        'name': category.name,
        'icon': category.icon,
        'created_at': category.createdAt.toIso8601String(),
      });
    } catch (e) {
      print('Error syncing category to Supabase: $e');
    }
  }

  // Sync from Supabase - fetch all categories from cloud
  Future<void> syncFromSupabase() async {
    try {
      if (!_supabaseRepo.isAuthenticated) {
        if (kDebugMode) print('❌ Cannot sync categories: User not authenticated');
        return;
      }

      if (kDebugMode) print('🔄 Syncing categories from Supabase...');

      final response = await _supabaseRepo.client
          .from('categories')
          .select()
          .eq('user_id', _supabaseRepo.currentUserId!);

      if (kDebugMode) print('📥 Received ${response.length} categories from Supabase');

      for (var data in response) {
        final category = CategoryModel(
          id: data['id'],
          name: data['name'],
          icon: data['icon'] ?? '📁',
          createdAt: DateTime.parse(data['created_at']),
        );

        // Only add if not already in local storage
        if (!_box.containsKey(category.id)) {
          await _box.put(category.id, category);
          if (kDebugMode) print('✅ Added category from cloud: ${category.name}');
        }
      }

      if (kDebugMode) print('🟢 Sync categories from Supabase completed');
    } catch (e) {
      if (kDebugMode) print('❌ Error syncing categories from Supabase: $e');
    }
  }

  // Read
  List<CategoryModel> getAllCategories() {
    return _box.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  CategoryModel? getCategoryById(String id) {
    return _box.get(id);
  }

  // Delete
  Future<void> deleteCategory(String id) async {
    await _box.delete(id);
    // Delete from Supabase too
    try {
      if (_supabaseRepo.isAuthenticated) {
        await _supabaseRepo.client.from('categories').delete().eq('id', id);
      }
    } catch (e) {
      print('Error deleting category from Supabase: $e');
    }
  }
}
