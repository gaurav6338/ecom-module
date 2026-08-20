import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';

class ProductListScreen extends StatelessWidget {
  final bool isWishlistOnly;

  const ProductListScreen({super.key, this.isWishlistOnly = false});

  void _showFilterModal(BuildContext context, ProductProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Products',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          provider.resetFilters();
                          Navigator.pop(context);
                        },
                        child: const Text('Reset All'),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  // Price Slider
                  Text(
                    'Max Price: ${Formatters.formatCurrency(provider.maxPrice)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: provider.maxPrice,
                    min: 1000,
                    max: 150000,
                    divisions: 15,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setModalState(() {});
                      provider.setMaxPrice(val);
                    },
                  ),
                  const SizedBox(height: 10),
                  // In Stock Only Switch
                  SwitchListTile(
                    title: const Text('In Stock Only', style: TextStyle(fontWeight: FontWeight.w600)),
                    value: provider.inStockOnly,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setModalState(() {});
                      provider.setInStockOnly(val);
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    List<Product> displayList;
    if (isWishlistOnly) {
      displayList = productProvider.products
          .where((p) => wishlistProvider.isInWishlist(p.id))
          .toList();
    } else {
      displayList = productProvider.filteredProducts;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isWishlistOnly ? 'My Wishlist' : 'Products (${displayList.length})'),
        actions: [
          if (!isWishlistOnly)
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterModal(context, productProvider),
            ),
        ],
      ),
      body: Column(
        children: [
          if (!isWishlistOnly)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (q) => productProvider.setSearchQuery(q),
                      decoration: InputDecoration(
                        hintText: 'Search catalog...',
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        suffixIcon: productProvider.searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => productProvider.setSearchQuery(''),
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<SortOption>(
                    value: productProvider.sortBy,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.sort, color: AppColors.primary),
                    onChanged: (SortOption? newOption) {
                      if (newOption != null) {
                        productProvider.setSortBy(newOption);
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: SortOption.featured, child: Text('Featured')),
                      DropdownMenuItem(value: SortOption.priceLowToHigh, child: Text('Price: Low to High')),
                      DropdownMenuItem(value: SortOption.priceHighToLow, child: Text('Price: High to Low')),
                      DropdownMenuItem(value: SortOption.rating, child: Text('Top Rated')),
                    ],
                  ),
                ],
              ),
            ),
          Expanded(
            child: displayList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isWishlistOnly ? Icons.favorite_border : Icons.search_off,
                          size: 70,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isWishlistOnly
                              ? 'Your wishlist is empty'
                              : 'No products match your search or filters',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (!isWishlistOnly) ...[
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => productProvider.resetFilters(),
                            child: const Text('Clear Filters'),
                          ),
                        ],
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.70,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: displayList[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
