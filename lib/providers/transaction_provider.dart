import 'package:flutter/foundation.dart';
import '../data/models/transaction_model.dart';
import '../data/repositories/transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _error;

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  TransactionProvider() {
    loadTransactions();
  }

  // Load all transactions
  Future<void> loadTransactions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // First sync from Supabase to get cloud data
      await _repository.syncFromSupabase();
      // Then load all transactions (local + synced)
      _transactions = _repository.getAllTransactions();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add transaction
  Future<bool> addTransaction(TransactionModel transaction) async {
    try {
      // Try to sync to Supabase first
      await _repository.createTransactionSupabase(transaction);
      await loadTransactions();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update transaction
  Future<bool> updateTransaction(
    TransactionModel oldTransaction,
    TransactionModel newTransaction,
  ) async {
    try {
      await _repository.updateTransaction(oldTransaction, newTransaction);
      await loadTransactions();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete transaction
  Future<bool> deleteTransaction(String id) async {
    try {
      await _repository.deleteTransaction(id);
      await loadTransactions();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Get transactions by month
  List<TransactionModel> getTransactionsByMonth(int year, int month) {
    return _repository.getTransactionsByMonth(year, month);
  }

  // Get transactions by date range
  List<TransactionModel> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return _repository.getTransactionsByDateRange(start, end);
  }

  // Get transactions by category
  List<TransactionModel> getTransactionsByCategory(String categoryId) {
    return _repository.getTransactionsByCategory(categoryId);
  }

  // Get transactions by account
  List<TransactionModel> getTransactionsByAccount(String accountId) {
    return _repository.getTransactionsByAccount(accountId);
  }

  // Get monthly summary
  Map<String, double> getMonthlySummary(int year, int month) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0, 23, 59, 59);

    final totalExpense = _repository.getTotalExpenses(start: start, end: end);
    final totalIncome = _repository.getTotalIncome(start: start, end: end);
    final balance = totalIncome - totalExpense;

    return {'expense': totalExpense, 'income': totalIncome, 'balance': balance};
  }

  // Get expense breakdown by category
  Map<String, double> getExpensesByCategory({DateTime? start, DateTime? end}) {
    return _repository.getExpensesByCategory(start: start, end: end);
  }

  // Get recent transactions (last 10)
  List<TransactionModel> getRecentTransactions({int limit = 10}) {
    return _transactions.take(limit).toList();
  }

  // Get transactions for today
  List<TransactionModel> getTodayTransactions() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return _repository.getTransactionsByDateRange(start, end);
  }

  // Get total expense for current month
  double getCurrentMonthExpense() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    return _repository.getTotalExpenses(start: start, end: end);
  }

  // Get total income for current month
  double getCurrentMonthIncome() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    return _repository.getTotalIncome(start: start, end: end);
  }

  // Get daily transactions grouped by date
  Map<DateTime, List<TransactionModel>> getTransactionsGroupedByDate(
    int year,
    int month,
  ) {
    final transactions = getTransactionsByMonth(year, month);
    Map<DateTime, List<TransactionModel>> grouped = {};

    for (var transaction in transactions) {
      final date = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(transaction);
    }

    return grouped;
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
