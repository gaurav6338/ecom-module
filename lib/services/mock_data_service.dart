import '../models/user.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/address.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class MockDataService {
  // Initial Seed Demo Users
  static final User demoUser = User(
    id: 'user_rishi_01',
    name: 'Rishi Kumar',
    email: 'rishi@gmail.com',
    phone: '+91 98765 43210',
    address: '42 Lotus Heights, MG Road, Bengaluru, Karnataka - 560001',
    avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400&auto=format&fit=crop&q=80',
    role: 'user',
    registrationDate: DateTime.now().subtract(const Duration(days: 90)),
    isActive: true,
    orderCount: 3,
  );

  static final User demoAdmin = User(
    id: 'admin_01',
    name: 'Admin',
    email: 'admin@gmail.com',
    phone: '+91 99000 11223',
    address: 'Corporate Headquarters, Electronics City, Bengaluru - 560100',
    avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&auto=format&fit=crop&q=80',
    role: 'admin',
    registrationDate: DateTime.now().subtract(const Duration(days: 365)),
    isActive: true,
    orderCount: 0,
  );

  static List<User> getInitialUsers() => [demoUser, demoAdmin];

  // Categories
  static List<Category> getInitialCategories() => [
        Category(
          id: 'cat_electronics',
          name: 'Electronics',
          iconName: 'devices',
          imageUrl: 'https://images.unsplash.com/photo-1498049860654-af1a5c566876?w=500&auto=format&fit=crop&q=80',
          itemCount: 12,
        ),
        Category(
          id: 'cat_fashion',
          name: 'Fashion',
          iconName: 'checkroom',
          imageUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=500&auto=format&fit=crop&q=80',
          itemCount: 18,
        ),
        Category(
          id: 'cat_footwear',
          name: 'Footwear',
          iconName: 'steps',
          imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&auto=format&fit=crop&q=80',
          itemCount: 10,
        ),
        Category(
          id: 'cat_audio',
          name: 'Audio',
          iconName: 'headphones',
          imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&auto=format&fit=crop&q=80',
          itemCount: 8,
        ),
        Category(
          id: 'cat_watches',
          name: 'Watches',
          iconName: 'watch',
          imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&auto=format&fit=crop&q=80',
          itemCount: 6,
        ),
        Category(
          id: 'cat_home',
          name: 'Home & Kitchen',
          iconName: 'chair',
          imageUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=500&auto=format&fit=crop&q=80',
          itemCount: 15,
        ),
      ];

  // Saved Addresses for Rishi Kumar
  static List<Address> getInitialAddresses() => [
        Address(
          id: 'addr_1',
          label: 'Home',
          recipientName: 'Rishi Kumar',
          phone: '+91 98765 43210',
          street: '42 Lotus Heights, MG Road',
          city: 'Bengaluru',
          state: 'Karnataka',
          zipCode: '560001',
          isDefault: true,
        ),
        Address(
          id: 'addr_2',
          label: 'Office',
          recipientName: 'Rishi Kumar',
          phone: '+91 98765 43210',
          street: 'Tech Park, Tower B, 5th Floor, Outer Ring Rd',
          city: 'Bengaluru',
          state: 'Karnataka',
          zipCode: '560103',
          isDefault: false,
        ),
      ];

  // Initial Products
  static List<Product> getInitialProducts() => [
        Product(
          id: 'p_1',
          name: 'Pro Noise-Cancelling Headphones X1',
          description: 'Experience studio-grade acoustics with active noise cancellation, 40-hour battery life, plush memory foam ear cushions, and seamless Bluetooth 5.3 connectivity.',
          price: 14999.0,
          originalPrice: 19999.0,
          discountPercentage: 25.0,
          rating: 4.8,
          reviewCount: 342,
          stock: 45,
          category: 'Audio',
          imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&auto=format&fit=crop&q=80',
          images: [
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&auto=format&fit=crop&q=80',
            'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=800&auto=format&fit=crop&q=80',
            'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=800&auto=format&fit=crop&q=80',
          ],
          colors: ['Space Gray', 'Matte Black', 'Silver'],
          isFeatured: true,
          isTrending: true,
          isBestSeller: true,
        ),
        Product(
          id: 'p_2',
          name: 'Ultra Slim OLED Smart Watch Series 7',
          description: 'Track your fitness, heart rate, sleep quality, and SpO2 with dynamic AMOLED retina display, water resistance up to 50m, and GPS tracking.',
          price: 8999.0,
          originalPrice: 12999.0,
          discountPercentage: 30.0,
          rating: 4.7,
          reviewCount: 215,
          stock: 28,
          category: 'Watches',
          imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
          images: [
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
            'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=800&auto=format&fit=crop&q=80',
          ],
          colors: ['Midnight Black', 'Rose Gold', 'Ocean Blue'],
          sizes: ['40mm', '44mm'],
          isFeatured: true,
          isTrending: true,
        ),
        Product(
          id: 'p_3',
          name: 'Performance Air Athletic Sneakers',
          description: 'Engineered for high performance and daily comfort. High-breathability mesh upper with ultra-responsive cushioned midsole technology.',
          price: 4499.0,
          originalPrice: 6999.0,
          discountPercentage: 35.0,
          rating: 4.6,
          reviewCount: 512,
          stock: 60,
          category: 'Footwear',
          imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=80',
          images: [
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=80',
            'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=800&auto=format&fit=crop&q=80',
          ],
          colors: ['Crimson Red', 'Pure White', 'Stealth Black'],
          sizes: ['UK 7', 'UK 8', 'UK 9', 'UK 10'],
          isFeatured: true,
          isBestSeller: true,
        ),
        Product(
          id: 'p_4',
          name: 'Minimalist Premium Denim Jacket',
          description: 'Crafted from 100% organic cotton denim. Features tailored fit, durable antique brass buttons, and reinforced double stitching.',
          price: 3299.0,
          originalPrice: 4999.0,
          discountPercentage: 34.0,
          rating: 4.5,
          reviewCount: 189,
          stock: 14,
          category: 'Fashion',
          imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&auto=format&fit=crop&q=80',
          images: [
            'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&auto=format&fit=crop&q=80',
          ],
          colors: ['Washed Blue', 'Dark Indigo', 'Charcoal'],
          sizes: ['S', 'M', 'L', 'XL'],
          isTrending: true,
        ),
        Product(
          id: 'p_5',
          name: 'Pro Laptop M2 14-inch Super Retina',
          description: 'Unmatched speed with M2 Silicon chip, 16GB unified RAM, 512GB SSD, liquid retina display, and up to 18 hours battery life.',
          price: 119999.0,
          originalPrice: 134999.0,
          discountPercentage: 11.0,
          rating: 4.9,
          reviewCount: 420,
          stock: 15,
          category: 'Electronics',
          imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&auto=format&fit=crop&q=80',
          images: [
            'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&auto=format&fit=crop&q=80',
            'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=800&auto=format&fit=crop&q=80',
          ],
          colors: ['Space Gray', 'Silver'],
          isFeatured: true,
          isBestSeller: true,
        ),
        Product(
          id: 'p_6',
          name: 'Ergonomic Mesh Executive Office Chair',
          description: 'High-back mesh design with adjustable lumbar support, 3D armrests, synchro-tilt mechanism, and heavy-duty chrome base.',
          price: 9999.0,
          originalPrice: 14999.0,
          discountPercentage: 33.0,
          rating: 4.4,
          reviewCount: 167,
          stock: 8, // Low stock alert
          category: 'Home & Kitchen',
          imageUrl: 'https://images.unsplash.com/photo-1580481072645-022f9a6d83d0?w=800&auto=format&fit=crop&q=80',
          images: [
            'https://images.unsplash.com/photo-1580481072645-022f9a6d83d0?w=800&auto=format&fit=crop&q=80',
          ],
          colors: ['Black', 'Slate Gray'],
          isTrending: true,
        ),
        Product(
          id: 'p_7',
          name: 'Wireless Ergonomic Vertical Mouse',
          description: 'Reduces wrist strain with natural handshake angle, quiet click buttons, adjustable DPI up to 4000, and dual Bluetooth/USB connection.',
          price: 1999.0,
          originalPrice: 2999.0,
          discountPercentage: 33.0,
          rating: 4.6,
          reviewCount: 310,
          stock: 50,
          category: 'Electronics',
          imageUrl: 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?w=800&auto=format&fit=crop&q=80',
          images: [
            'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?w=800&auto=format&fit=crop&q=80',
          ],
          colors: ['Graphite', 'Off-White'],
          isTrending: true,
        ),
        Product(
          id: 'p_8',
          name: 'Stainless Steel Insulated Smart Flask 750ml',
          description: 'Keeps drinks hot for 12 hours or cold for 24 hours. LED touch screen displays real-time liquid temperature.',
          price: 1299.0,
          originalPrice: 1999.0,
          discountPercentage: 35.0,
          rating: 4.7,
          reviewCount: 420,
          stock: 3, // Low stock alert
          category: 'Home & Kitchen',
          imageUrl: 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=800&auto=format&fit=crop&q=80',
          images: [
            'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=800&auto=format&fit=crop&q=80',
          ],
          colors: ['Matte Black', 'Emerald Green', 'Electric Blue'],
          isFeatured: false,
        ),
      ];

  // Initial Sample Orders for Rishi Kumar
  static List<Order> getInitialOrders() {
    DateTime now = DateTime.now();

    return [
      Order(
        id: 'ORD-98421',
        userId: 'user_rishi_01',
        customerName: 'Rishi Kumar',
        customerEmail: 'rishi@gmail.com',
        customerPhone: '+91 98765 43210',
        shippingAddress: '42 Lotus Heights, MG Road, Bengaluru, Karnataka - 560001',
        items: [
          CartItem(
            product: getInitialProducts()[0], // Pro Noise-Cancelling Headphones
            selectedColor: 'Matte Black',
            quantity: 1,
          ),
          CartItem(
            product: getInitialProducts()[2], // Athletic Sneakers
            selectedSize: 'UK 9',
            selectedColor: 'Pure White',
            quantity: 1,
          ),
        ],
        subtotal: 19498.0,
        tax: 975.0,
        shippingFee: 0.0,
        discountAmount: 2000.0,
        totalAmount: 18473.0,
        paymentMethod: 'Credit Card',
        paymentStatus: 'Paid',
        orderStatus: 'Shipped',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Order(
        id: 'ORD-97510',
        userId: 'user_rishi_01',
        customerName: 'Rishi Kumar',
        customerEmail: 'rishi@gmail.com',
        customerPhone: '+91 98765 43210',
        shippingAddress: '42 Lotus Heights, MG Road, Bengaluru, Karnataka - 560001',
        items: [
          CartItem(
            product: getInitialProducts()[1], // Smart Watch
            selectedSize: '44mm',
            selectedColor: 'Midnight Black',
            quantity: 1,
          ),
        ],
        subtotal: 8999.0,
        tax: 450.0,
        shippingFee: 100.0,
        discountAmount: 500.0,
        totalAmount: 9049.0,
        paymentMethod: 'UPI (GPay)',
        paymentStatus: 'Paid',
        orderStatus: 'Delivered',
        createdAt: now.subtract(const Duration(days: 10)),
      ),
    ];
  }
}
