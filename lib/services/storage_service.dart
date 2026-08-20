import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyCurrentUser = 'current_user';
  static const String _keyProducts = 'products_data';
  static const String _keyUsers = 'users_data';
  static const String _keyOrders = 'orders_data';
  static const String _keyCart = 'cart_data';
  static const String _keyWishlist = 'wishlist_data';
  static const String _keyAddresses = 'addresses_data';
  static const String _keyTheme = 'is_dark_theme';

  // Session User
  static Future<void> saveCurrentUser(Map<String, dynamic>? userJson) async {
    final prefs = await SharedPreferences.getInstance();
    if (userJson == null) {
      await prefs.remove(_keyCurrentUser);
    } else {
      await prefs.setString(_keyCurrentUser, jsonEncode(userJson));
    }
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_keyCurrentUser);
    if (str != null && str.isNotEmpty) {
      return jsonDecode(str);
    }
    return null;
  }

  // Products
  static Future<void> saveProducts(List<Map<String, dynamic>> productsJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProducts, jsonEncode(productsJson));
  }

  static Future<List<Map<String, dynamic>>?> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_keyProducts);
    if (str != null && str.isNotEmpty) {
      final List parsed = jsonDecode(str);
      return parsed.cast<Map<String, dynamic>>();
    }
    return null;
  }

  // Users
  static Future<void> saveUsers(List<Map<String, dynamic>> usersJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsers, jsonEncode(usersJson));
  }

  static Future<List<Map<String, dynamic>>?> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_keyUsers);
    if (str != null && str.isNotEmpty) {
      final List parsed = jsonDecode(str);
      return parsed.cast<Map<String, dynamic>>();
    }
    return null;
  }

  // Orders
  static Future<void> saveOrders(List<Map<String, dynamic>> ordersJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyOrders, jsonEncode(ordersJson));
  }

  static Future<List<Map<String, dynamic>>?> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_keyOrders);
    if (str != null && str.isNotEmpty) {
      final List parsed = jsonDecode(str);
      return parsed.cast<Map<String, dynamic>>();
    }
    return null;
  }

  // Cart
  static Future<void> saveCart(List<Map<String, dynamic>> cartJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCart, jsonEncode(cartJson));
  }

  static Future<List<Map<String, dynamic>>?> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_keyCart);
    if (str != null && str.isNotEmpty) {
      final List parsed = jsonDecode(str);
      return parsed.cast<Map<String, dynamic>>();
    }
    return null;
  }

  // Wishlist
  static Future<void> saveWishlist(List<String> productIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyWishlist, productIds);
  }

  static Future<List<String>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyWishlist) ?? [];
  }

  // Theme
  static Future<void> saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTheme, isDark);
  }

  static Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTheme) ?? false;
  }
}
