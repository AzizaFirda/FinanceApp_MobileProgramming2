import 'package:flutter/foundation.dart';
import '../data/models/account_model.dart';
import '../data/repositories/account_repository.dart';

class AccountProvider extends ChangeNotifier {
  final AccountRepository _repository = AccountRepository();

  List<AccountModel> _accounts = [];
  bool _isLoading = false;
  String? _error;

  List<AccountModel> get accounts => _accounts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AccountProvider() {
    loadAccounts();
  }

  // Load all accounts
  Future<void> loadAccounts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // First sync from Supabase to get any cloud data
      await _repository.syncFromSupabase();
      
      // Then ensure default accounts exist (creates if needed)
      await _repository.initializeDefaultAccounts();
      
      // Load all accounts
      _accounts = _repository.getAllAccounts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add account
  Future<bool> addAccount(AccountModel account) async {
    try {
      // Try to sync to Supabase first
      await _repository.createAccountSupabase(account);
      await loadAccounts();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update account
  Future<bool> updateAccount(AccountModel account) async {
    try {
      await _repository.updateAccount(account);
      await loadAccounts();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete account
  Future<bool> deleteAccount(String id) async {
    try {
      await _repository.deleteAccount(id);
      await loadAccounts();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Get accounts by type
  List<AccountModel> getAssets() {
    return _repository.getAssets();
  }

  List<AccountModel> getLiabilities() {
    return _repository.getLiabilities();
  }

  List<AccountModel> getAccountsByType(AccountType type) {
    return _repository.getAccountsByType(type);
  }

  // Get account by id
  AccountModel? getAccountById(String id) {
    return _repository.getAccountById(id);
  }

  // Statistics
  double getTotalAssets() {
    return _repository.getTotalAssets();
  }

  double getTotalLiabilities() {
    return _repository.getTotalLiabilities();
  }

  double getNetWorth() {
    return _repository.getNetWorth();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
