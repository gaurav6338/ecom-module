import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/rating_bar_widget.dart';
import '../../widgets/custom_button.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';
import '../checkout/checkout_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  late String _selectedSize;
  late String _selectedColor;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.product.sizes.isNotEmpty ? widget.product.sizes.first : 'M';
    _selectedColor = widget.product.colors.isNotEmpty ? widget.product.colors.first : 'Default';
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final isSaved = wishlistProvider.isInWishlist(widget.product.id);

    final imageList = widget.product.images.isNotEmpty
        ? widget.product.images
        : [widget.product.imageUrl];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.category),
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.favorite : Icons.favorite_border,
              color: isSaved ? AppColors.error : null,
            ),
            onPressed: () {
              wishlistProvider.toggleWishlist(widget.product.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isSaved
                        ? 'Removed from Wishlist'
                        : 'Added to Wishlist',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  // Main Image View
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AspectRatio(
                      aspectRatio: 1.2,
                      child: Image.network(
                        imageList[_selectedImageIndex],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.shopping_bag, size: 60, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Image Carousel Thumbnails
                  if (imageList.length > 1)
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageList.length,
                        itemBuilder: (context, index) {
                          final isSelected = index == _selectedImageIndex;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImageIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageList[index],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Title & Rating
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      RatingBarWidget(rating: widget.product.rating, iconSize: 16),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.product.rating}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${widget.product.reviewCount} reviews)',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                      const Spacer(),
                      // Stock Status
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.product.stock > 0
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.product.stock > 0
                              ? 'In Stock (${widget.product.stock})'
                              : 'Out of Stock',
                          style: TextStyle(
                            color: widget.product.stock > 0
                                ? Colors.green.shade800
                                : Colors.red.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Pricing Section
                  Row(
                    crossAxisAlignment: CrossAlignment.end,
                    children: [
                      Text(
                        Formatters.formatCurrency(widget.product.price),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (widget.product.originalPrice > widget.product.price) ...[
                        Text(
                          Formatters.formatCurrency(widget.product.originalPrice),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            Formatters.formatDiscount(widget.product.discountPercentage),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.product.description,
                    style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                  ),
                  const SizedBox(height: 20),

                  // Color Variants
                  if (widget.product.colors.isNotEmpty) ...[
                    const Text(
                      'Select Color',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: widget.product.colors.map((color) {
                        final isSelected = color == _selectedColor;
                        return ChoiceChip(
                          label: Text(color),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : null,
                            fontWeight: isSelected ? FontWeight.bold : null,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedColor = color;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Size Variants
                  if (widget.product.sizes.isNotEmpty) ...[
                    const Text(
                      'Select Size',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: widget.product.sizes.map((size) {
                        final isSelected = size == _selectedSize;
                        return ChoiceChip(
                          label: Text(size),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : null,
                            fontWeight: isSelected ? FontWeight.bold : null,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedSize = size;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Quantity Selector
                  Row(
                    children: [
                      const Text(
                        'Quantity:',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Add to Cart',
                    isOutlined: true,
                    icon: Icons.add_shopping_cart,
                    onPressed: () {
                      cartProvider.addToCart(
                        widget.product,
                        size: _selectedSize,
                        color: _selectedColor,
                        quantity: _quantity,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added ${widget.product.name} to Cart'),
                          backgroundColor: AppColors.secondary,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Buy Now',
                    icon: Icons.flash_on,
                    onPressed: () {
                      cartProvider.addToCart(
                        widget.product,
                        size: _selectedSize,
                        color: _selectedColor,
                        quantity: _quantity,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
