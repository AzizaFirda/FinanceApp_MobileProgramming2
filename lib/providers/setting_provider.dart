import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import '../data/models/user_profile_model.dart';

class SettingsProvider extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  final SupabaseClient _supabase = Supabase.instance.client;

  late UserProfileModel _userProfile;
  bool _isLoading = false;
  String? _uploadError;

  UserProfileModel get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get uploadError => _uploadError;

  SettingsProvider() {
    // Initialize with values from Auth metadata
    _loadProfile();
  }

  void _loadProfile() {
    final user = _supabase.auth.currentUser;

    if (user != null) {
      _userProfile = UserProfileModel.create(
        name: user.userMetadata?['name'] ?? user.email ?? 'User',
        email: user.email ?? 'user@example.com',
        currency: 'IDR',
        language: 'id',
        dateFormat: 'dd/MM/yyyy',
        themeMode: 'system',
      );
    } else {
      _userProfile = UserProfileModel.create(
        name: 'User',
        email: 'user@example.com',
        currency: 'IDR',
        language: 'id',
        dateFormat: 'dd/MM/yyyy',
        themeMode: 'system',
      );
    }

    notifyListeners();
  }

  // Update profile name in Auth metadata
  Future<void> updateName(String name) async {
    if (name.trim().isEmpty) return;

    try {
      await _supabase.auth.updateUser(
        UserAttributes(data: {'name': name.trim()}),
      );

      final updatedProfile = _userProfile.copyWith(
        name: name.trim(),
        updatedAt: DateTime.now(),
      );

      _userProfile = updatedProfile;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating name: $e');
      rethrow;
    }
  }

  // Update profile email via Auth
  Future<void> updateEmail(String? email) async {
    if (email == null || email.trim().isEmpty) return;

    try {
      await _supabase.auth.updateUser(UserAttributes(email: email.trim()));

      final updatedProfile = _userProfile.copyWith(
        email: email.trim(),
        updatedAt: DateTime.now(),
      );

      _userProfile = updatedProfile;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating email: $e');
      rethrow;
    }
  }

  // Update profile photo
  Future<void> updateProfilePhoto({required bool fromCamera}) async {
    try {
      _uploadError = null;
      final XFile? image = await _imagePicker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        _isLoading = true;
        notifyListeners();

        // Upload to Supabase Storage
        final fileName =
            'profile_photos/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final bytes = await File(image.path).readAsBytes();

        await _supabase.storage
            .from('profiles')
            .uploadBinary(
              fileName,
              bytes,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: false,
              ),
            );

        // Get public URL from Supabase Storage
        final downloadUrl = _supabase.storage
            .from('profiles')
            .getPublicUrl(fileName);

        // Update profile with both local path and cloud URL
        final updatedProfile = _userProfile.copyWith(
          photoPath: image.path,
          photoUrl: downloadUrl,
          updatedAt: DateTime.now(),
        );

        _userProfile = updatedProfile;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _uploadError = 'Failed to upload photo: $e';
      _isLoading = false;
      debugPrint('Error updating profile photo: $e');
      notifyListeners();
    }
  }

  // Remove profile photo
  Future<void> removeProfilePhoto() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Delete from Supabase Storage if photoUrl exists
      if (_userProfile.photoUrl != null) {
        try {
          // Extract file path from URL
          final uri = Uri.parse(_userProfile.photoUrl!);
          final filePath = uri.pathSegments.skip(2).join('/');

          await _supabase.storage.from('profiles').remove([filePath]);
        } catch (e) {
          debugPrint('Error deleting photo from storage: $e');
        }
      }

      final updatedProfile = _userProfile.copyWith(
        photoPath: null,
        photoUrl: null,
        updatedAt: DateTime.now(),
      );

      _userProfile = updatedProfile;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Error removing profile photo: $e');
      notifyListeners();
    }
  }

  // Update theme (in-memory only)
  void updateTheme(String themeMode) {
    final updatedProfile = _userProfile.copyWith(
      themeMode: themeMode,
      updatedAt: DateTime.now(),
    );

    _userProfile = updatedProfile;
    notifyListeners();
  }

  // Update currency (in-memory only)
  void updateCurrency(String currency) {
    final updatedProfile = _userProfile.copyWith(
      currency: currency,
      updatedAt: DateTime.now(),
    );

    _userProfile = updatedProfile;
    notifyListeners();
  }

  // Update language (in-memory only)
  void updateLanguage(String language) {
    final updatedProfile = _userProfile.copyWith(
      language: language,
      updatedAt: DateTime.now(),
    );

    _userProfile = updatedProfile;
    notifyListeners();
  }

  // Update date format (in-memory only)
  void updateDateFormat(String dateFormat) {
    final updatedProfile = _userProfile.copyWith(
      dateFormat: dateFormat,
      updatedAt: DateTime.now(),
    );

    _userProfile = updatedProfile;
    notifyListeners();
  }

  // Get theme mode for MaterialApp
  ThemeMode get themeModeValue {
    switch (_userProfile.themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
