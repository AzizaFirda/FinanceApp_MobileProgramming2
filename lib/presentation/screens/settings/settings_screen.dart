import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/setting_provider.dart';
import '../../../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _profileController;
  late AnimationController _settingsController;
  late AnimationController _logoutController;
  late Animation<double> _headerFade;
  late Animation<Offset> _profileSlide;
  late Animation<Offset> _settingsSlide;
  late Animation<double> _logoutScale;
  late Animation<double> _logoutShake;
  bool _isLoggingOut = false;

  // Cream & Colorful Palette - matching home, assets, statistics, profile screens
  static const Color background = Color(0xFFFAF9F7);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF2D3436);
  static const Color textMuted = Color(0xFF636E72);
  static const Color borderLight = Color(0xFFE8E6E3);
  
  // Colorful but Professional Accents
  static const Color tealAccent = Color(0xFF00B894);
  static const Color coralAccent = Color(0xFFFF7675);
  static const Color blueAccent = Color(0xFF0984E3);
  static const Color purpleAccent = Color(0xFF6C5CE7);
  static const Color orangeAccent = Color(0xFFFDAA00);

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _profileController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _settingsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _logoutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );

    _profileSlide = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _profileController, curve: Curves.elasticOut),
        );

    _settingsSlide = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _settingsController,
            curve: Curves.elasticOut,
          ),
        );

    _logoutScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoutController, curve: Curves.elasticOut),
    );

    _logoutShake = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoutController, curve: Curves.easeInOut),
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _profileController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _settingsController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _logoutController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _profileController.dispose();
    _settingsController.dispose();
    _logoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildAnimatedHeader(context),
              const SizedBox(height: 32),
              _buildAnimatedProfileSection(context),
              const SizedBox(height: 20),
              _buildAnimatedBasicSettingsSection(context),
              const SizedBox(height: 24),
              _buildLogoutButton(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader(BuildContext context) {
    return FadeTransition(
      opacity: _headerFade,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [blueAccent, purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: blueAccent.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.settings_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Customize your experience',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedProfileSection(BuildContext context) {
    return SlideTransition(
      position: _profileSlide,
      child: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          final profile = provider.userProfile;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: cardWhite,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderLight, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              blueAccent.withValues(alpha: 0.15),
                              purpleAccent.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 20,
                          color: blueAccent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: borderLight,
                ),

                // Profile Photo
                _buildProfilePhotoItem(context, provider),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 1,
                  color: borderLight,
                ),

                // Name
                _buildProfileItem(
                  context,
                  icon: Icons.badge_rounded,
                  title: 'Name',
                  value: profile.name,
                  onTap: () => _showEditNameDialog(context, provider),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 1,
                  color: borderLight,
                ),

                // Email
                _buildProfileItem(
                  context,
                  icon: Icons.email_rounded,
                  title: 'Email',
                  value: profile.email ?? 'Not set',
                  onTap: () => _showEditEmailDialog(context, provider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfilePhotoItem(
    BuildContext context,
    SettingsProvider provider,
  ) {
    final profile = provider.userProfile;

    return InkWell(
      onTap: () => _showProfilePhotoDialog(context, provider),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Hero(
              tag: 'profile_photo',
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      blueAccent.withValues(alpha: 0.3),
                      purpleAccent.withValues(alpha: 0.3),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: blueAccent.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: borderLight,
                  backgroundImage: profile.photoPath != null
                      ? FileImage(File(profile.photoPath!))
                      : null,
                  child: profile.photoPath == null
                      ? const Icon(
                          Icons.person_rounded,
                          size: 36,
                          color: textMuted,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profile Photo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to change photo',
                    style: TextStyle(
                      fontSize: 13,
                      color: textMuted.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: blueAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: blueAccent,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBasicSettingsSection(BuildContext context) {
    return SlideTransition(
      position: _settingsSlide,
      child: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          final profile = provider.userProfile;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: cardWhite,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderLight, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: tealAccent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          size: 20,
                          color: tealAccent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Basic Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: borderLight,
                ),

                // Theme
                _buildSettingsItem(
                  context,
                  icon: Icons.palette_rounded,
                  title: 'Theme',
                  value: _getThemeLabel(profile.themeMode),
                  onTap: () => _showThemeDialog(context, provider),
                  iconColor: purpleAccent,
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 1,
                  color: borderLight,
                ),

                // Currency
                _buildSettingsItem(
                  context,
                  icon: Icons.payments_rounded,
                  title: 'Currency',
                  value: profile.currency,
                  onTap: () => _showCurrencyDialog(context, provider),
                  iconColor: tealAccent,
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 1,
                  color: borderLight,
                ),

                // Language
                _buildSettingsItem(
                  context,
                  icon: Icons.language_rounded,
                  title: 'Language',
                  value: _getLanguageLabel(profile.language),
                  onTap: () => _showLanguageDialog(context, provider),
                  iconColor: blueAccent,
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 1,
                  color: borderLight,
                ),

                // Date Format
                _buildSettingsItem(
                  context,
                  icon: Icons.calendar_today_rounded,
                  title: 'Date Format',
                  value: profile.dateFormat,
                  onTap: () => _showDateFormatDialog(context, provider),
                  iconColor: orangeAccent,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: blueAccent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textMuted.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: textDark,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: blueAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: blueAccent,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: textDark,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                color: iconColor,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  String _getThemeLabel(String themeMode) {
    switch (themeMode) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      case 'system':
      default:
        return 'System';
    }
  }

  String _getLanguageLabel(String language) {
    switch (language) {
      case 'en':
        return 'English';
      case 'id':
        return 'Bahasa Indonesia';
      default:
        return language.toUpperCase();
    }
  }

  // Dialog methods
  void _showProfilePhotoDialog(
    BuildContext context,
    SettingsProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: cardWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _buildBottomSheetItem(
                icon: Icons.photo_camera_rounded,
                title: 'Take Photo',
                iconColor: blueAccent,
                onTap: () {
                  Navigator.pop(context);
                  provider.updateProfilePhoto(fromCamera: true);
                },
              ),
              _buildBottomSheetItem(
                icon: Icons.photo_library_rounded,
                title: 'Choose from Gallery',
                iconColor: purpleAccent,
                onTap: () {
                  Navigator.pop(context);
                  provider.updateProfilePhoto(fromCamera: false);
                },
              ),
              if (provider.userProfile.photoPath != null)
                _buildBottomSheetItem(
                  icon: Icons.delete_rounded,
                  title: 'Remove Photo',
                  iconColor: coralAccent,
                  onTap: () {
                    Navigator.pop(context);
                    provider.removeProfilePhoto();
                  },
                ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheetItem({
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, SettingsProvider provider) {
    final controller = TextEditingController(text: provider.userProfile.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [blueAccent, purpleAccent],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.badge_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Edit Name',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
          ],
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: textDark),
          decoration: InputDecoration(
            hintText: 'Enter your name',
            hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5)),
            filled: true,
            fillColor: background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: blueAccent, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              provider.updateName(controller.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: blueAccent,
              foregroundColor: cardWhite,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Save',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditEmailDialog(BuildContext context, SettingsProvider provider) {
    final controller = TextEditingController(
      text: provider.userProfile.email ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [blueAccent, purpleAccent],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.email_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Edit Email',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
          ],
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: textDark),
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5)),
            filled: true,
            fillColor: background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: blueAccent, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              provider.updateEmail(
                controller.text.isEmpty ? null : controller.text,
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: blueAccent,
              foregroundColor: cardWhite,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Save',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(
    BuildContext context,
    SettingsProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [purpleAccent, blueAccent],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.palette_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Select Theme',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRadioTile(
              'Light',
              'light',
              provider.userProfile.themeMode,
              Icons.light_mode_rounded,
              provider,
              purpleAccent,
            ),
            _buildRadioTile(
              'Dark',
              'dark',
              provider.userProfile.themeMode,
              Icons.dark_mode_rounded,
              provider,
              purpleAccent,
            ),
            _buildRadioTile(
              'System',
              'system',
              provider.userProfile.themeMode,
              Icons.settings_suggest_rounded,
              provider,
              purpleAccent,
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyDialog(
    BuildContext context,
    SettingsProvider provider,
  ) {
    final currencies = ['IDR', 'USD', 'EUR', 'GBP', 'JPY', 'SGD', 'MYR'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [tealAccent, Color(0xFF55EFC4)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.payments_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Select Currency',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              final currency = currencies[index];
              return _buildRadioTile(
                currency,
                currency,
                provider.userProfile.currency,
                Icons.monetization_on_rounded,
                provider,
                tealAccent,
                onChanged: (value) {
                  provider.updateCurrency(value!);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    SettingsProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [blueAccent, Color(0xFF74B9FF)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.language_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Select Language',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRadioTile(
              'English',
              'en',
              provider.userProfile.language,
              Icons.language_rounded,
              provider,
              blueAccent,
            ),
            _buildRadioTile(
              'Bahasa Indonesia',
              'id',
              provider.userProfile.language,
              Icons.language_rounded,
              provider,
              blueAccent,
            ),
          ],
        ),
      ),
    );
  }

  void _showDateFormatDialog(
    BuildContext context,
    SettingsProvider provider,
  ) {
    final formats = ['dd/MM/yyyy', 'MM/dd/yyyy', 'yyyy-MM-dd'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [orangeAccent, Color(0xFFFFD93D)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Select Date Format',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: formats.map((format) {
            return _buildRadioTile(
              format,
              format,
              provider.userProfile.dateFormat,
              Icons.calendar_month_rounded,
              provider,
              orangeAccent,
              onChanged: (value) {
                provider.updateDateFormat(value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRadioTile(
    String title,
    String value,
    String groupValue,
    IconData icon,
    SettingsProvider provider,
    Color accentColor, {
    Function(String?)? onChanged,
  }) {
    final isSelected = value == groupValue;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [accentColor, accentColor.withValues(alpha: 0.8)],
              )
            : null,
        color: isSelected ? null : background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? accentColor : borderLight,
          width: 1.5,
        ),
      ),
      child: RadioListTile<String>(
        title: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : textMuted,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : textDark,
              ),
            ),
          ],
        ),
        value: value,
        groupValue: groupValue,
        activeColor: Colors.white,
        onChanged:
            onChanged ??
            (val) {
              if (val != null) {
                if (title == 'Light' || title == 'Dark' || title == 'System') {
                  provider.updateTheme(val);
                } else if (title == 'English' || title == 'Bahasa Indonesia') {
                  provider.updateLanguage(val);
                }
                Navigator.pop(context);
              }
            },
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ScaleTransition(
      scale: _logoutScale,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: AnimatedBuilder(
          animation: _logoutShake,
          builder: (context, child) {
            return GestureDetector(
              onTap: _isLoggingOut ? null : () => _showLogoutConfirmation(context),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                decoration: BoxDecoration(
                  gradient: _isLoggingOut
                      ? LinearGradient(
                          colors: [
                            coralAccent.withValues(alpha: 0.6),
                            Colors.red.withValues(alpha: 0.5),
                          ],
                        )
                      : const LinearGradient(
                          colors: [coralAccent, Color(0xFFE74C3C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: coralAccent.withValues(alpha: _isLoggingOut ? 0.2 : 0.4),
                      blurRadius: _isLoggingOut ? 10 : 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoggingOut)
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 12),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    else
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 800),
                        builder: (context, value, child) {
                          return Transform.rotate(
                            angle: value * 0.1,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.logout_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          );
                        },
                      ),
                    const SizedBox(width: 12),
                    Text(
                      _isLoggingOut ? 'Logging out...' : 'Logout',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Logout Dialog',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.elasticOut,
        );

        return ScaleTransition(
          scale: curvedAnimation,
          child: FadeTransition(
            opacity: animation,
            child: AlertDialog(
              backgroundColor: cardWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              contentPadding: const EdgeInsets.all(24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated icon
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                coralAccent.withValues(alpha: 0.15),
                                Colors.red.withValues(alpha: 0.1),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            color: coralAccent,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Are you sure you want to logout from your account?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: textMuted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: background,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: borderLight, width: 1.5),
                            ),
                            child: const Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: textMuted,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            _performLogout(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [coralAccent, Color(0xFFE74C3C)],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: coralAccent.withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.logout();

      if (success && mounted) {
        // Navigate to login screen and clear all routes
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      } else if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 10),
                Text(authProvider.errorMessage ?? 'Logout failed'),
              ],
            ),
            backgroundColor: coralAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 10),
                Text('Error: ${e.toString()}'),
              ],
            ),
            backgroundColor: coralAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }
}
