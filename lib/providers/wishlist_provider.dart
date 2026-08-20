import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class WishlistProvider extends ChangeNotifier {
  List<String> _wishlistProductIds = [];

  List<String> get wishlistProductIds => _wishlistProductIds;

  int get wishlistCount => _wishlistProductIds.length;

  WishlistProvider() {
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    _wishlistProductIds = await StorageService.getWishlist();
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _wishlistProductIds.contains(productId);
  }

  Future<void> toggleWishlist(String productId) async {
    if (_wishlistProductIds.contains(productId)) {
      _wishlistProductIds.remove(productId);
    } else {
      _wishlistProductIds.add(productId);
    }
    await StorageService.saveWishlist(_wishlistProductIds);
    notifyListeners();
  }
}
