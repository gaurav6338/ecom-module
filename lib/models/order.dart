import 'cart_item.dart';

class OrderTimelineStep {
  final String status;
  final DateTime timestamp;
  final String description;
  final bool isCompleted;

  OrderTimelineStep({
    required this.status,
    required this.timestamp,
    required this.description,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
      'isCompleted': isCompleted,
    };
  }

  factory OrderTimelineStep.fromJson(Map<String, dynamic> json) {
    return OrderTimelineStep(
      status: json['status'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      description: json['description'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class Order {
  final String id;
  final String userId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String shippingAddress;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double shippingFee;
  final double discountAmount;
  final double totalAmount;
  final String paymentMethod;
  final String paymentStatus; // 'Paid', 'Pending', 'COD'
  String orderStatus; // 'Pending', 'Confirmed', 'Processing', 'Shipped', 'Delivered'
  final DateTime createdAt;
  List<OrderTimelineStep> timelineHistory;

  Order({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.shippingAddress,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shippingFee,
    required this.discountAmount,
    required this.totalAmount,
    required this.paymentMethod,
    this.paymentStatus = 'Paid',
    this.orderStatus = 'Pending',
    required this.createdAt,
    List<OrderTimelineStep>? timelineHistory,
  }) : timelineHistory = timelineHistory ?? _generateDefaultTimeline(createdAt, orderStatus);

  static List<OrderTimelineStep> _generateDefaultTimeline(DateTime createdAt, String currentStatus) {
    final List<String> statuses = [
      'Pending',
      'Confirmed',
      'Processing',
      'Shipped',
      'Delivered'
    ];

    int currentIndex = statuses.indexOf(currentStatus);
    if (currentIndex == -1) currentIndex = 0;

    return [
      OrderTimelineStep(
        status: 'Pending',
        timestamp: createdAt,
        description: 'Order placed successfully.',
        isCompleted: currentIndex >= 0,
      ),
      OrderTimelineStep(
        status: 'Confirmed',
        timestamp: createdAt.add(const Duration(minutes: 15)),
        description: 'Seller has confirmed your order.',
        isCompleted: currentIndex >= 1,
      ),
      OrderTimelineStep(
        status: 'Processing',
        timestamp: createdAt.add(const Duration(hours: 2)),
        description: 'Items packed and prepared for shipment.',
        isCompleted: currentIndex >= 2,
      ),
      OrderTimelineStep(
        status: 'Shipped',
        timestamp: createdAt.add(const Duration(hours: 6)),
        description: 'Package handed over to courier partner.',
        isCompleted: currentIndex >= 3,
      ),
      OrderTimelineStep(
        status: 'Delivered',
        timestamp: createdAt.add(const Duration(days: 2)),
        description: 'Package delivered to shipping address.',
        isCompleted: currentIndex >= 4,
      ),
    ];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'shippingAddress': shippingAddress,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'shippingFee': shippingFee,
      'discountAmount': discountAmount,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      'createdAt': createdAt.toIso8601String(),
      'timelineHistory': timelineHistory.map((e) => e.toJson()).toList(),
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    DateTime date = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now();
    String status = json['orderStatus'] ?? 'Pending';

    return Order(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      customerName: json['customerName'] ?? '',
      customerEmail: json['customerEmail'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      shippingAddress: json['shippingAddress'] ?? '',
      items: json['items'] != null
          ? (json['items'] as List).map((i) => CartItem.fromJson(i)).toList()
          : [],
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      shippingFee: (json['shippingFee'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] ?? 'Credit Card',
      paymentStatus: json['paymentStatus'] ?? 'Paid',
      orderStatus: status,
      createdAt: date,
      timelineHistory: json['timelineHistory'] != null
          ? (json['timelineHistory'] as List)
              .map((t) => OrderTimelineStep.fromJson(t))
              .toList()
          : _generateDefaultTimeline(date, status),
    );
  }
}
