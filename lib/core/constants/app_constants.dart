class AppConstants {
  // App Info
  static const String appName = 'Money Manager';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Personal Finance Tracker';

  // API & Network (for future use)
  static const String baseUrl = '';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Hive Box Names
  static const String transactionsBox = 'transactions';
  static const String accountsBox = 'accounts';
  static const String categoriesBox = 'categories';
  static const String budgetsBox = 'budgets';
  static const String userProfileBox = 'userProfile';
  static const String settingsBox = 'settings';

  // Supported Currencies
  static const List<String> supportedCurrencies = [
    'IDR',
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'SGD',
    'MYR',
  ];

  // Supported Languages
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'id', 'name': 'Bahasa Indonesia'},
  ];

  // Date Formats
  static const List<String> dateFormats = [
    'dd/MM/yyyy',
    'MM/dd/yyyy',
    'yyyy-MM-dd',
  ];

  // Theme Modes
  static const List<String> themeModes = ['light', 'dark', 'system'];

  // Transaction Types
  static const String transactionTypeExpense = 'expense';
  static const String transactionTypeIncome = 'income';
  static const String transactionTypeTransfer = 'transfer';

  // Account Types
  static const String accountTypeCash = 'cash';
  static const String accountTypeBank = 'bank';
  static const String accountTypeEwallet = 'ewallet';
  static const String accountTypeLiability = 'liability';

  // Category Icons
  static const List<String> categoryIcons = [
    '🍔',
    '🚗',
    '🏠',
    '👕',
    '💊',
    '🎓',
    '🎮',
    '💇',
    '🎁',
    '📱',
    '🔧',
    '✈️',
    '🎬',
    '📚',
    '💰',
    '🎵',
    '⚽',
    '🏋️',
    '🎨',
    '🍕',
    '☕',
    '🛒',
    '💻',
    '📷',
  ];

  // Pagination
  static const int itemsPerPage = 20;
  static const int recentTransactionsLimit = 10;

  // Budget
  static const String budgetPeriodMonthly = 'monthly';
  static const String budgetPeriodWeekly = 'weekly';
  static const String budgetPeriodYearly = 'yearly';

  // Budget Warning Thresholds
  static const double budgetWarningThreshold = 0.8; // 80%
  static const double budgetDangerThreshold = 0.95; // 95%

  // Chart Settings
  static const int maxChartItems = 10;
  static const double chartAnimationDuration = 1.5; // seconds

  // Input Validation
  static const int minAmountLength = 1;
  static const int maxAmountLength = 15;
  static const int maxNoteLength = 200;
  static const int maxCategoryNameLength = 50;
  static const int maxAccountNameLength = 50;
  static const int maxUserNameLength = 50;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double defaultRadius = 12.0;
  static const double cardRadius = 16.0;
  static const double buttonHeight = 56.0;
  static const double iconSize = 24.0;
  static const double avatarSize = 48.0;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Snackbar Durations
  static const Duration snackbarShortDuration = Duration(seconds: 2);
  static const Duration snackbarMediumDuration = Duration(seconds: 3);
  static const Duration snackbarLongDuration = Duration(seconds: 5);

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'No internet connection.';
  static const String errorTimeout = 'Request timeout. Please try again.';
  static const String errorInvalidInput =
      'Invalid input. Please check your data.';
  static const String errorEmptyField = 'This field cannot be empty.';
  static const String errorInvalidAmount = 'Please enter a valid amount.';
  static const String errorInvalidDate = 'Please select a valid date.';

  // Success Messages
  static const String successTransactionAdded =
      'Transaction added successfully';
  static const String successTransactionUpdated =
      'Transaction updated successfully';
  static const String successTransactionDeleted =
      'Transaction deleted successfully';
  static const String successAccountAdded = 'Account added successfully';
  static const String successAccountUpdated = 'Account updated successfully';
  static const String successCategoryAdded = 'Category added successfully';
  static const String successBudgetSet = 'Budget set successfully';
  static const String successProfileUpdated = 'Profile updated successfully';
  static const String successSettingsSaved = 'Settings saved successfully';

  // Confirmation Messages
  static const String confirmDeleteTransaction =
      'Are you sure you want to delete this transaction?';
  static const String confirmDeleteAccount =
      'Are you sure you want to delete this account?';
  static const String confirmDeleteCategory =
      'Are you sure you want to delete this category?';
  static const String confirmDeleteBudget =
      'Are you sure you want to delete this budget?';
  static const String confirmResetData =
      'Are you sure you want to reset all data? This action cannot be undone.';

  // Empty State Messages
  static const String emptyTransactions = 'No transactions yet';
  static const String emptyAccounts = 'No accounts yet';
  static const String emptyCategories = 'No categories yet';
  static const String emptyBudgets = 'No budgets set';
  static const String emptySearch = 'No results found';

  // Regex Patterns
  static final RegExp emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp phonePattern = RegExp(r'^\+?[0-9]{10,13}$');
  static final RegExp numberPattern = RegExp(r'^[0-9]+$');

  // Feature Flags (for future development)
  static const bool enableBackup = false;
  static const bool enableSync = false;
  static const bool enableNotifications = false;
  static const bool enableBiometric = false;
  static const bool enableExport = false;
}
