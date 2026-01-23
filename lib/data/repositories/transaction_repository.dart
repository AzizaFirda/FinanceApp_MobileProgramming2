import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/transaction_model.dart';
import '../models/account_model.dart';
import 'supabase_repository.dart';

class TransactionRepository {
  static const String _boxName = 'transactions';
  static const String _accountBoxName = 'accounts';
  final _supabaseRepo = SupabaseRepository();

  Box<TransactionModel> get _box => Hive.box<TransactionModel>(_boxName);
  Box<AccountModel> get _accountBox => Hive.box<AccountModel>(_accountBoxName);

  // Create locally
  Future<void> addTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
    await _updateAccountBalance(transaction, isAdd: true);
    await _syncTransactionToSupabase(transaction);
  }

  // Create and sync to Supabase
  Future<bool> createTransactionSupabase(TransactionModel transaction) async {
    try {
      if (kDebugMode) print('💳 Creating transaction: ${transaction.id}');
      if (kDebugMode) print('🔐 Checking authentication...');
      
      if (!_supabaseRepo.isAuthenticated) {
        if (kDebugMode) print('❌ Error: User not authenticated');
        await _box.put(transaction.id, transaction);
        await _updateAccountBalance(transaction, isAdd: true);
        return false;
      }

      if (kDebugMode) print('✅ User authenticated. Syncing to Supabase...');
      await _supabaseRepo.client.from('transactions').insert({
        'id': transaction.id,
        'user_id': _supabaseRepo.currentUserId,
        'account_id': transaction.accountId,
        'category_id': transaction.categoryId,
        'to_account_id': transaction.toAccountId,
        'amount': transaction.amount,
        'type': _transactionTypeToString(transaction.type),
        'note': transaction.note,
        'date': transaction.date.toIso8601String(),
      });

      if (kDebugMode) print('🟢 Transaction synced to Supabase: ${transaction.id}');
      await _box.put(transaction.id, transaction);
      await _updateAccountBalance(transaction, isAdd: true);
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ Error creating transaction in Supabase: $e');
      await _box.put(transaction.id, transaction);
      await _updateAccountBalance(transaction, isAdd: true);
      return false;
    }
  }

  // Sync transaction to Supabase
  Future<void> _syncTransactionToSupabase(TransactionModel transaction) async {
    try {
      if (!_supabaseRepo.isAuthenticated) return;

      await _supabaseRepo.client.from('transactions').upsert({
        'id': transaction.id,
        'user_id': _supabaseRepo.currentUserId,
        'account_id': transaction.accountId,
        'category_id': transaction.categoryId,
        'to_account_id': transaction.toAccountId,
        'amount': transaction.amount,
        'type': _transactionTypeToString(transaction.type),
        'note': transaction.note,
        'date': transaction.date.toIso8601String(),
      });
    } catch (e) {
      print('Error syncing transaction to Supabase: $e');
    }
  }

  // Read
  List<TransactionModel> getAllTransactions() {
    return _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  // Sync from Supabase - fetch all transactions from cloud
  Future<void> syncFromSupabase() async {
    try {
      if (!_supabaseRepo.isAuthenticated) {
        if (kDebugMode) print('❌ Cannot sync: User not authenticated');
        return;
      }

      if (kDebugMode) print('🔄 Syncing transactions from Supabase...');

      final response = await _supabaseRepo.client
          .from('transactions')
          .select()
          .eq('user_id', _supabaseRepo.currentUserId!);

      if (kDebugMode) print('📥 Received ${response.length} transactions from Supabase');

      for (var data in response) {
        final dateTime = DateTime.parse(data['date']);
        final transaction = TransactionModel(
          id: data['id'],
          accountId: data['account_id'],
          categoryId: data['category_id'] ?? '',
          toAccountId: data['to_account_id'],
          amount: (data['amount'] as num).toDouble(),
          type: _stringToTransactionType(data['type']),
          note: data['note'] ?? '',
          date: dateTime,
          createdAt: data['created_at'] != null 
              ? DateTime.parse(data['created_at']) 
              : dateTime,
          updatedAt: data['updated_at'] != null 
              ? DateTime.parse(data['updated_at']) 
              : dateTime,
        );

        // Only add if not already in local storage
        if (!_box.containsKey(transaction.id)) {
          await _box.put(transaction.id, transaction);
          if (kDebugMode) print('✅ Added transaction from cloud: ${transaction.id}');
        }
      }

      if (kDebugMode) print('🟢 Sync from Supabase completed');
    } catch (e) {
      if (kDebugMode) print('❌ Error syncing from Supabase: $e');
    }
  }

  // Helper: Convert string to TransactionType enum
  TransactionType _stringToTransactionType(String type) {
    switch (type) {
      case 'income':
        return TransactionType.income;
      case 'expense':
        return TransactionType.expense;
      case 'transfer':
        return TransactionType.transfer;
      default:
        return TransactionType.expense;
    }
  }

  List<TransactionModel> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return _box.values
        .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<TransactionModel> getTransactionsByMonth(int year, int month) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0, 23, 59, 59);

    return _box.values
        .where(
          (t) =>
              t.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
              t.date.isBefore(end.add(const Duration(seconds: 1))),
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<TransactionModel> getTransactionsByCategory(String categoryId) {
    return _box.values.where((t) => t.categoryId == categoryId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<TransactionModel> getTransactionsByAccount(String accountId) {
    return _box.values
        .where((t) => t.accountId == accountId || t.toAccountId == accountId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  TransactionModel? getTransactionById(String id) {
    return _box.get(id);
  }

  // Update
  Future<void> updateTransaction(
    TransactionModel oldTransaction,
    TransactionModel newTransaction,
  ) async {
    // Revert old transaction balance
    await _updateAccountBalance(oldTransaction, isAdd: false);

    // Apply new transaction balance
    await _updateAccountBalance(newTransaction, isAdd: true);

    // Update transaction
    await _box.put(newTransaction.id, newTransaction);
  }

  // Delete
  Future<void> deleteTransaction(String id) async {
    final transaction = _box.get(id);
    if (transaction != null) {
      await _updateAccountBalance(transaction, isAdd: false);
      await _box.delete(id);
      // Delete from Supabase too
      try {
        if (_supabaseRepo.isAuthenticated) {
          await _supabaseRepo.client.from('transactions').delete().eq('id', id);
        }
      } catch (e) {
        print('Error deleting transaction from Supabase: $e');
      }
    }
  }

  // Helper: Convert TransactionType enum to string
  String _transactionTypeToString(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return 'income';
      case TransactionType.expense:
        return 'expense';
      case TransactionType.transfer:
        return 'transfer';
    }
  }

  // Statistics
  double getTotalExpenses({DateTime? start, DateTime? end}) {
    var transactions = _box.values.where(
      (t) => t.type == TransactionType.expense,
    );

    if (start != null && end != null) {
      transactions = transactions.where(
        (t) => t.date.isAfter(start) && t.date.isBefore(end),
      );
    }

    return transactions.fold(0.0, (sum, t) => sum + t.amount);
  }

  double getTotalIncome({DateTime? start, DateTime? end}) {
    var transactions = _box.values.where(
      (t) => t.type == TransactionType.income,
    );

    if (start != null && end != null) {
      transactions = transactions.where(
        (t) => t.date.isAfter(start) && t.date.isBefore(end),
      );
    }

    return transactions.fold(0.0, (sum, t) => sum + t.amount);
  }

  Map<String, double> getExpensesByCategory({DateTime? start, DateTime? end}) {
    var transactions = _box.values.where(
      (t) => t.type == TransactionType.expense,
    );

    if (start != null && end != null) {
      transactions = transactions.where(
        (t) => t.date.isAfter(start) && t.date.isBefore(end),
      );
    }

    Map<String, double> categoryTotals = {};
    for (var transaction in transactions) {
      final categoryId = transaction.categoryId;
      categoryTotals[categoryId] =
          (categoryTotals[categoryId] ?? 0) + transaction.amount;
    }

    return categoryTotals;
  }

  // Private helper method to update account balances
  Future<void> _updateAccountBalance(
    TransactionModel transaction, {
    required bool isAdd,
  }) async {
    final account = _accountBox.get(transaction.accountId);
    if (account == null) return;

    double amount = transaction.amount;
    if (!isAdd) amount = -amount;

    switch (transaction.type) {
      case TransactionType.expense:
        account.updateBalance(-amount);
        break;
      case TransactionType.income:
        account.updateBalance(amount);
        break;
      case TransactionType.transfer:
        if (transaction.toAccountId != null) {
          final toAccount = _accountBox.get(transaction.toAccountId!);
          if (toAccount != null) {
            account.updateBalance(-amount);
            toAccount.updateBalance(amount);
            await toAccount.save();
            // Sync toAccount balance to Supabase
            await _syncAccountBalanceToSupabase(toAccount);
          }
        }
        break;
    }

    await account.save();
    // Sync account balance to Supabase
    await _syncAccountBalanceToSupabase(account);
  }

  // Sync account balance to Supabase
  Future<void> _syncAccountBalanceToSupabase(AccountModel account) async {
    try {
      if (!_supabaseRepo.isAuthenticated) return;

      // Convert color to hex string to avoid integer overflow
      final colorHex = '#${account.color.toRadixString(16).padLeft(8, '0')}';

      await _supabaseRepo.client.from('accounts').upsert({
        'id': account.id,
        'user_id': _supabaseRepo.currentUserId,
        'name': account.name,
        'type': _accountTypeToString(account.type),
        'icon': account.icon,
        'color': colorHex,
        'initial_balance': account.initialBalance,
        'current_balance': account.currentBalance,
        'is_active': account.isActive,
      });
      if (kDebugMode) print('✅ Account balance synced to Supabase: ${account.name} = ${account.currentBalance}');
    } catch (e) {
      if (kDebugMode) print('❌ Error syncing account balance to Supabase: $e');
    }
  }

  // Helper: Convert AccountType enum to string
  String _accountTypeToString(AccountType type) {
    switch (type) {
      case AccountType.cash:
        return 'cash';
      case AccountType.bank:
        return 'bank';
      case AccountType.ewallet:
        return 'ewallet';
      case AccountType.liability:
        return 'liability';
    }
  }

  // Clear all transactions (for testing/reset)
  Future<void> clearAll() async {
    await _box.clear();
  }
}
