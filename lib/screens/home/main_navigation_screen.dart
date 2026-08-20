import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../utils/app_colors.dart';
import 'home_tab.dart';
import 'categories_tab.dart';
import '../products/product_list_screen.dart';
import '../cart/cart_screen.dart';
import '../profile/profile_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _tabs = const [
    HomeTab(),
    CategoriesTab(),
    ProductListScreen(isWishlistOnly: true),
    CartScreen(isEmbedded: true),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey.shade500,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                label: Text('${wishlistProvider.wishlistCount}'),
                isLabelVisible: wishlistProvider.wishlistCount > 0,
                child: const Icon(Icons.favorite_border),
              ),
              activeIcon: Badge(
                label: Text('${wishlistProvider.wishlistCount}'),
                isLabelVisible: wishlistProvider.wishlistCount > 0,
                child: const Icon(Icons.favorite),
              ),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                label: Text('${cartProvider.itemCount}'),
                isLabelVisible: cartProvider.itemCount > 0,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              activeIcon: Badge(
                label: Text('${cartProvider.itemCount}'),
                isLabelVisible: cartProvider.itemCount > 0,
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
