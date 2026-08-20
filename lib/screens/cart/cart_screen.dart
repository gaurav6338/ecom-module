import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/cart_item_widget.dart';
import '../../widgets/custom_button.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final bool isEmbedded;

  const CartScreen({super.key, this.isEmbedded = false});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    Widget content = cartProvider.items.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your Shopping Cart is Empty',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Explore products and add items to your cart',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          )
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return CartItemWidget(
                      item: item,
                      onIncrement: () => cartProvider.updateQuantity(index, 1),
                      onDecrement: () => cartProvider.updateQuantity(index, -1),
                      onRemove: () => cartProvider.removeFromCart(index),
                    );
                  },
                ),
              ),

              // Coupon & Order Summary Footer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Coupon Code Input
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _couponController,
                            decoration: InputDecoration(
                              hintText: 'Enter coupon code (e.g. DISCOUNT20)',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (_couponController.text.trim().isNotEmpty) {
                              final success = cartProvider.applyCoupon(_couponController.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? 'Coupon applied successfully! 20% OFF'
                                        : 'Invalid coupon code',
                                  ),
                                  backgroundColor: success ? AppColors.secondary : AppColors.error,
                                ),
                              );
                            }
                          },
                          child: const Text('Apply'),
                        ),
                      ],
                    ),

                    if (cartProvider.appliedCoupon != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Coupon (${cartProvider.appliedCoupon}) applied',
                            style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          GestureDetector(
                            onTap: () {
                              cartProvider.removeCoupon();
                              _couponController.clear();
                            },
                            child: const Text(
                              'Remove',
                              style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const Divider(height: 20),

                    // Price Summary Breakdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal:'),
                        Text(Formatters.formatCurrency(cartProvider.subtotal)),
                      ],
                    ),
                    if (cartProvider.discountAmount > 0) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Discount:', style: TextStyle(color: AppColors.secondary)),
                          Text('-${Formatters.formatCurrency(cartProvider.discountAmount)}',
                              style: const TextStyle(color: AppColors.secondary)),
                        ],
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tax (5% GST):'),
                        Text(Formatters.formatCurrency(cartProvider.tax)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery Fee:'),
                        Text(cartProvider.shippingFee == 0
                            ? 'FREE'
                            : Formatters.formatCurrency(cartProvider.shippingFee)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          Formatters.formatCurrency(cartProvider.totalAmount),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Proceed to Checkout',
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );

    if (widget.isEmbedded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Shopping Cart')),
        body: content,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: content,
    );
  }
}
