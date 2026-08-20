import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/app_colors.dart';
import 'edit_profile_screen.dart';
import 'addresses_screen.dart';
import '../orders/user_orders_screen.dart';
import '../auth/login_screen.dart';
import '../admin/admin_navigation_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final user = authProvider.currentUser;
    final userOrders = user != null ? orderProvider.getUserOrders(user.id) : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: NetworkImage(
                        user?.avatarUrl ??
                            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400&auto=format&fit=crop&q=80',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Rishi Kumar',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? 'rishi@gmail.com',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: authProvider.isAdmin
                                  ? AppColors.primary.withOpacity(0.15)
                                  : AppColors.secondary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              authProvider.isAdmin ? 'Role: Admin' : 'Role: Customer',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: authProvider.isAdmin ? AppColors.primary : AppColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.primary),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // User Quick Stats Row
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Column(
                        children: [
                          Text(
                            '${userOrders.length}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text('My Orders', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Column(
                        children: [
                          Text(
                            '${wishlistProvider.wishlistCount}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.error,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text('Wishlist', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Column(
                        children: [
                          Text(
                            '${cartProvider.itemCount}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text('Cart Items', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Navigation List Items
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline, color: AppColors.primary),
                    title: const Text('Edit Profile'),
                    subtitle: const Text('Update name, phone & picture'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
                    title: const Text('My Orders'),
                    subtitle: const Text('Track and view order history'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UserOrdersScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.location_on_outlined, color: AppColors.primary),
                    title: const Text('Saved Addresses'),
                    subtitle: const Text('Manage shipping addresses'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddressesScreen()),
                      );
                    },
                  ),
                  if (authProvider.isAdmin) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.admin_panel_settings, color: AppColors.primary),
                      title: const Text('Switch to Admin Panel'),
                      subtitle: const Text('Manage products, users & analytics'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AdminNavigationScreen()),
                        );
                      },
                    ),
                  ],
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.error),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
                    ),
                    onTap: () async {
                      await authProvider.logout();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
