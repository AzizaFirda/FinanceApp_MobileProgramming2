import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRepository {
  static final SupabaseRepository _instance = SupabaseRepository._internal();

  late final SupabaseClient _supabase;

  factory SupabaseRepository() {
    return _instance;
  }

  SupabaseRepository._internal();

  // Initialize Supabase
  Future<void> init() async {
    if (kDebugMode) print('🔵 SupabaseRepository: Initializing...');
    await Supabase.initialize(
      url: 'https://omnftoowpnvmtbzfrcig.supabase.co',
      anonKey: 'sb_publishable_5h8Vo9sptNAY3gIyzwaOwQ_wwRbFHdq',
    );
    _supabase = Supabase.instance.client;
    if (kDebugMode) print('🟢 SupabaseRepository: Initialized successfully');
  }

  // Get Supabase client
  SupabaseClient get client => _supabase;

  // Get current user ID
  String? get currentUserId => _supabase.auth.currentUser?.id;

  // Check if user authenticated
  bool get isAuthenticated => _supabase.auth.currentUser != null;

  // Logout
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
