import 'dart:math' as math;
import 'package:FinanceApp/data/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/transaction_provider.dart';
import '../../../providers/account_provider.dart';
import '../../../providers/category_provider.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/models/account_model.dart';
import '../../dialogs/add_category_dialog.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  String? _selectedCategoryId;
  String? _selectedAccountId;
  String? _toAccountId;
  DateTime _selectedDate = DateTime.now();

  // Animation controllers
  late AnimationController _headerController;
  late AnimationController _formController;
  late AnimationController _shimmerController;
  late Animation<double> _headerAnimation;
  late Animation<double> _formAnimation;

  // Cream & Colorful Palette
  static const Color background = Color(0xFFFAF9F7);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF2D3436);
  static const Color textMuted = Color(0xFF636E72);
  static const Color borderLight = Color(0xFFE8E6E3);

  // Colorful Accents
  static const Color tealAccent = Color(0xFF00B894);
  static const Color coralAccent = Color(0xFFFF7675);
  static const Color blueAccent = Color(0xFF0984E3);
  static const Color purpleAccent = Color(0xFF6C5CE7);
  static const Color orangeAccent = Color(0xFFFDAA00);

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _formController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutBack,
    );

    _formAnimation = CurvedAnimation(
      parent: _formController,
      curve: Curves.easeOutCubic,
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _formController.forward();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _headerController.dispose();
    _formController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  Color get _activeTypeColor {
    switch (_selectedType) {
      case TransactionType.expense:
        return coralAccent;
      case TransactionType.income:
        return tealAccent;
      case TransactionType.transfer:
        return purpleAccent;
    }
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
          Column(
            children: [
              SafeArea(
                bottom: false,
                child: _buildAnimatedHeader(),
              ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: FadeTransition(
                      opacity: _formAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(_formAnimation),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTypeSelector(),
                              const SizedBox(height: 24),
                              if (_selectedType == TransactionType.transfer) ...[
                                _buildTransferAccountsSection(),
                                const SizedBox(height: 20),
                              ],
                              _buildAmountField(),
                              const SizedBox(height: 20),
                              _buildCategorySelector(),
                              if (_selectedType != TransactionType.transfer) ...[
                                const SizedBox(height: 20),
                                _buildAccountSelector(),
                              ],
                              const SizedBox(height: 20),
                              _buildDatePicker(),
                              const SizedBox(height: 20),
                              _buildNoteField(),
                              const SizedBox(height: 32),
                              _buildSaveButton(),
                              const SizedBox(height: 20),
                            ],
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
                      _activeTypeColor.withValues(alpha: 0.08),
                      _activeTypeColor.withValues(alpha: 0.02),
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
        bottom: 100,
        left: -50,
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                blueAccent.withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildAnimatedHeader() {
    return ScaleTransition(
      scale: _headerAnimation,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_activeTypeColor, _activeTypeColor.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: _activeTypeColor.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Transaction',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getHeaderSubtitle(),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: math.sin(_shimmerController.value * 2 * math.pi) * 0.1,
                  child: Icon(
                    _getHeaderIcon(),
                    color: Colors.white.withValues(alpha: 0.9),
                    size: 40,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getHeaderSubtitle() {
    switch (_selectedType) {
      case TransactionType.expense:
        return 'Track your spending';
      case TransactionType.income:
        return 'Record your earnings';
      case TransactionType.transfer:
        return 'Move funds between accounts';
    }
  }

  IconData _getHeaderIcon() {
    switch (_selectedType) {
      case TransactionType.expense:
        return Icons.trending_down_rounded;
      case TransactionType.income:
        return Icons.trending_up_rounded;
      case TransactionType.transfer:
        return Icons.swap_horiz_rounded;
    }
  }

  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderLight, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeButton(
              label: 'Expense',
              icon: Icons.arrow_upward_rounded,
              type: TransactionType.expense,
              color: coralAccent,
            ),
          ),
          Expanded(
            child: _buildTypeButton(
              label: 'Income',
              icon: Icons.arrow_downward_rounded,
              type: TransactionType.income,
              color: tealAccent,
            ),
          ),
          Expanded(
            child: _buildTypeButton(
              label: 'Transfer',
              icon: Icons.swap_horiz_rounded,
              type: TransactionType.transfer,
              color: purpleAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton({
    required String label,
    required IconData icon,
    required TransactionType type,
    required Color color,
  }) {
    final isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
          _selectedCategoryId = null;
          if (type != TransactionType.transfer) {
            _toAccountId = null;
          }
          if (type == TransactionType.transfer) {
            _selectedAccountId = null;
            _toAccountId = null;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [color, color.withValues(alpha: 0.85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : textMuted,
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : textMuted,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  Widget _buildTransferAccountsSection() {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, child) {
        final accounts = accountProvider.getAssets();

        // Calculate balances by account type
        double cashBalance = 0;
        double bankBalance = 0;
        double ewalletBalance = 0;

        for (final account in accounts) {
          switch (account.type) {
            case AccountType.cash:
              cashBalance += account.currentBalance;
              break;
            case AccountType.bank:
              bankBalance += account.currentBalance;
              break;
            case AccountType.ewallet:
              ewalletBalance += account.currentBalance;
              break;
            case AccountType.liability:
              break;
          }
        }

        // Get selected account names for display
        final fromAccount = _selectedAccountId != null
            ? accounts.firstWhere(
                (a) => a.id == _selectedAccountId,
                orElse: () => accounts.first,
              )
            : null;
        final toAccount = _toAccountId != null
            ? accounts.firstWhere(
                (a) => a.id == _toAccountId,
                orElse: () => accounts.first,
              )
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transfer Summary Header
            if (fromAccount != null && toAccount != null)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      purpleAccent.withValues(alpha: 0.15),
                      blueAccent.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: purpleAccent.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            fromAccount.icon,
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            fromAccount.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: textDark,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            _formatCurrency(fromAccount.currentBalance),
                            style: const TextStyle(
                              fontSize: 11,
                              color: coralAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: purpleAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            toAccount.icon,
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            toAccount.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: textDark,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            _formatCurrency(toAccount.currentBalance),
                            style: const TextStyle(
                              fontSize: 11,
                              color: tealAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Balance Summary Cards - Similar to Income/Expense style
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderLight, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [purpleAccent, blueAccent],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Saldo Akun Anda',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textDark,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Balance Cards Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildTransferBalanceCard(
                          icon: '💵',
                          label: 'Cash',
                          balance: cashBalance,
                          color: tealAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTransferBalanceCard(
                          icon: '🏦',
                          label: 'M-Banking',
                          balance: bankBalance,
                          color: blueAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTransferBalanceCard(
                          icon: '📱',
                          label: 'E-Wallet',
                          balance: ewalletBalance,
                          color: orangeAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // From Account Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _selectedAccountId != null ? coralAccent : borderLight,
                  width: _selectedAccountId != null ? 2 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: coralAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_upward_rounded,
                          color: coralAccent,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Transfer Dari',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textDark,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      if (_selectedAccountId == null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: coralAccent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Pilih akun',
                            style: TextStyle(
                              fontSize: 11,
                              color: coralAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Account chips - full width
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(accounts.length, (index) {
                      final account = accounts[index];
                      final isSelected = _selectedAccountId == account.id;
                      final isDisabled = _toAccountId == account.id;

                      return Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(
                            left: index == 0 ? 0 : 4,
                            right: index == accounts.length - 1 ? 0 : 4,
                          ),
                          child: GestureDetector(
                            onTap: isDisabled ? null : () {
                              setState(() => _selectedAccountId = account.id);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(
                                        colors: [coralAccent, coralAccent.withValues(alpha: 0.85)],
                                      )
                                    : null,
                                color: isSelected
                                    ? null
                                    : isDisabled
                                        ? background.withValues(alpha: 0.5)
                                        : background,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? coralAccent
                                      : isDisabled
                                          ? borderLight.withValues(alpha: 0.5)
                                          : borderLight,
                                  width: isSelected ? 2 : 1.5,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: coralAccent.withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    account.icon,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: isDisabled ? Colors.grey : null,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    account.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: isSelected
                                          ? Colors.white
                                          : isDisabled
                                              ? textMuted
                                              : textDark,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Arrow indicator
            Center(
              child: AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, math.sin(_shimmerController.value * 2 * math.pi) * 2),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [purpleAccent, blueAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: purpleAccent.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_downward_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // To Account Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _toAccountId != null ? tealAccent : borderLight,
                  width: _toAccountId != null ? 2 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: tealAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_downward_rounded,
                          color: tealAccent,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Transfer Ke',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textDark,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      if (_toAccountId == null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: tealAccent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Pilih akun',
                            style: TextStyle(
                              fontSize: 11,
                              color: tealAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Account chips - full width
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(accounts.length, (index) {
                      final account = accounts[index];
                      final isSelected = _toAccountId == account.id;
                      final isDisabled = _selectedAccountId == account.id;

                      return Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(
                            left: index == 0 ? 0 : 4,
                            right: index == accounts.length - 1 ? 0 : 4,
                          ),
                          child: GestureDetector(
                            onTap: isDisabled ? null : () {
                              setState(() => _toAccountId = account.id);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(
                                        colors: [tealAccent, tealAccent.withValues(alpha: 0.85)],
                                      )
                                    : null,
                                color: isSelected
                                    ? null
                                    : isDisabled
                                        ? background.withValues(alpha: 0.5)
                                        : background,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? tealAccent
                                      : isDisabled
                                          ? borderLight.withValues(alpha: 0.5)
                                          : borderLight,
                                  width: isSelected ? 2 : 1.5,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: tealAccent.withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    account.icon,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: isDisabled ? Colors.grey : null,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    account.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: isSelected
                                          ? Colors.white
                                          : isDisabled
                                              ? textMuted
                                              : textDark,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTransferBalanceCard({
    required String icon,
    required String label,
    required double balance,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatCurrency(balance),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildValidationMessage(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: coralAccent, size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: coralAccent,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Amount', Icons.payments_rounded, blueAccent),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: cardWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderLight, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
            decoration: InputDecoration(
              prefixText: 'Rp ',
              prefixStyle: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textMuted,
              ),
              hintText: '0',
              hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5)),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter amount';
              }
              if (double.tryParse(value) == null || double.parse(value) <= 0) {
                return 'Please enter valid amount';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    if (_selectedType == TransactionType.transfer) {
      return const SizedBox.shrink();
    }

    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final categories = _selectedType == TransactionType.expense
            ? categoryProvider.getExpenseCategories()
            : categoryProvider.getIncomeCategories();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('Category', Icons.category_rounded, orangeAccent),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderLight, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (categories.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'No categories yet',
                        style: TextStyle(color: textMuted, fontSize: 14),
                      ),
                    ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ...categories.map((category) {
                        final isSelected = _selectedCategoryId == category.id;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategoryId = category.id;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.only(
                              left: 14,
                              top: 10,
                              bottom: 10,
                              right: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        _activeTypeColor,
                                        _activeTypeColor.withValues(alpha: 0.8),
                                      ],
                                    )
                                  : null,
                              color: isSelected ? null : background,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? _activeTypeColor
                                    : borderLight,
                                width: isSelected ? 2 : 1.5,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: _activeTypeColor.withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  category.icon,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  category.name,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected ? Colors.white : textDark,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                // Delete button
                                GestureDetector(
                                  onTap: () {
                                    _showDeleteCategoryDialog(context, category);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: isSelected 
                                          ? Colors.white.withValues(alpha: 0.2)
                                          : coralAccent.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      Icons.delete_outline_rounded,
                                      size: 16,
                                      color: isSelected ? Colors.white : coralAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      // Add category button
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const AddCategoryDialog(),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: blueAccent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: blueAccent, width: 2),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_rounded, color: blueAccent, size: 20),
                              const SizedBox(width: 6),
                              Text(
                                'Add',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: blueAccent,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_selectedCategoryId == null && categories.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: _buildValidationMessage('Please select a category'),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAccountSelector() {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, child) {
        final accounts = accountProvider.getAssets();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('Account', Icons.account_balance_wallet_rounded, purpleAccent),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: cardWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderLight, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(
                    'Select account',
                    style: TextStyle(color: textMuted),
                  ),
                  value: _selectedAccountId,
                  icon: Icon(Icons.keyboard_arrow_down_rounded, color: purpleAccent),
                  style: TextStyle(
                    color: textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  items: accounts.map((account) {
                    return DropdownMenuItem(
                      value: account.id,
                      child: Row(
                        children: [
                          Text(account.icon, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 12),
                          Text(
                            account.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textDark,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAccountId = value;
                    });
                  },
                ),
              ),
            ),
            if (_selectedAccountId == null)
              _buildValidationMessage('Please select an account'),
          ],
        );
      },
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Date', Icons.calendar_today_rounded, orangeAccent),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: _activeTypeColor,
                      onPrimary: Colors.white,
                      surface: cardWhite,
                      onSurface: textDark,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              setState(() {
                _selectedDate = date;
              });
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderLight, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: orangeAccent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.calendar_month_rounded, color: orangeAccent, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  DateFormat('EEEE, dd MMMM yyyy').format(_selectedDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: textDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Note (Optional)', Icons.note_alt_rounded, textMuted),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: cardWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderLight, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: _noteController,
            maxLines: 3,
            style: const TextStyle(color: textDark, fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Add note...',
              hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.6)),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _saveTransaction,
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _activeTypeColor,
                  _activeTypeColor.withValues(alpha: 0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: _activeTypeColor.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.save_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Save Transaction',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedType != TransactionType.transfer && _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a category'),
          backgroundColor: coralAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (_selectedType == TransactionType.transfer) {
      if (_selectedAccountId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Pilih akun sumber transfer'),
            backgroundColor: coralAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }
      if (_toAccountId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Pilih akun tujuan transfer'),
            backgroundColor: coralAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }
      if (_selectedAccountId == _toAccountId) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Akun sumber dan tujuan tidak boleh sama'),
            backgroundColor: coralAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }
    } else {
      if (_selectedAccountId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select an account'),
            backgroundColor: coralAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }
    }

    final amount = double.parse(_amountController.text);

    final transaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      type: _selectedType,
      categoryId: _selectedCategoryId ?? '',
      accountId: _selectedAccountId!,
      toAccountId: _selectedType == TransactionType.transfer ? _toAccountId : null,
      date: _selectedDate,
      note: _noteController.text.isEmpty ? null : _noteController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await context.read<TransactionProvider>().addTransaction(transaction);

    if (success) {
      // Reload account balances to reflect the transaction
      if (mounted) {
        await context.read<AccountProvider>().loadAccounts();
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  _selectedType == TransactionType.transfer
                      ? 'Transfer berhasil disimpan'
                      : 'Transaction saved successfully',
                ),
              ],
            ),
            backgroundColor: tealAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 10),
                Text('Failed to save transaction'),
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

  // Show confirmation dialog and delete category if confirmed
  Future<void> _showDeleteCategoryDialog(BuildContext context, CategoryModel category) async {
    final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Hapus Kategori'),
            content: Text('Yakin ingin menghapus "${category.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Hapus'),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldDelete) return;

    final success = await Provider.of<CategoryProvider>(context, listen: false)
        .deleteCategory(category.id!);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Kategori dihapus' : 'Gagal menghapus kategori'),
          backgroundColor: success ? tealAccent : coralAccent,
        ),
      );
    }
  }

}
