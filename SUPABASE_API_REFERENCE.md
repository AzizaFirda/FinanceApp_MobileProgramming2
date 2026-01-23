# Supabase API Integration Reference - Money Manager

## Quick Start untuk Flutter Integration

### 1. Query Examples

```dart
// ============================================
// USERS
// ============================================

// Get current user profile
Future<Map<String, dynamic>> getUserProfile(String userId) async {
  return await _supabase
    .from('users')
    .select('*')
    .eq('id', userId)
    .single();
}

// Update user profile
Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
  await _supabase
    .from('users')
    .update({
      ...data,
      'updated_at': DateTime.now().toIso8601String(),
    })
    .eq('id', userId);
}

// ============================================
// ACCOUNTS
// ============================================

// Get all accounts for user
Future<List<Map<String, dynamic>>> getAccounts(String userId) async {
  return await _supabase
    .from('accounts')
    .select('*')
    .eq('user_id', userId)
    .order('created_at', ascending: false);
}

// Get active accounts only
Future<List<Map<String, dynamic>>> getActiveAccounts(String userId) async {
  return await _supabase
    .from('accounts')
    .select('*')
    .eq('user_id', userId)
    .eq('is_active', true)
    .order('created_at', ascending: false);
}

// Create account
Future<Map<String, dynamic>> createAccount(
  String userId,
  String name,
  String type,
  String icon,
  int color,
  double initialBalance,
) async {
  return await _supabase
    .from('accounts')
    .insert({
      'user_id': userId,
      'name': name,
      'type': type,
      'icon': icon,
      'color': color,
      'initial_balance': initialBalance,
      'current_balance': initialBalance,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    })
    .select()
    .single();
}

// Update account
Future<void> updateAccount(String accountId, Map<String, dynamic> data) async {
  await _supabase
    .from('accounts')
    .update({
      ...data,
      'updated_at': DateTime.now().toIso8601String(),
    })
    .eq('id', accountId);
}

// Update account balance
Future<void> updateAccountBalance(String accountId, double newBalance) async {
  await _supabase
    .from('accounts')
    .update({
      'current_balance': newBalance,
      'updated_at': DateTime.now().toIso8601String(),
    })
    .eq('id', accountId);
}

// Delete account
Future<void> deleteAccount(String accountId) async {
  await _supabase
    .from('accounts')
    .delete()
    .eq('id', accountId);
}

// ============================================
// CATEGORIES
// ============================================

// Get all categories
Future<List<Map<String, dynamic>>> getCategories(String userId) async {
  return await _supabase
    .from('categories')
    .select('*')
    .eq('user_id', userId)
    .order('name', ascending: true);
}

// Get categories by type
Future<List<Map<String, dynamic>>> getCategoriesByType(
  String userId,
  String type,
) async {
  return await _supabase
    .from('categories')
    .select('*')
    .eq('user_id', userId)
    .eq('type', type)
    .order('name', ascending: true);
}

// Create category
Future<Map<String, dynamic>> createCategory(
  String userId,
  String name,
  String type,
  String icon,
  int color,
) async {
  return await _supabase
    .from('categories')
    .insert({
      'user_id': userId,
      'name': name,
      'type': type,
      'icon': icon,
      'color': color,
      'is_default': false,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    })
    .select()
    .single();
}

// Update category
Future<void> updateCategory(String categoryId, Map<String, dynamic> data) async {
  await _supabase
    .from('categories')
    .update({
      ...data,
      'updated_at': DateTime.now().toIso8601String(),
    })
    .eq('id', categoryId);
}

// Delete category
Future<void> deleteCategory(String categoryId) async {
  await _supabase
    .from('categories')
    .delete()
    .eq('id', categoryId);
}

// ============================================
// TRANSACTIONS
// ============================================

// Get all transactions
Future<List<Map<String, dynamic>>> getTransactions(String userId) async {
  return await _supabase
    .from('transactions')
    .select('*')
    .eq('user_id', userId)
    .order('date', ascending: false);
}

// Get transactions for specific account
Future<List<Map<String, dynamic>>> getAccountTransactions(
  String userId,
  String accountId,
) async {
  return await _supabase
    .from('transactions')
    .select('*')
    .eq('user_id', userId)
    .eq('account_id', accountId)
    .order('date', ascending: false);
}

// Get transactions by date range
Future<List<Map<String, dynamic>>> getTransactionsByDateRange(
  String userId,
  DateTime startDate,
  DateTime endDate,
) async {
  return await _supabase
    .from('transactions')
    .select('*')
    .eq('user_id', userId)
    .gte('date', startDate.toIso8601String())
    .lte('date', endDate.toIso8601String())
    .order('date', ascending: false);
}

// Get transactions by type (income, expense, transfer)
Future<List<Map<String, dynamic>>> getTransactionsByType(
  String userId,
  String type,
) async {
  return await _supabase
    .from('transactions')
    .select('*')
    .eq('user_id', userId)
    .eq('type', type)
    .order('date', ascending: false);
}

// Get expense transactions by category
Future<List<Map<String, dynamic>>> getExpensesByCategory(
  String userId,
  String categoryId,
) async {
  return await _supabase
    .from('transactions')
    .select('*')
    .eq('user_id', userId)
    .eq('category_id', categoryId)
    .eq('type', 'expense')
    .order('date', ascending: false);
}

// Create transaction
Future<Map<String, dynamic>> createTransaction({
  required String userId,
  required String accountId,
  required String categoryId,
  required double amount,
  required String type, // income, expense, transfer
  String? toAccountId,
  String? note,
  required DateTime date,
}) async {
  return await _supabase
    .from('transactions')
    .insert({
      'user_id': userId,
      'account_id': accountId,
      'category_id': categoryId,
      'to_account_id': toAccountId,
      'amount': amount,
      'type': type,
      'note': note,
      'date': date.toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    })
    .select()
    .single();
}

// Update transaction
Future<void> updateTransaction(
  String transactionId,
  Map<String, dynamic> data,
) async {
  await _supabase
    .from('transactions')
    .update({
      ...data,
      'updated_at': DateTime.now().toIso8601String(),
    })
    .eq('id', transactionId);
}

// Delete transaction
Future<void> deleteTransaction(String transactionId) async {
  await _supabase
    .from('transactions')
    .delete()
    .eq('id', transactionId);
}

// ============================================
// BUDGETS
// ============================================

// Get all budgets
Future<List<Map<String, dynamic>>> getBudgets(String userId) async {
  return await _supabase
    .from('budgets')
    .select('*')
    .eq('user_id', userId)
    .order('start_date', ascending: false);
}

// Get active budgets
Future<List<Map<String, dynamic>>> getActiveBudgets(String userId) async {
  final now = DateTime.now().toIso8601String();
  return await _supabase
    .from('budgets')
    .select('*')
    .eq('user_id', userId)
    .lte('start_date', now)
    .gte('end_date', now)
    .order('start_date', ascending: false);
}

// Create budget
Future<Map<String, dynamic>> createBudget({
  required String userId,
  required String categoryId,
  required double amount,
  required String period, // weekly, monthly, yearly
  required DateTime startDate,
  required DateTime endDate,
}) async {
  return await _supabase
    .from('budgets')
    .insert({
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'period': period,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    })
    .select()
    .single();
}

// Update budget
Future<void> updateBudget(String budgetId, Map<String, dynamic> data) async {
  await _supabase
    .from('budgets')
    .update({
      ...data,
      'updated_at': DateTime.now().toIso8601String(),
    })
    .eq('id', budgetId);
}

// Delete budget
Future<void> deleteBudget(String budgetId) async {
  await _supabase
    .from('budgets')
    .delete()
    .eq('id', budgetId);
}

// ============================================
// STORAGE - Profile Photos
// ============================================

// Upload profile photo
Future<String> uploadProfilePhoto(String userId, File imageFile) async {
  final fileName = 'profile_photos/${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
  
  await _supabase.storage
    .from('profiles')
    .uploadBinary(
      fileName,
      await imageFile.readAsBytes(),
      fileOptions: const FileOptions(
        cacheControl: '3600',
        upsert: false,
      ),
    );
  
  // Get public URL
  final url = _supabase.storage
    .from('profiles')
    .getPublicUrl(fileName);
  
  return url;
}

// Delete profile photo
Future<void> deleteProfilePhoto(String photoUrl) async {
  try {
    final uri = Uri.parse(photoUrl);
    final filePath = uri.pathSegments.skip(2).join('/');
    
    await _supabase.storage
      .from('profiles')
      .remove([filePath]);
  } catch (e) {
    debugPrint('Error deleting photo: $e');
  }
}

// ============================================
// AGGREGATION & STATISTICS
// ============================================

// Get total balance across all accounts
Future<double> getTotalBalance(String userId) async {
  final accounts = await getAccounts(userId);
  double total = 0;
  for (var account in accounts) {
    total += (account['current_balance'] as num).toDouble();
  }
  return total;
}

// Get total expenses for month
Future<double> getTotalExpensesForMonth(String userId, DateTime month) async {
  final startDate = DateTime(month.year, month.month, 1);
  final endDate = DateTime(month.year, month.month + 1, 1);
  
  final transactions = await getTransactionsByDateRange(
    userId,
    startDate,
    endDate,
  );
  
  double total = 0;
  for (var tx in transactions) {
    if (tx['type'] == 'expense') {
      total += (tx['amount'] as num).toDouble();
    }
  }
  return total;
}

// Get expenses by category
Future<Map<String, double>> getExpensesByCategory(String userId) async {
  final transactions = await getTransactions(userId);
  final expenses = <String, double>{};
  
  for (var tx in transactions) {
    if (tx['type'] == 'expense') {
      final categoryId = tx['category_id'] as String;
      final amount = (tx['amount'] as num).toDouble();
      expenses[categoryId] = (expenses[categoryId] ?? 0) + amount;
    }
  }
  
  return expenses;
}

// ============================================
// HELPER: Insert Default Categories
// ============================================

Future<void> insertDefaultCategories(String userId) async {
  final defaultCategories = [
    // Expense categories
    {'name': 'Food & Dining', 'type': 'expense', 'icon': '🍔', 'color': 0xFFFF6B6B},
    {'name': 'Transportation', 'type': 'expense', 'icon': '🚗', 'color': 0xFF4ECDC4},
    {'name': 'Shopping', 'type': 'expense', 'icon': '🛍️', 'color': 0xFFFFB347},
    {'name': 'Entertainment', 'type': 'expense', 'icon': '🎬', 'color': 0xFF95E1D3},
    {'name': 'Utilities', 'type': 'expense', 'icon': '💡', 'color': 0xFFF38181},
    {'name': 'Healthcare', 'type': 'expense', 'icon': '⚕️', 'color': 0xFF4A90E2},
    {'name': 'Education', 'type': 'expense', 'icon': '📚', 'color': 0xFF9B59B6},
    
    // Income categories
    {'name': 'Salary', 'type': 'income', 'icon': '💰', 'color': 0xFF2ECC71},
    {'name': 'Bonus', 'type': 'income', 'icon': '🎁', 'color': 0xFF27AE60},
    {'name': 'Freelance', 'type': 'income', 'icon': '💻', 'color': 0xFF16A085},
  ];
  
  for (var category in defaultCategories) {
    try {
      await createCategory(
        userId,
        category['name'] as String,
        category['type'] as String,
        category['icon'] as String,
        category['color'] as int,
      );
    } catch (e) {
      debugPrint('Error creating category: $e');
    }
  }
}
```

---

## Integration dengan Existing Repositories

Update file `lib/data/repositories/` untuk gunakan Supabase:

```dart
// Example: transaction_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<TransactionModel>> getTransactions() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      final data = await _supabase
        .from('transactions')
        .select('*')
        .eq('user_id', userId)
        .order('date', ascending: false);

      return (data as List)
        .map((e) => TransactionModel.fromJson(e))
        .toList();
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }

  Future<void> createTransaction(TransactionModel transaction) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      await _supabase.from('transactions').insert({
        ...transaction.toJson(),
        'user_id': userId,
      });
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }
}
```

---

## Notes

- Semua timestamps menggunakan **ISO 8601 format** (`.toIso8601String()`)
- Warna disimpan sebagai **integer** dalam format `0xFFRRGGBB`
- RLS policies memastikan **user hanya bisa akses data miliknya**
- Indexing sudah optimal untuk **query performance**
- Storage bucket `profiles` berstatus **public** untuk akses foto

