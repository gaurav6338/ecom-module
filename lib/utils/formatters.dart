import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 0,
  );

  static String formatCurrency(double amount) {
    return _currencyFormat.format(amount);
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime);
  }

  static String formatDiscount(double discountPercentage) {
    return '${discountPercentage.toStringAsFixed(0)}% OFF';
  }
}
