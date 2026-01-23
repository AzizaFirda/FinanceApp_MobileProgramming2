import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction_model.dart';
import '../models/account_model.dart';
import '../models/category_model.dart';
import '../models/budget_model.dart';
import '../models/user_profile_model.dart';

class HiveBoxes {
  static const String transactions = 'transactions';
  static const String accounts = 'accounts';
  static const String categories = 'categories';
  static const String budgets = 'budgets';
  static const String userProfile = 'userProfile';
  static const String settings = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(TransactionTypeAdapter());
    Hive.registerAdapter(TransactionModelAdapter());
    Hive.registerAdapter(AccountTypeAdapter());
    Hive.registerAdapter(AccountModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(BudgetModelAdapter());
    Hive.registerAdapter(UserProfileModelAdapter());
  }

  static Future<void> openBoxes() async {
    await Hive.openBox<TransactionModel>(transactions);
    await Hive.openBox<AccountModel>(accounts);
    await Hive.openBox<CategoryModel>(categories);
    await Hive.openBox<BudgetModel>(budgets);
    await Hive.openBox<UserProfileModel>(userProfile);
    await Hive.openBox(settings);
  }

  static Box<TransactionModel> getTransactions() =>
      Hive.box<TransactionModel>(transactions);

  static Box<AccountModel> getAccounts() => Hive.box<AccountModel>(accounts);

  static Box<CategoryModel> getCategories() =>
      Hive.box<CategoryModel>(categories);

  static Box<BudgetModel> getBudgets() => Hive.box<BudgetModel>(budgets);

  static Box<UserProfileModel> getUserProfile() =>
      Hive.box<UserProfileModel>(userProfile);

  static Box getSettings() => Hive.box(settings);

  static Future<void> closeBoxes() async {
    await Hive.box<TransactionModel>(transactions).close();
    await Hive.box<AccountModel>(accounts).close();
    await Hive.box<CategoryModel>(categories).close();
    await Hive.box<BudgetModel>(budgets).close();
    await Hive.box<UserProfileModel>(userProfile).close();
    await Hive.box(settings).close();
  }

  static Future<void> deleteBoxes() async {
    await Hive.deleteBoxFromDisk(transactions);
    await Hive.deleteBoxFromDisk(accounts);
    await Hive.deleteBoxFromDisk(categories);
    await Hive.deleteBoxFromDisk(budgets);
    await Hive.deleteBoxFromDisk(userProfile);
    await Hive.deleteBoxFromDisk(settings);
  }
}
