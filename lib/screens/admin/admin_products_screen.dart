import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../models/product.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';
import 'admin_product_form_screen.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    final filteredList = productProvider.products.where((p) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!p.name.toLowerCase().contains(q) && !p.category.toLowerCase().contains(q)) {
          return false;
        }
      }
      if (_selectedCategory != 'All' && p.category != _selectedCategory) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          // Search & Filter Header Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (q) => setState(() => _searchQuery = q),
                    decoration: const InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedCategory,
                  underline: const SizedBox(),
                  onChanged: (cat) {
                    if (cat != null) setState(() => _selectedCategory = cat);
                  },
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All Categories')),
                    DropdownMenuItem(value: 'Electronics', child: Text('Electronics')),
                    DropdownMenuItem(value: 'Fashion', child: Text('Fashion')),
                    DropdownMenuItem(value: 'Footwear', child: Text('Footwear')),
                    DropdownMenuItem(value: 'Audio', child: Text('Audio')),
                    DropdownMenuItem(value: 'Watches', child: Text('Watches')),
                    DropdownMenuItem(value: 'Home & Kitchen', child: Text('Home & Kitchen')),
                  ],
                ),
              ],
            ),
          ),

          // Products List Table
          Expanded(
            child: filteredList.isEmpty
                ? const Center(child: Text('No products found'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final product = filteredList[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          subtitle: Text(
                            '${product.category} • Stock: ${product.stock} • ${Formatters.formatCurrency(product.price)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: product.stock <= 5 ? AppColors.error : Colors.grey.shade600,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: AppColors.primary, size: 20),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AdminProductFormScreen(existingProduct: product),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Product'),
                                      content: Text('Are you sure you want to delete "${product.name}"?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                          onPressed: () {
                                            productProvider.deleteProduct(product.id);
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Deleted ${product.name}')),
                                            );
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Product', style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdminProductFormScreen()),
          );
        },
      ),
    );
  }
}
