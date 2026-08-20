import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import 'rating_bar_widget.dart';
import '../screens/products/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isHorizontal;

  const ProductCard({
    super.key,
    required this.product,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final isSaved = wishlistProvider.isInWishlist(product.id);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: isHorizontal ? 160 : double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              // Product Image Header
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: isHorizontal ? 1.2 : 1.1,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.shopping_bag, size: 40, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  // Discount Badge
                  if (product.discountPercentage > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          Formatters.formatDiscount(product.discountPercentage),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // Wishlist Button
                  Positioned(
                    top: 6,
                    right: 6,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          isSaved ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: isSaved ? AppColors.error : Colors.grey.shade700,
                        ),
                        onPressed: () {
                          wishlistProvider.toggleWishlist(product.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isSaved
                                    ? 'Removed ${product.name} from Wishlist'
                                    : 'Added ${product.name} to Wishlist',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              // Details Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Text(
                            product.category,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              RatingBarWidget(rating: product.rating, iconSize: 12),
                              const SizedBox(width: 4),
                              Text(
                                '${product.rating}',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAlignment.start,
                            children: [
                              if (product.originalPrice > product.price)
                                Text(
                                  Formatters.formatCurrency(product.originalPrice),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              Text(
                                Formatters.formatCurrency(product.price),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              cartProvider.addToCart(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added ${product.name} to Cart'),
                                  backgroundColor: AppColors.secondary,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.add_shopping_cart,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
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
      ),
    );
  }
}
