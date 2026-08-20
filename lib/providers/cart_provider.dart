import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/storage_service.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  String? _appliedCoupon;
  double _couponDiscountPercentage = 0.0;

  List<CartItem> get items => _items;
  String? get appliedCoupon => _appliedCoupon;
  double get couponDiscountPercentage => _couponDiscountPercentage;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  CartProvider() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    try {
      final cached = await StorageService.getCart();
      if (cached != null) {
        _items = cached.map((json) => CartItem.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> _saveCart() async {
    final listJson = _items.map((i) => i.toJson()).toList();
    await StorageService.saveCart(listJson);
  }

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discountAmount => subtotal * (_couponDiscountPercentage / 100.0);

  double get tax => (subtotal - discountAmount) * 0.05; // 5% GST

  double get shippingFee {
    if (_items.isEmpty) return 0.0;
    return subtotal > 2000 ? 0.0 : 100.0; // Free shipping over ₹2000
  }

  double get totalAmount => (subtotal - discountAmount) + tax + shippingFee;

  bool applyCoupon(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'DISCOUNT20' || cleanCode == 'RISHI20') {
      _appliedCoupon = cleanCode;
      _couponDiscountPercentage = 20.0;
      notifyListeners();
      return true;
    } else if (cleanCode == 'WELCOME10') {
      _appliedCoupon = cleanCode;
      _couponDiscountPercentage = 10.0;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _appliedCoupon = null;
    _couponDiscountPercentage = 0.0;
    notifyListeners();
  }

  void addToCart(Product product, {String size = 'M', String color = 'Default', int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) =>
        item.product.id == product.id &&
        item.selectedSize == size &&
        item.selectedColor == color);

    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        product: product,
        selectedSize: size,
        selectedColor: color,
        quantity: quantity,
      ));
    }

    _saveCart();
    notifyListeners();
  }

  void updateQuantity(int index, int delta) {
    if (index >= 0 && index < _items.length) {
      _items[index].quantity += delta;
      if (_items[index].quantity <= 0) {
        _items.removeAt(index);
      }
      _saveCart();
      notifyListeners();
    }
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      _saveCart();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _appliedCoupon = null;
    _couponDiscountPercentage = 0.0;
    _saveCart();
    notifyListeners();
  }
}
