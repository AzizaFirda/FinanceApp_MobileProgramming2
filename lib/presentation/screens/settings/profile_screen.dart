import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/setting_provider.dart';
import '../../../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _cardController;
  late Animation<double> _cardAnimation;

  // Cream & Colorful Palette - matching home, assets, statistics screens
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

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();
    
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutCubic),
    );
    
    _cardController.forward();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          // Background decorations
          ..._buildBackgroundDecorations(),
          
          // Main content
          SafeArea(
            child: Consumer<SettingsProvider>(
              builder: (context, provider, child) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 32),
                      _buildProfileHeader(context, provider),
                      const SizedBox(height: 32),
                      _buildProfileInfo(context, provider),
                      const SizedBox(height: 24),
                      _buildAccountSection(context),
                      const SizedBox(height: 100),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBackgroundDecorations() {
    return [
      Positioned(
        top: -60,
        right: -40,
        child: AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _shimmerController.value * 2 * math.pi * 0.1,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      blueAccent.withValues(alpha: 0.08),
                      purpleAccent.withValues(alpha: 0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      Positioned(
        top: 300,
        left: -80,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                tealAccent.withValues(alpha: 0.06),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 150,
        right: -60,
        child: Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                purpleAccent.withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [blueAccent, purpleAccent],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, SettingsProvider provider) {
    final profile = provider.userProfile;

    return FadeTransition(
      opacity: _cardAnimation,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      blueAccent.withValues(alpha: 0.3),
                      purpleAccent.withValues(alpha: 0.3),
                      tealAccent.withValues(alpha: 0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: blueAccent.withValues(alpha: 0.15),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 64,
                  backgroundColor: borderLight,
                  backgroundImage: profile.photoUrl != null
                      ? NetworkImage(profile.photoUrl!)
                      : (profile.photoPath != null
                            ? FileImage(File(profile.photoPath!)) as ImageProvider
                            : null),
                  child: (profile.photoUrl == null && profile.photoPath == null)
                      ? const Icon(Icons.person_rounded, size: 64, color: textMuted)
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showPhotoOptions(context, provider),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [blueAccent, purpleAccent],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: cardWhite, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: blueAccent.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: cardWhite,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [blueAccent, purpleAccent],
            ).createShader(bounds),
            child: Text(
              profile.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          if (profile.email != null) ...[
            const SizedBox(height: 6),
            Text(
              profile.email!,
              style: TextStyle(
                color: textMuted.withValues(alpha: 0.8),
                fontSize: 15,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, SettingsProvider provider) {
    final profile = provider.userProfile;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FadeTransition(
        opacity: _cardAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: cardWhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderLight,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
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
                        Icons.person_outline_rounded,
                        color: blueAccent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ),
              _buildInfoItem(
                context,
                icon: Icons.badge_outlined,
                title: 'Name',
                value: profile.name,
                onTap: () => _showEditNameDialog(context, provider),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 1,
                color: borderLight,
              ),
              _buildInfoItem(
                context,
                icon: Icons.email_outlined,
                title: 'Email',
                value: profile.email ?? 'Not set',
                onTap: () => _showEditEmailDialog(context, provider),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 1,
                color: borderLight,
              ),
              _buildInfoItem(
                context,
                icon: Icons.calendar_month_outlined,
                title: 'Member since',
                value: _formatDate(profile.createdAt),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: blueAccent, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textMuted.withValues(alpha: 0.8),
                      fontSize: 13,
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
            if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                color: textMuted.withValues(alpha: 0.5),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FadeTransition(
        opacity: _cardAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: cardWhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderLight,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: coralAccent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.manage_accounts_outlined,
                        color: coralAccent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionItem(
                context,
                icon: Icons.logout_rounded,
                title: 'Sign Out',
                subtitle: 'Log out from your account',
                color: coralAccent,
                onTap: () => _showLogoutDialog(context),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textMuted.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: color.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoOptions(BuildContext context, SettingsProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: cardWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                decoration: BoxDecoration(
                  color: borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildBottomSheetItem(
                icon: Icons.photo_camera_rounded,
                title: 'Take Photo',
                color: blueAccent,
                onTap: () {
                  Navigator.pop(context);
                  provider.updateProfilePhoto(fromCamera: true);
                },
              ),
              _buildBottomSheetItem(
                icon: Icons.photo_library_rounded,
                title: 'Choose from Gallery',
                color: purpleAccent,
                onTap: () {
                  Navigator.pop(context);
                  provider.updateProfilePhoto(fromCamera: false);
                },
              ),
              if (provider.userProfile.photoPath != null)
                _buildBottomSheetItem(
                  icon: Icons.delete_outline_rounded,
                  title: 'Remove Photo',
                  color: coralAccent,
                  onTap: () {
                    Navigator.pop(context);
                    provider.removeProfilePhoto();
                  },
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheetItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: textDark,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showEditNameDialog(BuildContext context, SettingsProvider provider) {
    final controller = TextEditingController(text: provider.userProfile.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Name', style: TextStyle(color: textDark)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: textDark),
          decoration: InputDecoration(
            hintText: 'Enter your name',
            hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5)),
            filled: true,
            fillColor: background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: blueAccent, width: 2),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: blueAccent,
              foregroundColor: cardWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                provider.updateName(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Email', style: TextStyle(color: textDark)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: textDark),
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5)),
            filled: true,
            fillColor: background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: blueAccent, width: 2),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: blueAccent,
              foregroundColor: cardWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              provider.updateEmail(
                controller.text.isEmpty ? null : controller.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign Out', style: TextStyle(color: textDark)),
        content: Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: coralAccent,
              foregroundColor: cardWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().logout();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
