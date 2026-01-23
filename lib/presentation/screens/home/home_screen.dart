import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/transaction_provider.dart';
import '../../../providers/account_provider.dart';
import '../../../providers/category_provider.dart';
import '../../../providers/setting_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  late AnimationController _headerController;
  late Animation<double> _headerAnimation;

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
  static const Color orangeAccent = Color(0xFFFDAA00);

  @override
  void initState() {
    super.initState();
    
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    );
    
    _headerController.forward();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _pulseController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          // Subtle background decorations
          ..._buildBackgroundDecorations(),
          
          // Main content
          SafeArea(
            child: RefreshIndicator(
              color: tealAccent,
              backgroundColor: cardWhite,
              onRefresh: () async {
                if (context.mounted) {
                  await context.read<TransactionProvider>().loadTransactions();
                }
                if (context.mounted) {
                  await context.read<AccountProvider>().loadAccounts();
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 24),
                    _buildSummaryCards(context),
                    const SizedBox(height: 24),
                    _buildRecentTransactions(context),
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
      // Top right soft blob
      Positioned(
        top: -60,
        right: -40,
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
                      tealAccent.withOpacity(0.08),
                      tealAccent.withOpacity(0.02),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      // Bottom left soft blob
      Positioned(
        bottom: 200,
        left: -80,
        child: Container(
          width: 180,
          height: 180,
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
      // Floating particle
      Positioned(
        top: 300,
        right: 60,
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Opacity(
              opacity: 0.3 + (_pulseController.value * 0.3),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: orangeAccent,
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        final profile = settingsProvider.userProfile;

        return FadeTransition(
          opacity: _headerAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.3),
              end: Offset.zero,
            ).animate(_headerAnimation),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Avatar with colorful ring
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [tealAccent, blueAccent, purpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: tealAccent.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: cardWhite,
                      backgroundImage: profile.photoPath != null
                          ? FileImage(File(profile.photoPath!))
                          : null,
                      child: profile.photoPath == null
                          ? Icon(
                              Icons.person_rounded,
                              color: textMuted,
                              size: 28,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${profile.name}!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: tealAccent,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
                                style: TextStyle(
                                  color: textMuted,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Notification button
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardWhite,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderLight),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: textMuted,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return Consumer2<TransactionProvider, SettingsProvider>(
      builder: (context, transactionProvider, settingsProvider, child) {
        final now = DateTime.now();
        final summary = transactionProvider.getMonthlySummary(
          now.year,
          now.month,
        );
        final currency = settingsProvider.userProfile.currency;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Income & Expense Row
              Row(
                children: [
                  Expanded(
                    child: _buildAnimatedCard(
                      delay: 0,
                      child: _buildSummaryCard(
                        icon: Icons.trending_up_rounded,
                        iconBgColor: tealAccent.withOpacity(0.12),
                        iconColor: tealAccent,
                        title: 'Income',
                        amount: summary['income'] ?? 0,
                        currency: currency,
                        amountColor: tealAccent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildAnimatedCard(
                      delay: 100,
                      child: _buildSummaryCard(
                        icon: Icons.trending_down_rounded,
                        iconBgColor: coralAccent.withOpacity(0.12),
                        iconColor: coralAccent,
                        title: 'Expense',
                        amount: summary['expense'] ?? 0,
                        currency: currency,
                        amountColor: coralAccent,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Balance Card
              _buildAnimatedCard(
                delay: 200,
                child: _buildBalanceCard(
                  balance: summary['balance'] ?? 0,
                  currency: currency,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedCard({required int delay, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 800 + delay),
      curve: Curves.easeOutBack,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, 40 * (1 - value)),
          child: Opacity(
            opacity: value.clamp(0, 1),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required double amount,
    required String currency,
    required Color amountColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: textMuted,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              _formatCurrency(amount, currency),
              style: TextStyle(
                color: amountColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard({
    required double balance,
    required String currency,
  }) {
    final isPositive = balance >= 0;
    
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulseValue = 0.99 + (_pulseController.value * 0.01);
        
        return Transform.scale(
          scale: pulseValue,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  blueAccent,
                  purpleAccent,
                ],
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          'Total Balance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isPositive
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isPositive ? 'Profit' : 'Loss',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  _formatCurrency(balance, currency),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This Month',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    return Consumer3<TransactionProvider, CategoryProvider, AccountProvider>(
      builder: (context, transactionProvider, categoryProvider, accountProvider, child) {
        final transactions = transactionProvider.getRecentTransactions(limit: 10);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 26,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [tealAccent, blueAccent],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [tealAccent, blueAccent],
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: tealAccent.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            if (transactions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: borderLight,
                        ),
                        child: Icon(
                          Icons.receipt_long_rounded,
                          size: 52,
                          color: textMuted.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No transactions yet',
                        style: TextStyle(
                          color: textDark,
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Tap the + button to add your first transaction',
                        style: TextStyle(
                          color: textMuted,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    final category = categoryProvider.getCategoryById(
                      transaction.categoryId,
                    );
                    final account = accountProvider.getAccountById(
                      transaction.accountId,
                    );

                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(milliseconds: 500 + (index * 80)),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(40 * (1 - value), 0),
                          child: Opacity(
                            opacity: value,
                            child: _buildTransactionItem(
                              context,
                              transaction: transaction,
                              category: category,
                              account: account,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTransactionItem(
    BuildContext context, {
    required transaction,
    required category,
    required account,
  }) {
    final currency = context.read<SettingsProvider>().userProfile.currency;
    final isExpense = transaction.type.toString().split('.').last == 'expense';
    final isTransfer = transaction.type.toString().split('.').last == 'transfer';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isExpense
                  ? coralAccent.withOpacity(0.12)
                  : tealAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              category?.icon ?? '💰',
              style: const TextStyle(fontSize: 26),
            ),
          ),
          const SizedBox(width: 14),
          // Transaction info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isTransfer ? 'Mutasi' : (category?.name ?? 'Mutasi'),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 13,
                      color: textMuted,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '${account?.name ?? 'Akun'} • ${DateFormat('dd MMM yyyy').format(transaction.date)}',
                        style: TextStyle(
                          color: textMuted,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Amount badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isExpense
                  ? coralAccent.withOpacity(0.1)
                  : tealAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${isExpense ? '-' : '+'} ${_formatCurrency(transaction.amount, currency)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isExpense ? coralAccent : tealAccent,
              ),
            ),
          ),
        ],
      ),
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
