class Category {
  final String id;
  final String name;
  final String iconName;
  final String imageUrl;
  final int itemCount;

  Category({
    required this.id,
    required this.name,
    required this.iconName,
    required this.imageUrl,
    this.itemCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'imageUrl': imageUrl,
      'itemCount': itemCount,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      iconName: json['iconName'] ?? 'shopping_bag',
      imageUrl: json['imageUrl'] ?? '',
      itemCount: json['itemCount'] ?? 0,
    );
  }
}
