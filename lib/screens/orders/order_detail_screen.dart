import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../widgets/order_status_badge.dart';
import '../../widgets/order_timeline_widget.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Listen to order provider so if admin updates status while user is viewing, it updates live!
    final orderProvider = Provider.of<OrderProvider>(context);
    final currentOrder = orderProvider.orders.firstWhere(
      (o) => o.id == order.id,
      orElse: () => order,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Order ${currentOrder.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            // Status Banner
            Card(
              color: AppColors.primary.withOpacity(0.08),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAlignment.start,
                      children: [
                        const Text(
                          'Order Status',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        OrderStatusBadge(status: currentOrder.orderStatus),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAlignment.end,
                      children: [
                        const Text(
                          'Placed On',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Formatters.formatDate(currentOrder.createdAt),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Live Order Tracking Timeline
            const Text(
              'Order Progress Tracking',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: OrderTimelineWidget(steps: currentOrder.timelineHistory),
              ),
            ),
            const SizedBox(height: 20),

            // Items List
            const Text(
              'Items Purchased',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: currentOrder.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.product.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Color: ${item.selectedColor} | Size: ${item.selectedSize}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                                Text(
                                  '${item.quantity} x ${Formatters.formatCurrency(item.product.price)}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            Formatters.formatCurrency(item.totalPrice),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Shipping Address & Payment
            const Text(
              'Delivery & Payment Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(currentOrder.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: Text(
                        currentOrder.shippingAddress,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ),
                    const Divider(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.payment, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Payment Method: ${currentOrder.paymentMethod} (${currentOrder.paymentStatus})',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
