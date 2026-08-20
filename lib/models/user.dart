class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String avatarUrl;
  final String role; // 'user' or 'admin'
  final DateTime registrationDate;
  final bool isActive;
  final int orderCount;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.avatarUrl,
    required this.role,
    required this.registrationDate,
    this.isActive = true,
    this.orderCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'avatarUrl': avatarUrl,
      'role': role,
      'registrationDate': registrationDate.toIso8601String(),
      'isActive': isActive,
      'orderCount': orderCount,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      role: json['role'] ?? 'user',
      registrationDate: json['registrationDate'] != null
          ? DateTime.parse(json['registrationDate'])
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
      orderCount: json['orderCount'] ?? 0,
    );
  }

  User copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? avatarUrl,
    String? role,
    bool? isActive,
    int? orderCount,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      registrationDate: registrationDate,
      isActive: isActive ?? this.isActive,
      orderCount: orderCount ?? this.orderCount,
    );
  }
}
