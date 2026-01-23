import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../../../providers/account_provider.dart';
import '../../../providers/setting_provider.dart';
import '../../../data/models/account_model.dart';
import '../../dialogs/add_account_dialog.dart';

class AssetsScreen extends StatefulWidget {
  const AssetsScreen({super.key});

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _cardController;
  late Animation<double> _cardAnimation;

  // Clean & Professional Color Palette
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
      duration: const Duration(milliseconds: 1000),
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
            child: RefreshIndicator(
              color: tealAccent,
              backgroundColor: cardWhite,
              onRefresh: () async {
                await context.read<AccountProvider>().loadAccounts();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 24),
                    _buildNetWorthCard(context),
                    const SizedBox(height: 24),
                    _buildAssetsSection(context),
                    const SizedBox(height: 24),
                    _buildLiabilitiesSection(context),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBackgroundDecorations() {
    return [
      Positioned(
        top: -80,
        right: -60,
        child: AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _shimmerController.value * 2 * math.pi * 0.05,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      blueAccent.withOpacity(0.08),
                      blueAccent.withOpacity(0.02),
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
        bottom: 300,
        left: -100,
        child: Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                purpleAccent.withOpacity(0.06),
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
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [blueAccent, purpleAccent],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Assets & Liabilities',
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

  Widget _buildNetWorthCard(BuildContext context) {
    return Consumer2<AccountProvider, SettingsProvider>(
      builder: (context, accountProvider, settingsProvider, child) {
        final totalAssets = accountProvider.getTotalAssets();
        final totalLiabilities = accountProvider.getTotalLiabilities();
        final netWorth = accountProvider.getNetWorth();
        final currency = settingsProvider.userProfile.currency;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FadeTransition(
            opacity: _cardAnimation,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [blueAccent, purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: blueAccent.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
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
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Net Worth',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _formatCurrency(netWorth, currency),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildNetWorthItem(
                          icon: Icons.trending_up_rounded,
                          label: 'Assets',
                          amount: totalAssets,
                          currency: currency,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      Expanded(
                        child: _buildNetWorthItem(
                          icon: Icons.trending_down_rounded,
                          label: 'Liabilities',
                          amount: totalLiabilities,
                          currency: currency,
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

  Widget _buildNetWorthItem({
    required IconData icon,
    required String label,
    required double amount,
    required String currency,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.8), size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _formatCurrency(amount, currency),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAssetsSection(BuildContext context) {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, child) {
        final assetAccounts = accountProvider.accounts
            .where((a) => a.type != AccountType.liability && a.isActive)
            .toList();

        return _buildAccountSection(
          context,
          title: 'Assets',
          icon: Icons.account_balance_rounded,
          accounts: assetAccounts,
          accentColor: tealAccent,
          onAddPressed: () => _showAddAccountDialog(context),
        );
      },
    );
  }

  Widget _buildLiabilitiesSection(BuildContext context) {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, child) {
        final liabilityAccounts = accountProvider.accounts
            .where((a) => a.type == AccountType.liability && a.isActive)
            .toList();

        return _buildAccountSection(
          context,
          title: 'Liabilities',
          icon: Icons.credit_card_rounded,
          accounts: liabilityAccounts,
          accentColor: coralAccent,
          onAddPressed: () => _showAddAccountDialog(context),
        );
      },
    );
  }

  Widget _buildAccountSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<AccountModel> accounts,
    required Color accentColor,
    required VoidCallback onAddPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FadeTransition(
        opacity: _cardAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: cardWhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: accentColor, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: onAddPressed,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [tealAccent, blueAccent],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: tealAccent.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              if (accounts.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: borderLight,
                          ),
                          child: Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 40,
                            color: textMuted.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No $title yet',
                          style: TextStyle(
                            color: textMuted,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                // Batas tinggi agar daftar bisa discroll secara independen
                // jika daftar terlalu panjang. Responsif untuk liabilities.
                SizedBox(
                  height: math.min(accounts.length * 88.0, 320.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: accounts.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      indent: 20,
                      endIndent: 20,
                      color: borderLight,
                    ),
                    itemBuilder: (context, index) {
                      final account = accounts[index];
                      return _buildAccountItem(context, account, accentColor);
                    },
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountItem(BuildContext context, AccountModel account, Color accentColor) {
    final currency = context.read<SettingsProvider>().userProfile.currency;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Color(account.color).withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              account.icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getAccountTypeName(account.type),
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatCurrency(account.currentBalance, currency),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: account.type != AccountType.liability ? tealAccent : coralAccent,
            ),
          ),
        ],
      ),
    );
  }

  String _getAccountTypeName(AccountType type) {
    switch (type) {
      case AccountType.cash:
        return 'Cash';
      case AccountType.bank:
        return 'Bank Account';
      case AccountType.ewallet:
        return 'E-Wallet';
      case AccountType.liability:
        return 'Liability';
    }
  }

  void _showAddAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddAccountDialog(),
    );
  }

  String _formatCurrency(double amount, String currency) {
    final formatter = NumberFormat.currency(
      symbol: currency == 'IDR' ? 'Rp ' : '$currency ',
      decimalDigits: currency == 'IDR' ? 0 : 2,
    );
    return formatter.format(amount);
  }
}
