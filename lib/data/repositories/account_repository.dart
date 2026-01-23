import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../models/account_model.dart';
import 'supabase_repository.dart';

class AccountRepository {
  static const String _boxName = 'accounts';
  final _supabaseRepo = SupabaseRepository();

  Box<AccountModel> get _box => Hive.box<AccountModel>(_boxName);

  // Initialize default accounts
  Future<void> initializeDefaultAccounts() async {
    // Get all active asset accounts (exclude liabilities)
    final allAccounts = _box.values.toList();
    final assetAccounts = allAccounts.where((a) => a.isActive && a.isAsset).toList();
    
    if (kDebugMode) {
      print('📦 Total accounts in box: ${allAccounts.length}');
      print('📦 Active asset accounts: ${assetAccounts.length}');
      for (var acc in allAccounts) {
        print('   - ${acc.name} (type: ${acc.type}, active: ${acc.isActive}, isAsset: ${acc.isAsset})');
      }
    }

    // Check by TYPE only - more reliable
    final hasCash = assetAccounts.any((a) => a.type == AccountType.cash);
    final hasBank = assetAccounts.any((a) => a.type == AccountType.bank);
    final hasEwallet = assetAccounts.any((a) => a.type == AccountType.ewallet);
    
    if (kDebugMode) {
      print('🔍 Has default accounts - Cash: $hasCash, Bank: $hasBank, E-Wallet: $hasEwallet');
    }

    // Create missing default accounts
    if (!hasCash) {
      final cashAccount = AccountModel.create(
        name: 'Cash',
        type: AccountType.cash,
        icon: '💵',
        color: Colors.green.value,
        initialBalance: 0,
      );
      await _box.put(cashAccount.id, cashAccount);
      await _syncAccountToSupabase(cashAccount);
      if (kDebugMode) print('✅ Created default account: Cash');
    }

    if (!hasBank) {
      final bankAccount = AccountModel.create(
        name: 'M-Banking',
        type: AccountType.bank,
        icon: '🏦',
        color: Colors.blue.value,
        initialBalance: 0,
      );
      await _box.put(bankAccount.id, bankAccount);
      await _syncAccountToSupabase(bankAccount);
      if (kDebugMode) print('✅ Created default account: M-Banking');
    }

    if (!hasEwallet) {
      final ewalletAccount = AccountModel.create(
        name: 'E-Wallet',
        type: AccountType.ewallet,
        icon: '📱',
        color: Colors.purple.value,
        initialBalance: 0,
      );
      await _box.put(ewalletAccount.id, ewalletAccount);
      await _syncAccountToSupabase(ewalletAccount);
      if (kDebugMode) print('✅ Created default account: E-Wallet');
    }
    
    // Final verification
    final finalAccounts = _box.values.where((a) => a.isActive && a.isAsset).toList();
    if (kDebugMode) {
      print('📦 After init - ${finalAccounts.length} active asset accounts:');
      for (var acc in finalAccounts) {
        print('   ✓ ${acc.name} (${acc.type})');
      }
    }
  }

  // Create locally
  Future<void> addAccount(AccountModel account) async {
    await _box.put(account.id, account);
    // Sync to Supabase
    await _syncAccountToSupabase(account);
  }

