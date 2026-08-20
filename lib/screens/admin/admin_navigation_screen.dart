import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import 'admin_dashboard_tab.dart';
import 'admin_analytics_screen.dart';
import 'admin_products_screen.dart';
import 'admin_users_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_profile_screen.dart';
import '../home/main_navigation_screen.dart';

class AdminNavigationScreen extends StatefulWidget {
  const AdminNavigationScreen({super.key});

  @override
  State<AdminNavigationScreen> createState() => _AdminNavigationScreenState();
}

class _AdminNavigationScreenState extends State<AdminNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    AdminDashboardTab(),
    AdminAnalyticsScreen(),
    AdminProductsScreen(),
    AdminOrdersScreen(),
    AdminUsersScreen(),
    AdminProfileScreen(),
  ];

  final List<String> _titles = const [
    'Admin Overview',
    'Sales Analytics',
    'Product Catalog Management',
    'Customer Orders Management',
    'User Management',
    'Admin Profile',
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Role Guard Enforcement
    if (!authProvider.isAdmin) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.gpp_bad, size: 80, color: AppColors.error),
                const SizedBox(height: 16),
                const Text(
                  'Access Denied',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'You do not have Administrator permissions to access the Admin Panel.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                    );
                  },
                  child: const Text('Return to Customer Store'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront),
            tooltip: 'Customer View',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primaryDark,
              ),
              accountName: Text(
                authProvider.currentUser?.name ?? 'Admin',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              accountEmail: Text(authProvider.currentUser?.email ?? 'admin@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  authProvider.currentUser?.avatarUrl ??
                      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&auto=format&fit=crop&q=80',
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_outlined),
              title: const Text('Dashboard Overview'),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Sales & Analytics'),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: const Text('Products Management'),
              selected: _selectedIndex == 2,
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text('Orders Management'),
              selected: _selectedIndex == 3,
              onTap: () {
                setState(() => _selectedIndex = 3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('Users Management'),
              selected: _selectedIndex == 4,
              onTap: () {
                setState(() => _selectedIndex = 4);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined),
              title: const Text('Admin Profile'),
              selected: _selectedIndex == 5,
              onTap: () {
                setState(() => _selectedIndex = 5);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.store, color: AppColors.primary),
              title: const Text('Go to Customer Store'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex > 4 ? 0 : _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey.shade500,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Overview'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
        ],
      ),
    );
  }
}
