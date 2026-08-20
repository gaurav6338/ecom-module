import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/order_status_badge.dart';
import '../../utils/formatters.dart';
import 'order_detail_screen.dart';

class UserOrdersScreen extends StatelessWidget {
  const UserOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    final userId = authProvider.currentUser?.id ?? 'user_rishi_01';
    final userOrders = orderProvider.getUserOrders(userId);

    return Scaffold(
      appBar: AppBar(title: const Text('My Order History')),
      body: userOrders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 70, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'No orders placed yet',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your order history will appear here',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: userOrders.length,
              itemBuilder: (context, index) {
                final order = userOrders[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderDetailScreen(order: order),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order.id,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              OrderStatusBadge(status: order.orderStatus),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            Formatters.formatDateTime(order.createdAt),
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                          const Divider(height: 16),
                          // Thumbnails Preview
                          Row(
                            children: [
                              ...order.items.take(3).map((item) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item.product.imageUrl,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }),
                              if (order.items.length > 3)
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.grey.shade200,
                                  child: Text(
                                    '+${order.items.length - 3}',
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAlignment.end,
                                children: [
                                  Text(
                                    '${order.items.length} item(s)',
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                  ),
                                  Text(
                                    Formatters.formatCurrency(order.totalAmount),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
