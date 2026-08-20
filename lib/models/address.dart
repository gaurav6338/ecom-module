class Address {
  final String id;
  final String label; // e.g. "Home", "Office"
  final String recipientName;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final bool isDefault;

  Address({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    this.isDefault = false,
  });

  String get fullAddress => '$street, $city, $state - $zipCode';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'recipientName': recipientName,
      'phone': phone,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'isDefault': isDefault,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? '',
      label: json['label'] ?? 'Home',
      recipientName: json['recipientName'] ?? '',
      phone: json['phone'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }

  Address copyWith({
    String? label,
    String? recipientName,
    String? phone,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    bool? isDefault,
  }) {
    return Address(
      id: id,
      label: label ?? this.label,
      recipientName: recipientName ?? this.recipientName,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