  // Create and sync to Supabase
  Future<bool> createAccountSupabase(AccountModel account) async {
    try {
      if (kDebugMode) print('🏦 Creating account: ${account.name}');
      if (!_supabaseRepo.isAuthenticated) {
        if (kDebugMode) print('❌ Error: User not authenticated');
        return false;
      }

      // Convert color to hex string to avoid integer overflow in PostgreSQL
      final colorHex = '#${account.color.toRadixString(16).padLeft(8, '0')}';

      // Insert to Supabase
      await _supabaseRepo.client.from('accounts').insert({
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

      // Save locally
      await _box.put(account.id, account);
      if (kDebugMode) print('🟢 Account synced to Supabase: ${account.name}');
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ Error creating account in Supabase: $e');
      // Still save locally even if Supabase fails
      await _box.put(account.id, account);
      return false;
    }
  }

  // Sync account to Supabase
  Future<void> _syncAccountToSupabase(AccountModel account) async {
    try {
      if (!_supabaseRepo.isAuthenticated) return;

      // Convert color to hex string to avoid integer overflow in PostgreSQL
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
      if (kDebugMode) print('✅ Account synced to Supabase: ${account.name}');
    } catch (e) {
      print('Error syncing account to Supabase: $e');
    }
  }

  // Sync from Supabase - fetch all accounts from cloud
  Future<void> syncFromSupabase() async {
    try {
      if (!_supabaseRepo.isAuthenticated) {
        if (kDebugMode) print('❌ Cannot sync accounts: User not authenticated');
        return;
      }

      if (kDebugMode) print('🔄 Syncing accounts from Supabase...');

      final response = await _supabaseRepo.client
          .from('accounts')
          .select()
          .eq('user_id', _supabaseRepo.currentUserId!);

      if (kDebugMode) print('📥 Received ${response.length} accounts from Supabase');

      for (var data in response) {
        final createdAt = DateTime.parse(data['created_at']);
        
        // Parse color - can be hex string or integer
        int colorValue = Colors.blue.value;
        if (data['color'] != null) {
          if (data['color'] is String) {
            // Parse hex string like "#FF4CAF50"
            String hexStr = data['color'].toString().replaceAll('#', '');
            colorValue = int.tryParse(hexStr, radix: 16) ?? Colors.blue.value;
          } else if (data['color'] is int) {
            colorValue = data['color'];
          }
        }
        
        final account = AccountModel(
          id: data['id'],
          name: data['name'],
          type: _stringToAccountType(data['type']),
          icon: data['icon'] ?? '💰',
          color: colorValue,
          initialBalance: (data['initial_balance'] as num?)?.toDouble() ?? 0.0,
          currentBalance: (data['current_balance'] as num?)?.toDouble() ?? 0.0,
          isActive: data['is_active'] ?? true,
          createdAt: createdAt,
          updatedAt: data['updated_at'] != null 
              ? DateTime.parse(data['updated_at']) 
              : createdAt,
        );

        // Always update from Supabase to get latest balance
        final existingAccount = _box.get(account.id);
        if (existingAccount != null) {
          // Update existing account with cloud data (which has the correct balance)
          existingAccount.currentBalance = account.currentBalance;
          existingAccount.initialBalance = account.initialBalance;
          existingAccount.name = account.name;
          existingAccount.icon = account.icon;
          existingAccount.color = account.color;
          existingAccount.isActive = account.isActive;
          existingAccount.updatedAt = account.updatedAt;
          await existingAccount.save();
          if (kDebugMode) print('✅ Updated account from cloud: ${account.name} (balance: ${account.currentBalance})');
        } else {
          // Add new account from cloud
          await _box.put(account.id, account);
          if (kDebugMode) print('✅ Added account from cloud: ${account.name} (balance: ${account.currentBalance})');
        }
      }

      if (kDebugMode) print('🟢 Sync accounts from Supabase completed');
    } catch (e) {
      if (kDebugMode) print('❌ Error syncing accounts from Supabase: $e');
    }
  }

  // Helper: Convert string to AccountType enum
  AccountType _stringToAccountType(String type) {
    switch (type) {
      case 'cash':
        return AccountType.cash;
      case 'bank':
        return AccountType.bank;
      case 'e_wallet':
      case 'ewallet':
        return AccountType.ewallet;
      case 'liability':
        return AccountType.liability;
      default:
        return AccountType.cash;
    }
  }

  // Read
  List<AccountModel> getAllAccounts() {
    return _box.values.where((a) => a.isActive).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  List<AccountModel> getAssets() {
    return _box.values.where((a) => a.isActive && a.isAsset).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  List<AccountModel> getLiabilities() {
    return _box.values.where((a) => a.isActive && a.isLiability).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  AccountModel? getAccountById(String id) {
    return _box.get(id);
  }

  List<AccountModel> getAccountsByType(AccountType type) {
    return _box.values.where((a) => a.isActive && a.type == type).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  // Update
  Future<void> updateAccount(AccountModel account) async {
    account.updatedAt = DateTime.now();
    await account.save();
    await _syncAccountToSupabase(account);
  }

  // Delete (soft delete)
  Future<void> deleteAccount(String id) async {
    final account = _box.get(id);
    if (account != null) {
      account.isActive = false;
      account.updatedAt = DateTime.now();
      await account.save();
      await _syncAccountToSupabase(account);
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

  // Statistics
  double getTotalAssets() {
    return _box.values
        .where((a) => a.isActive && a.isAsset)
        .fold(0.0, (sum, a) => sum + a.currentBalance);
  }

  double getTotalLiabilities() {
    return _box.values
        .where((a) => a.isActive && a.isLiability)
        .fold(0.0, (sum, a) => sum + a.currentBalance.abs());
  }

  double getNetWorth() {
    return getTotalAssets() - getTotalLiabilities();
  }

  // Clear all
  Future<void> clearAll() async {
    await _box.clear();
  }
}
