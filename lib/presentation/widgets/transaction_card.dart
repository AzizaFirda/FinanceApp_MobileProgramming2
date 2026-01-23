import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/account_model.dart';
import '../../core/constants/app_colors.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final CategoryModel? category;
  final AccountModel? account;
  final String currency;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showDate;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.category,
    this.account,
    this.currency = 'IDR',
    this.onTap,
    this.onLongPress,
    this.showDate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildIcon(),
                const SizedBox(width: 12),
                Expanded(child: _buildInfo(context)),
                const SizedBox(width: 12),
                _buildAmount(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        category?.icon ?? _getDefaultIcon(),
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  String _getDisplayName() {
    // For transfers, show 'Mutasi' instead of category name
    if (transaction.type == TransactionType.transfer) {
      return 'Mutasi';
    }
    return category?.name ?? _getTransactionTypeName();
  }

  Widget _buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getDisplayName(),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 4),
        if (showDate)
          Text(
            '${account?.name ?? 'Unknown'} • ${DateFormat('dd MMM yyyy').format(transaction.date)}',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          )
        else
          Text(
            account?.name ?? 'Unknown',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        if (transaction.note != null && transaction.note!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            transaction.note!,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildAmount() {
    final isExpense = transaction.type == TransactionType.expense;
    final color = isExpense ? AppColors.expense : AppColors.income;
    final sign = isExpense ? '-' : '+';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$sign ${_formatCurrency(transaction.amount)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        if (transaction.type == TransactionType.transfer)
          Text(
            'Transfer',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
      ],
    );
  }

  String _getTransactionTypeName() {
    switch (transaction.type) {
      case TransactionType.expense:
        return 'Expense';
      case TransactionType.income:
        return 'Income';
      case TransactionType.transfer:
        return 'Transfer';
    }
  }

  String _getDefaultIcon() {
    switch (transaction.type) {
      case TransactionType.expense:
        return '💸';
      case TransactionType.income:
        return '💰';
      case TransactionType.transfer:
        return '🔄';
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

class TransactionListItem extends StatelessWidget {
  final TransactionModel transaction;
  final CategoryModel? category;
  final AccountModel? account;
  final String currency;
  final VoidCallback? onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    this.category,
    this.account,
    this.currency = 'IDR',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == TransactionType.expense;
    final color = isExpense ? AppColors.expense : AppColors.income;
    final sign = isExpense ? '-' : '+';

    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          category?.icon ?? '💰',
          style: const TextStyle(fontSize: 20),
        ),
      ),
      title: Text(
        transaction.type == TransactionType.transfer ? 'Mutasi' : (category?.name ?? 'Mutasi'),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        DateFormat('dd MMM yyyy, HH:mm').format(transaction.date),
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: Text(
        '$sign ${_formatCurrency(transaction.amount)}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: color,
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: currency == 'IDR' ? 'Rp ' : '$currency ',
      decimalDigits: currency == 'IDR' ? 0 : 2,
    );
    return formatter.format(amount);
  }
}
