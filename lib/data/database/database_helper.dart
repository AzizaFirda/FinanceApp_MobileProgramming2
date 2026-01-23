import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction_model.dart';
import '../models/account_model.dart';
import '../models/category_model.dart';
import '../models/budget_model.dart';
import '../models/user_profile_model.dart';
import '../repositories/account_repository.dart';
import '../repositories/setting_repository.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();
    await _registerAdapters();
    await _openBoxes();
    await _initializeDefaultData();

    _initialized = true;
  }

  Future<void> _registerAdapters() async {
    // Register all Hive type adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TransactionTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TransactionModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(AccountTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(AccountModelAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(CategoryModelAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(UserProfileModelAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(BudgetModelAdapter());
    }
  }

  Future<void> _openBoxes() async {
    // Open all boxes
    if (!Hive.isBoxOpen('transactions')) {
      await Hive.openBox<TransactionModel>('transactions');
    }
    if (!Hive.isBoxOpen('accounts')) {
      await Hive.openBox<AccountModel>('accounts');
    }
    if (!Hive.isBoxOpen('categories')) {
      await Hive.openBox<CategoryModel>('categories');
    }
    if (!Hive.isBoxOpen('budgets')) {
      await Hive.openBox<BudgetModel>('budgets');
    }
    if (!Hive.isBoxOpen('userProfile')) {
      await Hive.openBox<UserProfileModel>('userProfile');
    }
    if (!Hive.isBoxOpen('settings')) {
      await Hive.openBox('settings');
    }
  }

  Future<void> _initializeDefaultData() async {
    // Initialize default accounts
    final accountRepo = AccountRepository();
    await accountRepo.initializeDefaultAccounts();

    // Categories are not initialized by default - user adds their own

    // Initialize default user profile
    final settingsRepo = SettingsRepository();
    await settingsRepo.initializeDefaultProfile();
  }

  // Get boxes
  Box<TransactionModel> get transactionsBox =>
      Hive.box<TransactionModel>('transactions');
  Box<AccountModel> get accountsBox => Hive.box<AccountModel>('accounts');
  Box<CategoryModel> get categoriesBox => Hive.box<CategoryModel>('categories');
  Box<BudgetModel> get budgetsBox => Hive.box<BudgetModel>('budgets');
  Box<UserProfileModel> get userProfileBox =>
      Hive.box<UserProfileModel>('userProfile');
  Box get settingsBox => Hive.box('settings');

  // Clear all data
  Future<void> clearAllData() async {
    await transactionsBox.clear();
    await accountsBox.clear();
    await categoriesBox.clear();
    await budgetsBox.clear();
    await userProfileBox.clear();
    await settingsBox.clear();

    // Reinitialize default data
    await _initializeDefaultData();
  }

  // Close all boxes
  Future<void> close() async {
    await transactionsBox.close();
    await accountsBox.close();
    await categoriesBox.close();
    await budgetsBox.close();
    await userProfileBox.close();
    await settingsBox.close();
    _initialized = false;
  }

  // Delete all boxes (for complete reset)
  Future<void> deleteAllBoxes() async {
    await Hive.deleteBoxFromDisk('transactions');
    await Hive.deleteBoxFromDisk('accounts');
    await Hive.deleteBoxFromDisk('categories');
    await Hive.deleteBoxFromDisk('budgets');
    await Hive.deleteBoxFromDisk('userProfile');
    await Hive.deleteBoxFromDisk('settings');
    _initialized = false;
  }

  // Backup data (returns JSON)
  Map<String, dynamic> backupData() {
    return {
      'transactions': transactionsBox.values.map((t) => t.toJson()).toList(),
      'accounts': accountsBox.values.map((a) => a.toJson()).toList(),
      'categories': categoriesBox.values.map((c) => c.toJson()).toList(),
      'budgets': budgetsBox.values.map((b) => b.toJson()).toList(),
      'userProfile': userProfileBox.isNotEmpty
          ? userProfileBox.values.first.toJson()
          : null,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  // Restore data (from JSON)
  Future<void> restoreData(Map<String, dynamic> data) async {
    try {
      // Clear existing data
      await clearAllData();

      // Restore transactions
      if (data['transactions'] != null) {
        for (var json in data['transactions']) {
          final transaction = TransactionModel.fromJson(json);
          await transactionsBox.put(transaction.id, transaction);
        }
      }

      // Restore accounts
      if (data['accounts'] != null) {
        for (var json in data['accounts']) {
          final account = AccountModel.fromJson(json);
          await accountsBox.put(account.id, account);
        }
      }

      // Restore categories
      if (data['categories'] != null) {
        for (var json in data['categories']) {
          final category = CategoryModel.fromJson(json);
          await categoriesBox.put(category.id, category);
        }
      }

      // Restore budgets
      if (data['budgets'] != null) {
        for (var json in data['budgets']) {
          final budget = BudgetModel.fromJson(json);
          await budgetsBox.put(budget.id, budget);
        }
      }

      // Restore user profile
      if (data['userProfile'] != null) {
        final profile = UserProfileModel.fromJson(data['userProfile']);
        await userProfileBox.put('profile', profile);
      }
    } catch (e) {
      throw Exception('Failed to restore data: $e');
    }
  }

  // Get database statistics
  Map<String, int> getStatistics() {
    return {
      'transactions': transactionsBox.length,
      'accounts': accountsBox.length,
      'categories': categoriesBox.length,
      'budgets': budgetsBox.length,
    };
  }

  // Check if database is empty
  bool get isEmpty {
    return transactionsBox.isEmpty &&
        accountsBox.isEmpty &&
        categoriesBox.isEmpty &&
        budgetsBox.isEmpty &&
        userProfileBox.isEmpty;
  }

  // Get database size (approximate in KB)
  Future<double> getDatabaseSize() async {
    // This is an approximation
    int totalItems =
        transactionsBox.length +
        accountsBox.length +
        categoriesBox.length +
        budgetsBox.length +
        userProfileBox.length;

    // Rough estimate: 1KB per item average
    return totalItems.toDouble();
  }
}
