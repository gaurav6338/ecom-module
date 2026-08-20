import 'package:flutter/material.dart';

class OrderStatusBadge extends StatelessWidget {
  final String status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status) {
      case 'Delivered':
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF065F46);
        break;
      case 'Shipped':
        bg = const Color(0xFFEDE9FE);
        fg = const Color(0xFF5B21B6);
        break;
      case 'Processing':
        bg = const Color(0xFFE0E7FF);
        fg = const Color(0xFF3730A3);
        break;
      case 'Confirmed':
        bg = const Color(0xFFDBEAFE);
        fg = const Color(0xFF1E40AF);
        break;
      case 'Pending':
      default:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFF92400E);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
