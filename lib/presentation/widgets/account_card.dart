import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/account_model.dart';
import '../../core/constants/app_colors.dart';

class AccountCard extends StatelessWidget {
  final AccountModel account;
  final String currency;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showBalance;

  const AccountCard({
    super.key,
    required this.account,
    this.currency = 'IDR',
    this.onTap,
    this.onLongPress,
    this.showBalance = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _buildIcon(),
                const SizedBox(width: 16),
                Expanded(child: _buildInfo()),
                if (showBalance) ...[
                  const SizedBox(width: 16),
                  _buildBalance(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(account.color).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(account.icon, style: const TextStyle(fontSize: 28)),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          account.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          _getAccountTypeLabel(),
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildBalance() {
    final isLiability = account.isLiability;
    final color = isLiability ? AppColors.expense : AppColors.income;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _formatCurrency(account.currentBalance.abs()),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: color,
          ),
        ),
        if (account.currentBalance != account.initialBalance) ...[
          const SizedBox(height: 4),
          Text(
            'from ${_formatCurrency(account.initialBalance.abs())}',
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
        ],
      ],
    );
  }

  String _getAccountTypeLabel() {
    switch (account.type) {
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

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: currency == 'IDR' ? 'Rp ' : '$currency ',
      decimalDigits: currency == 'IDR' ? 0 : 2,
    );
    return formatter.format(amount);
  }
}

class AccountCardCompact extends StatelessWidget {
  final AccountModel account;
  final String currency;
  final VoidCallback? onTap;

  const AccountCardCompact({
    super.key,
    required this.account,
    this.currency = 'IDR',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(account.color), Color(account.color).withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(account.color).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(account.icon, style: const TextStyle(fontSize: 24)),
                  Icon(
                    Icons.more_vert,
                    color: Colors.white.withOpacity(0.7),
                    size: 18,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatCurrency(account.currentBalance.abs()),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.compactCurrency(
      symbol: currency == 'IDR' ? 'Rp' : currency,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}
