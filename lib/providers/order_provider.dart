import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/storage_service.dart';
import '../services/mock_data_service.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = true;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  OrderProvider() {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final cached = await StorageService.getOrders();
      if (cached != null && cached.isNotEmpty) {
        _orders = cached.map((json) => Order.fromJson(json)).toList();
      } else {
        _orders = MockDataService.getInitialOrders();
        await _saveToStorage();
      }
    } catch (e) {
      _orders = MockDataService.getInitialOrders();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveToStorage() async {
    final listJson = _orders.map((o) => o.toJson()).toList();
    await StorageService.saveOrders(listJson);
  }

  // Get orders for a specific user ID
  List<Order> getUserOrders(String userId) {
    return _orders.where((o) => o.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Analytics Metrics for Admin
  double get totalRevenue => _orders.fold(0.0, (sum, order) => sum + order.totalAmount);
  int get totalOrdersCount => _orders.length;
  int get pendingOrdersCount => _orders.where((o) => o.orderStatus == 'Pending' || o.orderStatus == 'Confirmed' || o.orderStatus == 'Processing').length;
  int get completedOrdersCount => _orders.where((o) => o.orderStatus == 'Delivered').length;

  // Place a new order
  Future<Order> createOrder({
    required String userId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required String shippingAddress,
    required dynamic items, // List<CartItem>
    required double subtotal,
    required double tax,
    required double shippingFee,
    required double discountAmount,
    required double totalAmount,
    required String paymentMethod,
  }) async {
    final newOrder = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      userId: userId,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      shippingAddress: shippingAddress,
      items: items,
      subtotal: subtotal,
      tax: tax,
      shippingFee: shippingFee,
      discountAmount: discountAmount,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      paymentStatus: paymentMethod == 'COD' ? 'Pending' : 'Paid',
      orderStatus: 'Pending',
      createdAt: DateTime.now(),
    );

    _orders.insert(0, newOrder);
    await _saveToStorage();
    notifyListeners();
    return newOrder;
  }

  // Admin status transition update
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final order = _orders[index];
      order.orderStatus = newStatus;

      // Update timeline step completion
      final List<String> statuses = [
        'Pending',
        'Confirmed',
        'Processing',
        'Shipped',
        'Delivered'
      ];
      int targetIndex = statuses.indexOf(newStatus);

      for (int i = 0; i < order.timelineHistory.length; i++) {
        if (i <= targetIndex) {
          order.timelineHistory[i] = OrderTimelineStep(
            status: order.timelineHistory[i].status,
            timestamp: order.timelineHistory[i].timestamp,
            description: order.timelineHistory[i].description,
            isCompleted: true,
          );
        } else {
          order.timelineHistory[i] = OrderTimelineStep(
            status: order.timelineHistory[i].status,
            timestamp: order.timelineHistory[i].timestamp,
            description: order.timelineHistory[i].description,
            isCompleted: false,
          );
        }
      }

      await _saveToStorage();
      notifyListeners();
    }
  }
}
