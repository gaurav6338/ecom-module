import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/storage_service.dart';
import '../services/mock_data_service.dart';

enum SortOption {
  featured,
  priceLowToHigh,
  priceHighToLow,
  rating,
  newest,
}

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  double _maxPrice = 150000.0;
  double _minRating = 0.0;
  bool _inStockOnly = false;
  SortOption _sortBy = SortOption.featured;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  double get maxPrice => _maxPrice;
  double get minRating => _minRating;
  bool get inStockOnly => _inStockOnly;
  SortOption get sortBy => _sortBy;

  ProductProvider() {
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final cached = await StorageService.getProducts();
      if (cached != null && cached.isNotEmpty) {
        _products = cached.map((json) => Product.fromJson(json)).toList();
      } else {
        _products = MockDataService.getInitialProducts();
        await _saveToStorage();
      }
    } catch (e) {
      _products = MockDataService.getInitialProducts();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveToStorage() async {
    final listJson = _products.map((p) => p.toJson()).toList();
    await StorageService.saveProducts(listJson);
  }

  // Filtered & Sorted Products List for Display
  List<Product> get filteredProducts {
    return _products.where((product) {
      // Search
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesName = product.name.toLowerCase().contains(query);
        final matchesDesc = product.description.toLowerCase().contains(query);
        final matchesCat = product.category.toLowerCase().contains(query);
        if (!matchesName && !matchesDesc && !matchesCat) return false;
      }

      // Category
      if (_selectedCategory != 'All' && product.category != _selectedCategory) {
        return false;
      }

      // Max Price
      if (product.price > _maxPrice) {
        return false;
      }

      // Min Rating
      if (product.rating < _minRating) {
        return false;
      }

      // In Stock
      if (_inStockOnly && product.stock <= 0) {
        return false;
      }

      return true;
    }).toList()
      ..sort((a, b) {
        switch (_sortBy) {
          case SortOption.priceLowToHigh:
            return a.price.compareTo(b.price);
          case SortOption.priceHighToLow:
            return b.price.compareTo(a.price);
          case SortOption.rating:
            return b.rating.compareTo(a.rating);
          case SortOption.newest:
            return b.id.compareTo(a.id);
          case SortOption.featured:
          default:
            if (a.isFeatured && !b.isFeatured) return -1;
            if (!a.isFeatured && b.isFeatured) return 1;
            return 0;
        }
      });
  }

  List<Product> get featuredProducts => _products.where((p) => p.isFeatured).toList();
  List<Product> get trendingProducts => _products.where((p) => p.isTrending).toList();
  List<Product> get bestSellers => _products.where((p) => p.isBestSeller).toList();
  List<Product> get discountedProducts => _products.where((p) => p.discountPercentage > 0).toList();
  List<Product> get lowStockProducts => _products.where((p) => p.stock > 0 && p.stock <= 10).toList();

  // Search & Filter setters
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setMaxPrice(double price) {
    _maxPrice = price;
    notifyListeners();
  }

  void setMinRating(double rating) {
    _minRating = rating;
    notifyListeners();
  }

  void setInStockOnly(bool value) {
    _inStockOnly = value;
    notifyListeners();
  }

  void setSortBy(SortOption option) {
    _sortBy = option;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _maxPrice = 150000.0;
    _minRating = 0.0;
    _inStockOnly = false;
    _sortBy = SortOption.featured;
    notifyListeners();
  }

  // Admin CRUD Methods
  Future<void> addProduct(Product newProduct) async {
    _products.insert(0, newProduct);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      await _saveToStorage();
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
    await _saveToStorage();
    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
