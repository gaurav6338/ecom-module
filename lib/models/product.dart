class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final double discountPercentage;
  final double rating;
  final int reviewCount;
  final int stock;
  final String category;
  final String imageUrl;
  final List<String> images;
  final List<String> sizes;
  final List<String> colors;
  final bool isFeatured;
  final bool isTrending;
  final bool isBestSeller;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.rating,
    required this.reviewCount,
    required this.stock,
    required this.category,
    required this.imageUrl,
    this.images = const [],
    this.sizes = const [],
    this.colors = const [],
    this.isFeatured = false,
    this.isTrending = false,
    this.isBestSeller = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'reviewCount': reviewCount,
      'stock': stock,
      'category': category,
      'imageUrl': imageUrl,
      'images': images,
      'sizes': sizes,
      'colors': colors,
      'isFeatured': isFeatured,
      'isTrending': isTrending,
      'isBestSeller': isBestSeller,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      stock: json['stock'] ?? 0,
      category: json['category'] ?? 'Electronics',
      imageUrl: json['imageUrl'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      sizes: json['sizes'] != null ? List<String>.from(json['sizes']) : [],
      colors: json['colors'] != null ? List<String>.from(json['colors']) : [],
      isFeatured: json['isFeatured'] ?? false,
      isTrending: json['isTrending'] ?? false,
      isBestSeller: json['isBestSeller'] ?? false,
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    double? discountPercentage,
    double? rating,
    int? reviewCount,
    int? stock,
    String? category,
    String? imageUrl,
    List<String>? images,
    List<String>? sizes,
    List<String>? colors,
    bool? isFeatured,
    bool? isTrending,
    bool? isBestSeller,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      isFeatured: isFeatured ?? this.isFeatured,
      isTrending: isTrending ?? this.isTrending,
      isBestSeller: isBestSeller ?? this.isBestSeller,
    );
  }
}
