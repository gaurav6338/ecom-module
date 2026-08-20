import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/stat_card_widget.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';

class AdminDashboardTab extends StatelessWidget {
  const AdminDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          // Banner Greeting
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.admin_panel_settings, size: 40, color: Colors.white),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Text(
                      'Admin Control Center',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Real-time metrics & management panel',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Store Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // 2x2 Grid for Primary Metrics
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              StatCardWidget(
                title: 'Total Revenue',
                value: Formatters.formatCurrency(orderProvider.totalRevenue),
                icon: Icons.currency_rupee,
                color: AppColors.secondary,
                subtitle: '+12% from last week',
              ),
              StatCardWidget(
                title: 'Total Orders',
                value: '${orderProvider.totalOrdersCount}',
                icon: Icons.shopping_bag,
                color: AppColors.primary,
                subtitle: '${orderProvider.pendingOrdersCount} Pending',
              ),
              StatCardWidget(
                title: 'Total Products',
                value: '${productProvider.products.length}',
                icon: Icons.inventory_2,
                color: Colors.purple,
                subtitle: '${productProvider.lowStockProducts.length} Low Stock',
              ),
              StatCardWidget(
                title: 'Registered Users',
                value: '${userProvider.totalUsersCount}',
                icon: Icons.people,
                color: Colors.orange,
                subtitle: 'Active customers',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Secondary Row Indicators
          const Text(
            'Stock & Order Status Alerts',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCardWidget(
                  title: 'Pending Orders',
                  value: '${orderProvider.pendingOrdersCount}',
                  icon: Icons.hourglass_top,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatCardWidget(
                  title: 'Delivered',
                  value: '${orderProvider.completedOrdersCount}',
                  icon: Icons.check_circle,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Low Stock Alert Banner Card
          if (productProvider.lowStockProducts.isNotEmpty)
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Text(
                            '${productProvider.lowStockProducts.length} Products Low in Stock!',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.error,
                            ),
                          ),
                          Text(
                            'Check inventory and update product quantities.',
                            style: TextStyle(fontSize: 12, color: Colors.red.shade800),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
