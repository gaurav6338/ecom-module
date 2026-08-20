import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/product_card.dart';
import '../../widgets/category_card.dart';
import '../../utils/app_colors.dart';
import '../products/product_list_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final categories = MockDataService.getInitialCategories();

    final userName = authProvider.currentUser?.name ?? 'Rishi Kumar';
    final userAvatar = authProvider.currentUser?.avatarUrl ??
        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400&auto=format&fit=crop&q=80';

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAlignment.start,
              children: [
                // Top Header Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(userAvatar),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAlignment.start,
                            children: [
                              Text(
                                'Hello, ${userName.split(' ')[0]} 👋',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Find your favorite products',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none_outlined),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No new notifications'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (query) {
                      if (query.trim().isNotEmpty) {
                        productProvider.setSearchQuery(query);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProductListScreen(),
                          ),
                        );
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Search laptops, sneakers, watches...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.tune, size: 20),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProductListScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Hero Promotional Banner Carousel
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20,
                        bottom: -20,
                        child: Icon(
                          Icons.shopping_bag,
                          size: 160,
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '🔥 SPECIAL SALE 30% OFF',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Upgrade Your Tech & Style',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Use coupon DISCOUNT20 at checkout',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Categories Row Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          productProvider.setSelectedCategory('All');
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ProductListScreen()),
                          );
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Horizontal Categories Scroll
                SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final isSelected = productProvider.selectedCategory == cat.name;
                      return CategoryCard(
                        category: cat,
                        isSelected: isSelected,
                        onTap: () {
                          productProvider.setSelectedCategory(cat.name);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ProductListScreen()),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Featured Products Horizontal List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Featured Products',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ProductListScreen()),
                          );
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: productProvider.featuredProducts.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.featuredProducts[index];
                      return ProductCard(product: product, isHorizontal: true);
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Trending Products Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Trending Deals 🔥',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ProductListScreen()),
                          );
                        },
                        child: const Text(
                          'More',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.70,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: productProvider.products.length > 4 ? 4 : productProvider.products.length,
                  itemBuilder: (context, index) {
                    final product = productProvider.products[index];
                    return ProductCard(product: product);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
