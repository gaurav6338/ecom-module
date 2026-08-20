import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/order_status_badge.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';
import '../orders/order_detail_screen.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  final List<String> _statusOptions = const [
    'Pending',
    'Confirmed',
    'Processing',
    'Shipped',
    'Delivered',
  ];

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      body: orderProvider.orders.isEmpty
          ? const Center(child: Text('No orders found'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orderProvider.orders.length,
              itemBuilder: (context, index) {
                final order = orderProvider.orders[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.id,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            OrderStatusBadge(status: order.orderStatus),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Customer: ${order.customerName} (${order.customerEmail})',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        Text(
                          'Date: ${Formatters.formatDateTime(order.createdAt)}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        Text(
                          'Total: ${Formatters.formatCurrency(order.totalAmount)} (${order.paymentMethod})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.primary,
                          ),
                        ),
                        const Divider(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Update Status:',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            DropdownButton<String>(
                              value: order.orderStatus,
                              underline: const SizedBox(),
                              icon: const Icon(Icons.arrow_drop_down_circle, color: AppColors.primary),
                              onChanged: (newStatus) {
                                if (newStatus != null) {
                                  orderProvider.updateOrderStatus(order.id, newStatus);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Updated Order ${order.id} status to $newStatus'),
                                      backgroundColor: AppColors.secondary,
                                    ),
                                  );
                                }
                              },
                              items: _statusOptions.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status, style: const TextStyle(fontSize: 13)),
                                );
                              }).toList(),
                            ),
                            IconButton(
                              icon: const Icon(Icons.visibility, color: AppColors.primary),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OrderDetailScreen(order: order),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
