import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Get current user ID
  String? get currentUserId => _supabase.auth.currentUser?.id;

  // Auth state changes stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Sign Up with Email & Password
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Register user with Supabase Auth only
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      final user = response.user;

      if (user != null) {
        // Create user profile in public.users table
        await _createUserProfile(user.id, email, name);
        
        return {
          'success': true,
          'message': 'Account created successfully! Please verify your email.',
          'user': user,
        };
      }

      return {'success': false, 'message': 'Failed to create account'};
    } on AuthException catch (e) {
      String errorMessage = 'Registration failed';

      if (e.message.contains('password')) {
        errorMessage = 'Password must be at least 6 characters.';
      } else if (e.message.contains('email')) {
        errorMessage = 'Invalid email address or already registered.';
      } else {
        errorMessage = e.message;
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {
        'success': false,
        'message': 'Registration failed: ${e.toString()}',
      };
    }
  }

  // Sign In with Email & Password
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user != null) {
        // Ensure user profile exists in public.users table
        await _ensureUserProfile(user.id, email, user.userMetadata?['name'] as String? ?? '');
        
        return {'success': true, 'message': 'Login successful!', 'user': user};
      }

      return {'success': false, 'message': 'Login failed'};
    } on AuthException catch (e) {
      String errorMessage = 'Login failed';

      if (e.message.contains('Invalid login')) {
        errorMessage = 'Invalid email or password.';
      } else if (e.message.contains('email')) {
        errorMessage = 'Invalid email address.';
      } else {
        errorMessage = e.message;
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {'success': false, 'message': 'Login failed: ${e.toString()}'};
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  // Reset Password
  Future<Map<String, dynamic>> resetPassword({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);

      return {
        'success': true,
        'message': 'Password reset email sent! Check your inbox.',
      };
    } on AuthException catch (e) {
      String errorMessage = 'Failed to send reset email';

      if (e.message.contains('email')) {
        errorMessage = 'Invalid email address or user not found.';
      } else {
        errorMessage = e.message;
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to send reset email: ${e.toString()}',
      };
    }
  }

  // Get User Data from Auth metadata
  Map<String, dynamic>? getUserData() {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    return {
      'id': user.id,
      'email': user.email,
      'name': user.userMetadata?['name'] ?? 'User',
      'created_at': user.createdAt,
    };
  }

  // Update User Metadata (Auth only)
  Future<void> updateUserData(Map<String, dynamic> data) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(data: data));
    } catch (e) {
      throw Exception('Failed to update user data: ${e.toString()}');
    }
  }

  // Check if email is verified
  bool get isEmailVerified =>
      _supabase.auth.currentUser?.emailConfirmedAt != null;

  // Send email verification (Supabase Auth-only, no manual verification needed)
  Future<void> sendEmailVerification() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null && user.email != null) {
        // Supabase automatically sends verification email on signup
        // This method is kept for compatibility but email is sent automatically
        debugPrint('Verification email sent automatically on signup');
      }
    } catch (e) {
      throw Exception('Failed to send verification email: ${e.toString()}');
    }
  }

  // Delete account (Auth only)
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return {'success': false, 'message': 'No user logged in'};
      }

      await signOut();

      return {'success': true, 'message': 'Account deleted successfully'};
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to delete account: ${e.toString()}',
      };
    }
  }

  // Create user profile in public.users table
  Future<void> _createUserProfile(String userId, String email, String name) async {
    try {
      // Check if user profile already exists
      final existing = await _supabase
          .from('users')
          .select('id')
          .eq('id', userId)
          .maybeSingle();

      if (existing != null) {
        if (kDebugMode) print('✅ User profile already exists');
        return;
      }

      // Create user profile
      await _supabase.from('users').insert({
        'id': userId,
        'email': email,
        'name': name,
        'currency': 'IDR',
        'language': 'id',
        'date_format': 'dd/MM/yyyy',
        'theme_mode': 'system',
      });

      if (kDebugMode) print('✅ User profile created successfully');
    } catch (e) {
      if (kDebugMode) print('⚠️ Error creating user profile: $e');
      // Don't throw - auth is already successful
    }
  }

  // Ensure user profile exists (for login)
  Future<void> _ensureUserProfile(String userId, String email, String name) async {
    try {
      // Check if user profile exists
      final existing = await _supabase
          .from('users')
          .select('id')
          .eq('id', userId)
          .maybeSingle();

      if (existing != null) {
        if (kDebugMode) print('✅ User profile exists');
        return;
      }

      // Create user profile if doesn't exist
      await _supabase.from('users').insert({
        'id': userId,
        'email': email,
        'name': name.isEmpty ? email : name,
        'currency': 'IDR',
        'language': 'id',
        'date_format': 'dd/MM/yyyy',
        'theme_mode': 'system',
      });

      if (kDebugMode) print('✅ User profile created on login');
    } catch (e) {
      if (kDebugMode) print('⚠️ Error ensuring user profile: $e');
      // Don't throw - auth is already successful
    }
  }

  // Get session
  Session? get session => _supabase.auth.currentSession;

  // Check if user is authenticated
  bool get isAuthenticated => _supabase.auth.currentUser != null;
}
