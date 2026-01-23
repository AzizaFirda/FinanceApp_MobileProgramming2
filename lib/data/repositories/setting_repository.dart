import 'package:hive/hive.dart';
import '../models/user_profile_model.dart';

class SettingsRepository {
  static const String _boxName = 'userProfile';
  static const String _profileKey = 'profile';

  Box<UserProfileModel> get _box => Hive.box<UserProfileModel>(_boxName);

  // Initialize default profile
  Future<void> initializeDefaultProfile() async {
    if (_box.isEmpty) {
      final defaultProfile = UserProfileModel.create(
        name: 'User',
        currency: 'IDR',
        language: 'id',
        dateFormat: 'dd/MM/yyyy',
        themeMode: 'system',
      );
      await _box.put(_profileKey, defaultProfile);
    }
  }

  // Get user profile
  Future<UserProfileModel> getUserProfile() async {
    var profile = _box.get(_profileKey);

    if (profile == null) {
      await initializeDefaultProfile();
      profile = _box.get(_profileKey)!;
    }

    return profile;
  }

  // Update user profile
  Future<void> updateUserProfile(UserProfileModel profile) async {
    await _box.put(_profileKey, profile);
  }

  // Update specific fields
  Future<void> updateName(String name) async {
    final profile = await getUserProfile();
    final updatedProfile = profile.copyWith(
      name: name,
      updatedAt: DateTime.now(),
    );
    await updateUserProfile(updatedProfile);
  }

  Future<void> updateEmail(String? email) async {
    final profile = await getUserProfile();
    final updatedProfile = profile.copyWith(
      email: email,
      updatedAt: DateTime.now(),
    );
    await updateUserProfile(updatedProfile);
  }

  Future<void> updatePhotoPath(String? photoPath) async {
    final profile = await getUserProfile();
    final updatedProfile = profile.copyWith(
      photoPath: photoPath,
      updatedAt: DateTime.now(),
    );
    await updateUserProfile(updatedProfile);
  }

  Future<void> updateCurrency(String currency) async {
    final profile = await getUserProfile();
    final updatedProfile = profile.copyWith(
      currency: currency,
      updatedAt: DateTime.now(),
    );
    await updateUserProfile(updatedProfile);
  }

  Future<void> updateLanguage(String language) async {
    final profile = await getUserProfile();
    final updatedProfile = profile.copyWith(
      language: language,
      updatedAt: DateTime.now(),
    );
    await updateUserProfile(updatedProfile);
  }

  Future<void> updateDateFormat(String dateFormat) async {
    final profile = await getUserProfile();
    final updatedProfile = profile.copyWith(
      dateFormat: dateFormat,
      updatedAt: DateTime.now(),
    );
    await updateUserProfile(updatedProfile);
  }

  Future<void> updateThemeMode(String themeMode) async {
    final profile = await getUserProfile();
    final updatedProfile = profile.copyWith(
      themeMode: themeMode,
      updatedAt: DateTime.now(),
    );
    await updateUserProfile(updatedProfile);
  }

  // Reset profile
  Future<void> resetProfile() async {
    await _box.clear();
    await initializeDefaultProfile();
  }
}
