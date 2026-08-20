# 🛒 Flutter E-Commerce Application (MERN-Style Frontend-Only)

A production-level, fully interactive, frontend-only E-Commerce mobile application built using **Flutter, Dart, Provider, Material 3 Design, SharedPreferences, and FL Chart**.

## 🌟 Key Features

### 👤 Customer Experience
- **Demo User Profile**: Rishi Kumar (`rishi@gmail.com` / `rishi123`).
- **Bottom Navigation**: 5 main tabs (Home, Categories, Wishlist, Cart, Profile).
- **Home Screen**: Hero promotional banner, live search bar, category chips, featured products, trending items, discount section, recently viewed items.
- **Product Details**: Multi-image slider with indicators, rating stars, price & discount highlight, size & color selectors, stock indicator, quantity selector, Add to Cart, Buy Now, Wishlist button.
- **Cart & Checkout**: Item qty adjustment, coupon promo code handler (`DISCOUNT20`), payment simulation (Credit Card, UPI, COD), order summary breakdown.
- **Order Tracking**: Real-time visual timeline showing order progress (Pending → Confirmed → Processing → Shipped → Delivered).
- **User Profile Management**: Edit Rishi's name, email, phone, avatar, shipping addresses, dark theme toggle.

### 🛡️ Admin Management Panel
- **Demo Admin Profile**: Admin (`admin@gmail.com` / `admin123`).
- **Role Protection**: Strict navigation guards preventing non-admin access.
- **Dashboard Metrics**: 7 KPI summary cards (Products, Users, Orders, Revenue, Pending, Completed, Low Stock).
- **FL Chart Analytics**: Visual charts for revenue trends, category sales performance, user growth, order status breakdown.
- **Product Management**: Full CRUD (Add, Edit, Delete, Stock Update, Price/Discount Adjustment) with instant customer store synchronization.
- **User Management**: View user list, change roles (User <-> Admin), activate/deactivate accounts, delete users.
- **Order Management**: Update customer order status with single click; changes immediately reflect in Rishi Kumar's order tracking!

## 🚀 Technical Architecture
- **Language**: Dart & Flutter (Material 3)
- **State Management**: Provider (`ChangeNotifier`)
- **Persistence**: SharedPreferences local storage wrapper (`StorageService`)
- **Charts**: FL Chart (`fl_chart`)
