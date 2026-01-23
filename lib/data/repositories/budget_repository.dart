import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/budget_model.dart';
import 'supabase_repository.dart';

class BudgetRepository {
  static const String _boxName = 'budgets';
  final _supabaseRepo = SupabaseRepository();

  Box<BudgetModel> get _box => Hive.box<BudgetModel>(_boxName);

  // Create locally
  Future<void> addBudget(BudgetModel budget) async {
    await _box.put(budget.id, budget);
    await _syncBudgetToSupabase(budget);
  }

  // Create and sync to Supabase
  Future<bool> createBudgetSupabase(BudgetModel budget) async {
    try {
      if (kDebugMode) print('📊 Creating budget for category: ${budget.categoryId}');
      if (!_supabaseRepo.isAuthenticated) {
        if (kDebugMode) print('❌ Error: User not authenticated');
        await _box.put(budget.id, budget);
        return false;
      }

      await _supabaseRepo.client.from('budgets').insert({
        'id': budget.id,
        'user_id': _supabaseRepo.currentUserId,
        'category_id': budget.categoryId,
        'amount': budget.amount,
        'period': budget.period,
        'start_date': budget.startDate.toIso8601String(),
        'end_date': budget.endDate.toIso8601String(),
      });

      await _box.put(budget.id, budget);
      if (kDebugMode) print('🟢 Budget synced to Supabase');
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ Error creating budget in Supabase: $e');
      await _box.put(budget.id, budget);
      return false;
    }
  }

  // Sync budget to Supabase
  Future<void> _syncBudgetToSupabase(BudgetModel budget) async {
    try {
      if (!_supabaseRepo.isAuthenticated) return;

      await _supabaseRepo.client.from('budgets').upsert({
        'id': budget.id,
        'user_id': _supabaseRepo.currentUserId,
        'category_id': budget.categoryId,
        'amount': budget.amount,
        'period': budget.period,
        'start_date': budget.startDate.toIso8601String(),
        'end_date': budget.endDate.toIso8601String(),
      });
    } catch (e) {
      print('Error syncing budget to Supabase: $e');
    }
  }

  // Read
  List<BudgetModel> getAllBudgets() {
    return _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<BudgetModel> getActiveBudgets() {
    final now = DateTime.now();
    return _box.values
        .where((b) => b.startDate.isBefore(now) && b.endDate.isAfter(now))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<BudgetModel> getBudgetsByCategory(String categoryId) {
    return _box.values.where((b) => b.categoryId == categoryId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<BudgetModel> getBudgetsByPeriod(String period) {
    return _box.values.where((b) => b.period == period).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  BudgetModel? getBudgetById(String id) {
    return _box.get(id);
  }

  // Update
  Future<void> updateBudget(BudgetModel budget) async {
    budget.updatedAt = DateTime.now();
    await budget.save();
    await _syncBudgetToSupabase(budget);
  }

  // Delete
  Future<void> deleteBudget(String id) async {
    final budget = _box.get(id);
    if (budget != null) {
      await _box.delete(id);
      // Delete from Supabase too
      try {
        if (_supabaseRepo.isAuthenticated) {
          await _supabaseRepo.client.from('budgets').delete().eq('id', id);
        }
      } catch (e) {
        print('Error deleting budget from Supabase: $e');
      }
    }
  }

  // Clear all
  Future<void> clearAll() async {
    await _box.clear();
  }
}
