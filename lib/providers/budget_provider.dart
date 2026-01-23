import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../data/models/budget_model.dart';
import '../data/repositories/budget_repository.dart';

class BudgetProvider extends ChangeNotifier {
  static const String _boxName = 'budgets';
  final _repository = BudgetRepository();

  Box<BudgetModel> get _box => Hive.box<BudgetModel>(_boxName);

  List<BudgetModel> _budgets = [];
  bool _isLoading = false;
  String? _error;

  List<BudgetModel> get budgets => _budgets;
  bool get isLoading => _isLoading;
  String? get error => _error;

  BudgetProvider() {
    _openBox();
  }

  Future<void> _openBox() async {
    try {
      if (!Hive.isBoxOpen(_boxName)) {
        await Hive.openBox<BudgetModel>(_boxName);
      }
      loadBudgets();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Load all budgets
  Future<void> loadBudgets() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _budgets = _box.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add budget
  Future<bool> addBudget(BudgetModel budget) async {
    try {
      // Try to sync to Supabase first
      await _repository.createBudgetSupabase(budget);
      await loadBudgets();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update budget
  Future<bool> updateBudget(BudgetModel budget) async {
    try {
      budget.updatedAt = DateTime.now();
      await budget.save();
      await loadBudgets();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete budget
  Future<bool> deleteBudget(String id) async {
    try {
      await _box.delete(id);
      await loadBudgets();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Get budget by category
  BudgetModel? getBudgetByCategory(String categoryId) {
    final now = DateTime.now();
    try {
      return _budgets.firstWhere(
        (b) =>
            b.categoryId == categoryId &&
            b.startDate.isBefore(now) &&
            b.endDate.isAfter(now),
      );
    } catch (e) {
      return null;
    }
  }

  // Get current month budgets
  List<BudgetModel> getCurrentMonthBudgets() {
    final now = DateTime.now();
    return _budgets
        .where((b) => b.startDate.isBefore(now) && b.endDate.isAfter(now))
        .toList();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
