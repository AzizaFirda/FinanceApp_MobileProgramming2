import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount, String currency) {
    final formatter = NumberFormat.currency(
      symbol: _getCurrencySymbol(currency),
      decimalDigits: _getDecimalDigits(currency),
    );
    return formatter.format(amount);
  }

  static String formatCompact(double amount, String currency) {
    final formatter = NumberFormat.compactCurrency(
      symbol: _getCurrencySymbol(currency),
      decimalDigits: _getDecimalDigits(currency),
    );
    return formatter.format(amount);
  }

  static String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'IDR':
        return 'Rp ';
      case 'USD':
        return '\$ ';
      case 'EUR':
        return '€ ';
      case 'GBP':
        return '£ ';
      case 'JPY':
        return '¥ ';
      case 'SGD':
        return 'S\$ ';
      case 'MYR':
        return 'RM ';
      default:
        return '$currency ';
    }
  }

  static int _getDecimalDigits(String currency) {
    switch (currency.toUpperCase()) {
      case 'IDR':
      case 'JPY':
        return 0;
      default:
        return 2;
    }
  }
}
