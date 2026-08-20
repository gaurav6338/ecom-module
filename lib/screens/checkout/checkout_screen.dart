import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'Credit Card';
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context);

    final currentUser = authProvider.currentUser;
    final defaultAddr = userProvider.defaultAddress;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            // Shipping Address Card
            const Text(
              'Shipping Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    const Icon(Icons.location_on, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Text(
                            defaultAddr?.recipientName ?? currentUser?.name ?? 'Rishi Kumar',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            defaultAddr?.fullAddress ?? currentUser?.address ?? '42 Lotus Heights, MG Road, Bengaluru',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            defaultAddr?.phone ?? currentUser?.phone ?? '+91 98765 43210',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Payment Method Selector
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Row(
                      children: [
                        Icon(Icons.credit_card, color: AppColors.primary),
                        SizedBox(width: 10),
                        Text('Credit / Debit Card'),
                      ],
                    ),
                    value: 'Credit Card',
                    groupValue: _selectedPaymentMethod,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
                  ),
                  RadioListTile<String>(
                    title: const Row(
                      children: [
                        Icon(Icons.account_balance_wallet, color: AppColors.secondary),
                        SizedBox(width: 10),
                        Text('UPI / Google Pay / PhonePe'),
                      ],
                    ),
                    value: 'UPI',
                    groupValue: _selectedPaymentMethod,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
                  ),
                  RadioListTile<String>(
                    title: const Row(
                      children: [
                        Icon(Icons.local_shipping, color: AppColors.warning),
                        SizedBox(width: 10),
                        Text('Cash on Delivery (COD)'),
                      ],
                    ),
                    value: 'COD',
                    groupValue: _selectedPaymentMethod,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Items Summary Card
            const Text(
              'Order Items',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: cartProvider.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.product.imageUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                Text(
                                  'Qty: ${item.quantity} x ${Formatters.formatCurrency(item.product.price)}',
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            Formatters.formatCurrency(item.totalPrice),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Order Totals Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
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
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Pay Amount:',
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            CustomButton(
              text: 'Place Order Now',
              isLoading: _isProcessing,
              icon: Icons.check_circle,
              onPressed: () async {
                setState(() => _isProcessing = true);
                await Future.delayed(const Duration(seconds: 1)); // Simulate payment processing

                final createdOrder = await orderProvider.createOrder(
                  userId: currentUser?.id ?? 'user_rishi_01',
                  customerName: currentUser?.name ?? 'Rishi Kumar',
                  customerEmail: currentUser?.email ?? 'rishi@gmail.com',
                  customerPhone: currentUser?.phone ?? '+91 98765 43210',
                  shippingAddress: defaultAddr?.fullAddress ?? currentUser?.address ?? '42 Lotus Heights, MG Road',
                  items: List.from(cartProvider.items),
                  subtotal: cartProvider.subtotal,
                  tax: cartProvider.tax,
                  shippingFee: cartProvider.shippingFee,
                  discountAmount: cartProvider.discountAmount,
                  totalAmount: cartProvider.totalAmount,
                  paymentMethod: _selectedPaymentMethod,
                );

                cartProvider.clearCart();

                if (!mounted) return;
                setState(() => _isProcessing = false);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderConfirmationScreen(order: createdOrder),
                  ),
                  (route) => route.isFirst,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
