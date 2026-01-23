# 🔗 Repository Integration Guide

## Overview
Panduan lengkap mengintegrasikan Supabase REST API dengan existing repository di Money Manager app.

---

## File Structure

Repository files yang perlu diupdate:

```
lib/data/repositories/
├── account_repository.dart
├── category_repository.dart
├── transaction_repository.dart
├── budget_repository.dart
└── user_repository.dart (baru)
```

---

## 1. User Repository

**File:** `lib/data/repositories/user_repository.dart`

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile_model.dart';

class UserRepository {
  final SupabaseClient _client;

  UserRepository(this._client);

  /// Get current user profile
  Future<UserProfileModel?> getCurrentUser() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      return UserProfileModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  /// Create user profile after registration
  Future<void> createUserProfile(String userId, String email) async {
    try {
      await _client
          .from('users')
          .insert({
            'id': userId,
            'email': email,
          });
    } catch (e) {
      print('Error creating user profile: $e');
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(
    String userId, {
    required String email,
  }) async {
    try {
      await _client
          .from('users')
          .update({
            'email': email,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  /// Delete user profile
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _client
          .from('users')
          .delete()
          .eq('id', userId);
    } catch (e) {
      print('Error deleting user profile: $e');
      rethrow;
    }
  }
}
```

---

## 2. Account Repository

**File:** `lib/data/repositories/account_repository.dart`

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/account_model.dart';

class AccountRepository {
  final SupabaseClient _client;

  AccountRepository(this._client);

  /// Get all accounts for user
  Future<List<AccountModel>> getAccounts(String userId) async {
    try {
      final response = await _client
          .from('accounts')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((e) => AccountModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting accounts: $e');
      return [];
    }
  }

  /// Get single account
  Future<AccountModel?> getAccount(String accountId) async {
    try {
      final response = await _client
          .from('accounts')
          .select()
          .eq('id', accountId)
          .single();

      return AccountModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error getting account: $e');
      return null;
    }
  }

  /// Create new account
  Future<AccountModel?> createAccount(
    String userId,
    String name,
    String accountType, {
    required double balance,
    String currency = 'IDR',
    bool isDefault = false,
    String color = '#6366F1',
    String iconName = 'bank',
    String? notes,
  }) async {
    try {
      final response = await _client
          .from('accounts')
          .insert({
            'user_id': userId,
            'name': name,
            'account_type': accountType,
            'balance': balance,
            'currency': currency,
            'is_default': isDefault,
            'color': color,
            'icon_name': iconName,
            'notes': notes,
          })
          .select()
          .single();

      return AccountModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error creating account: $e');
      rethrow;
    }
  }

  /// Update account
  Future<AccountModel?> updateAccount(
    String accountId, {
    String? name,
    String? accountType,
    double? balance,
    String? currency,
    bool? isDefault,
    String? color,
    String? iconName,
    String? notes,
  }) async {
    try {
      final data = <String, dynamic>{
        if (name != null) 'name': name,
        if (accountType != null) 'account_type': accountType,
        if (balance != null) 'balance': balance,
        if (currency != null) 'currency': currency,
        if (isDefault != null) 'is_default': isDefault,
        if (color != null) 'color': color,
        if (iconName != null) 'icon_name': iconName,
        if (notes != null) 'notes': notes,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _client
          .from('accounts')
          .update(data)
          .eq('id', accountId)
          .select()
          .single();

      return AccountModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error updating account: $e');
      rethrow;
    }
  }

  /// Delete account
  Future<void> deleteAccount(String accountId) async {
    try {
      await _client
          .from('accounts')
          .delete()
          .eq('id', accountId);
    } catch (e) {
      print('Error deleting account: $e');
      rethrow;
    }
  }

  /// Get total balance across all accounts
  Future<double> getTotalBalance(String userId) async {
    try {
      final accounts = await getAccounts(userId);
      return accounts.fold<double>(0, (sum, account) => sum + account.balance);
    } catch (e) {
      print('Error calculating total balance: $e');
      return 0;
    }
  }

  /// Update account balance (for transaction)
  Future<void> updateBalance(String accountId, double newBalance) async {
    try {
      await _client
          .from('accounts')
          .update({
            'balance': newBalance,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', accountId);
    } catch (e) {
      print('Error updating balance: $e');
      rethrow;
    }
  }
}
```

---

## 3. Category Repository

**File:** `lib/data/repositories/category_repository.dart`

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final SupabaseClient _client;

  CategoryRepository(this._client);

  /// Get all categories for user
  Future<List<CategoryModel>> getCategories(String userId) async {
    try {
      final response = await _client
          .from('categories')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  /// Get categories by type (expense, income, transfer)
  Future<List<CategoryModel>> getCategoriesByType(
    String userId,
    String categoryType,
  ) async {
    try {
      final response = await _client
          .from('categories')
          .select()
          .eq('user_id', userId)
          .eq('category_type', categoryType)
          .order('created_at', ascending: false);

      return (response as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting categories by type: $e');
      return [];
    }
  }

  /// Create new category
  Future<CategoryModel?> createCategory(
    String userId,
    String name,
    String categoryType, {
    String color = '#8B5CF6',
    String iconName = 'shopping',
    bool isDefault = false,
  }) async {
    try {
      final response = await _client
          .from('categories')
          .insert({
            'user_id': userId,
            'name': name,
            'category_type': categoryType,
            'color': color,
            'icon_name': iconName,
            'is_default': isDefault,
          })
          .select()
          .single();

      return CategoryModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error creating category: $e');
      rethrow;
    }
  }

  /// Update category
  Future<CategoryModel?> updateCategory(
    String categoryId, {
    String? name,
    String? color,
    String? iconName,
  }) async {
    try {
      final data = <String, dynamic>{
        if (name != null) 'name': name,
        if (color != null) 'color': color,
        if (iconName != null) 'icon_name': iconName,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _client
          .from('categories')
          .update(data)
          .eq('id', categoryId)
          .select()
          .single();

      return CategoryModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error updating category: $e');
      rethrow;
    }
  }

  /// Delete category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _client
          .from('categories')
          .delete()
          .eq('id', categoryId);
    } catch (e) {
      print('Error deleting category: $e');
      rethrow;
    }
  }

  /// Get single category
  Future<CategoryModel?> getCategory(String categoryId) async {
    try {
      final response = await _client
          .from('categories')
          .select()
          .eq('id', categoryId)
          .single();

      return CategoryModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error getting category: $e');
      return null;
    }
  }
}
```

---

## 4. Transaction Repository

**File:** `lib/data/repositories/transaction_repository.dart`

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final SupabaseClient _client;

  TransactionRepository(this._client);

  /// Get all transactions for user
  Future<List<TransactionModel>> getTransactions(String userId) async {
    try {
      final response = await _client
          .from('transactions')
          .select()
          .eq('user_id', userId)
          .order('transaction_date', ascending: false);

      return (response as List)
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting transactions: $e');
      return [];
    }
  }

  /// Get transactions for specific account
  Future<List<TransactionModel>> getAccountTransactions(
    String userId,
    String accountId,
  ) async {
    try {
      final response = await _client
          .from('transactions')
          .select()
          .eq('user_id', userId)
          .eq('account_id', accountId)
          .order('transaction_date', ascending: false);

      return (response as List)
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting account transactions: $e');
      return [];
    }
  }

  /// Get transactions by date range
  Future<List<TransactionModel>> getTransactionsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _client
          .from('transactions')
          .select()
          .eq('user_id', userId)
          .gte('transaction_date', startDate.toString().split(' ')[0])
          .lte('transaction_date', endDate.toString().split(' ')[0])
          .order('transaction_date', ascending: false);

      return (response as List)
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting transactions by date: $e');
      return [];
    }
  }

  /// Get transactions by type
  Future<List<TransactionModel>> getTransactionsByType(
    String userId,
    String transactionType,
  ) async {
    try {
      final response = await _client
          .from('transactions')
          .select()
          .eq('user_id', userId)
          .eq('transaction_type', transactionType)
          .order('transaction_date', ascending: false);

      return (response as List)
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting transactions by type: $e');
      return [];
    }
  }

  /// Create new transaction
  Future<TransactionModel?> createTransaction(
    String userId,
    String accountId,
    String categoryId,
    double amount,
    String transactionType, {
    String? description,
    String? notes,
    DateTime? transactionDate,
  }) async {
    try {
      final response = await _client
          .from('transactions')
          .insert({
            'user_id': userId,
            'account_id': accountId,
            'category_id': categoryId,
            'amount': amount,
            'transaction_type': transactionType,
            'description': description,
            'notes': notes,
            'transaction_date': (transactionDate ?? DateTime.now())
                .toString()
                .split(' ')[0],
          })
          .select()
          .single();

      return TransactionModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error creating transaction: $e');
      rethrow;
    }
  }

  /// Update transaction
  Future<TransactionModel?> updateTransaction(
    String transactionId, {
    double? amount,
    String? description,
    String? notes,
    DateTime? transactionDate,
  }) async {
    try {
      final data = <String, dynamic>{
        if (amount != null) 'amount': amount,
        if (description != null) 'description': description,
        if (notes != null) 'notes': notes,
        if (transactionDate != null)
          'transaction_date': transactionDate.toString().split(' ')[0],
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _client
          .from('transactions')
          .update(data)
          .eq('id', transactionId)
          .select()
          .single();

      return TransactionModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error updating transaction: $e');
      rethrow;
    }
  }

  /// Delete transaction
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _client
          .from('transactions')
          .delete()
          .eq('id', transactionId);
    } catch (e) {
      print('Error deleting transaction: $e');
      rethrow;
    }
  }

  /// Get total expense for date range
  Future<double> getTotalExpense(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final transactions = await getTransactionsByDateRange(
        userId,
        startDate,
        endDate,
      );
      return transactions
          .where((t) => t.transactionType == 'expense')
          .fold<double>(0, (sum, t) => sum + t.amount);
    } catch (e) {
      print('Error calculating total expense: $e');
      return 0;
    }
  }

  /// Get total income for date range
  Future<double> getTotalIncome(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final transactions = await getTransactionsByDateRange(
        userId,
        startDate,
        endDate,
      );
      return transactions
          .where((t) => t.transactionType == 'income')
          .fold<double>(0, (sum, t) => sum + t.amount);
    } catch (e) {
      print('Error calculating total income: $e');
      return 0;
    }
  }

  /// Get expenses by category for date range
  Future<Map<String, double>> getExpensesByCategory(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final transactions = await getTransactionsByDateRange(
        userId,
        startDate,
        endDate,
      );

      final Map<String, double> categoryExpenses = {};
      for (var transaction in transactions) {
        if (transaction.transactionType == 'expense') {
          categoryExpenses[transaction.categoryId] =
              (categoryExpenses[transaction.categoryId] ?? 0) + transaction.amount;
        }
      }

      return categoryExpenses;
    } catch (e) {
      print('Error getting expenses by category: $e');
      return {};
    }
  }
}
```

---

## 5. Budget Repository

**File:** `lib/data/repositories/budget_repository.dart`

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/budget_model.dart';

class BudgetRepository {
  final SupabaseClient _client;

  BudgetRepository(this._client);

  /// Get all budgets for user
  Future<List<BudgetModel>> getBudgets(String userId) async {
    try {
      final response = await _client
          .from('budgets')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((e) => BudgetModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting budgets: $e');
      return [];
    }
  }

  /// Get active budgets (ongoing)
  Future<List<BudgetModel>> getActiveBudgets(String userId) async {
    try {
      final response = await _client
          .from('budgets')
          .select()
          .eq('user_id', userId)
          .or('end_date.is.null,end_date.gte.${DateTime.now()}')
          .order('created_at', ascending: false);

      return (response as List)
          .map((e) => BudgetModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting active budgets: $e');
      return [];
    }
  }

  /// Create new budget
  Future<BudgetModel?> createBudget(
    String userId,
    String categoryId,
    double amount,
    String period, {
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
  }) async {
    try {
      final response = await _client
          .from('budgets')
          .insert({
            'user_id': userId,
            'category_id': categoryId,
            'amount': amount,
            'period': period,
            'start_date': (startDate ?? DateTime.now()).toString().split(' ')[0],
            'end_date': endDate?.toString().split(' ')[0],
            'notes': notes,
          })
          .select()
          .single();

      return BudgetModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error creating budget: $e');
      rethrow;
    }
  }

  /// Update budget
  Future<BudgetModel?> updateBudget(
    String budgetId, {
    double? amount,
    String? period,
    DateTime? endDate,
    String? notes,
  }) async {
    try {
      final data = <String, dynamic>{
        if (amount != null) 'amount': amount,
        if (period != null) 'period': period,
        if (endDate != null) 'end_date': endDate.toString().split(' ')[0],
        if (notes != null) 'notes': notes,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _client
          .from('budgets')
          .update(data)
          .eq('id', budgetId)
          .select()
          .single();

      return BudgetModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error updating budget: $e');
      rethrow;
    }
  }

  /// Delete budget
  Future<void> deleteBudget(String budgetId) async {
    try {
      await _client
          .from('budgets')
          .delete()
          .eq('id', budgetId);
    } catch (e) {
      print('Error deleting budget: $e');
      rethrow;
    }
  }

  /// Get budget for category
  Future<BudgetModel?> getBudgetForCategory(
    String userId,
    String categoryId,
  ) async {
    try {
      final response = await _client
          .from('budgets')
          .select()
          .eq('user_id', userId)
          .eq('category_id', categoryId)
          .or('end_date.is.null,end_date.gte.${DateTime.now()}')
          .maybeSingle();

      return response != null
          ? BudgetModel.fromJson(response as Map<String, dynamic>)
          : null;
    } catch (e) {
      print('Error getting budget for category: $e');
      return null;
    }
  }

  /// Check if budget exceeded
  Future<bool> isBudgetExceeded(
    String userId,
    String categoryId,
    double currentSpending,
  ) async {
    try {
      final budget = await getBudgetForCategory(userId, categoryId);
      return budget != null && currentSpending > budget.amount;
    } catch (e) {
      print('Error checking budget: $e');
      return false;
    }
  }
}
```

---

## 6. Integration dengan Existing Providers

Update provider files untuk menggunakan repository:

### auth_provider.dart
```dart
// Pastikan create user profile setelah register
Future<void> register(String email, String password) async {
  try {
    // ... existing code ...
    
    // Create user profile
    final userId = _authServices.getCurrentUserId();
    if (userId != null) {
      await _userRepository.createUserProfile(userId, email);
    }
  } catch (e) {
    // ... error handling ...
  }
}
```

### transaction_provider.dart
```dart
class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repository;
  final AccountRepository _accountRepository;

  List<TransactionModel> _transactions = [];
  
  TransactionProvider(this._repository, this._accountRepository);

  Future<void> getTransactions(String userId) async {
    _transactions = await _repository.getTransactions(userId);
    notifyListeners();
  }

  Future<void> addTransaction(
    String userId,
    String accountId,
    String categoryId,
    double amount,
    String type,
  ) async {
    await _repository.createTransaction(
      userId,
      accountId,
      categoryId,
      amount,
      type,
    );
    
    // Update account balance
    final account = await _accountRepository.getAccount(accountId);
    if (account != null) {
      double newBalance = type == 'expense' 
          ? account.balance - amount 
          : account.balance + amount;
      
      await _accountRepository.updateBalance(accountId, newBalance);
    }
    
    await getTransactions(userId);
  }
}
```

---

## 7. Integration Setup di main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://omnftoowpnvmtbzfrcig.supabase.co',
    anonKey: 'sb_publishable_5h8Vo9sptNAY3gIyzwaOwQ_wwRbFHdq',
  );

  final supabaseClient = Supabase.instance.client;

  // Initialize repositories
  final userRepository = UserRepository(supabaseClient);
  final accountRepository = AccountRepository(supabaseClient);
  final categoryRepository = CategoryRepository(supabaseClient);
  final transactionRepository = TransactionRepository(supabaseClient);
  final budgetRepository = BudgetRepository(supabaseClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ProxyProvider<AuthProvider, AccountProvider>(
          create: (_) => AccountProvider(accountRepository),
          update: (_, auth, previous) => previous!,
        ),
        ProxyProvider<AuthProvider, CategoryProvider>(
          create: (_) => CategoryProvider(categoryRepository),
          update: (_, auth, previous) => previous!,
        ),
        ProxyProvider<AuthProvider, TransactionProvider>(
          create: (_) => TransactionProvider(transactionRepository, accountRepository),
          update: (_, auth, previous) => previous!,
        ),
        ProxyProvider<AuthProvider, BudgetProvider>(
          create: (_) => BudgetProvider(budgetRepository),
          update: (_, auth, previous) => previous!,
        ),
      ],
      child: const MyApp(),
    ),
  );
}
```

---

## Error Handling Best Practices

```dart
Future<void> performOperation() async {
  try {
    // Operation code
  } on PostgrestException catch (e) {
    // Database error
    print('DB Error: ${e.message}');
    // Show user-friendly error
  } on SocketException {
    // Network error
    print('Network error');
    // Try offline using Hive cache
  } catch (e) {
    // Other error
    print('Unexpected error: $e');
  }
}
```

---

## Testing Repository

```dart
void main() {
  group('AccountRepository', () {
    late AccountRepository repository;
    late SupabaseClient mockClient;

    setUp(() {
      mockClient = MockSupabaseClient();
      repository = AccountRepository(mockClient);
    });

    test('getAccounts returns list of accounts', () async {
      // Arrange
      final expectedAccounts = [
        AccountModel(
          id: '1',
          userId: 'user1',
          name: 'BRI',
          accountType: 'bank',
          balance: 5000000,
          currency: 'IDR',
          isDefault: true,
          color: '#6366F1',
          iconName: 'bank',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      // Act
      final result = await repository.getAccounts('user1');

      // Assert
      expect(result, expectedAccounts);
    });
  });
}
```

---

## Checklist Integration

- [ ] Create user_repository.dart
- [ ] Update account_repository.dart
- [ ] Update category_repository.dart
- [ ] Update transaction_repository.dart
- [ ] Update budget_repository.dart
- [ ] Update main.dart dengan repository initialization
- [ ] Update auth_provider.dart
- [ ] Update account_provider.dart
- [ ] Update category_provider.dart
- [ ] Update transaction_provider.dart
- [ ] Update budget_provider.dart
- [ ] Test CRUD operations
- [ ] Test error handling
- [ ] Add logging

---

## ✅ Repository Integration Complete!

Sekarang aplikasi fully integrated dengan Supabase backend. Semua data akan langsung sync ke cloud! 🚀

