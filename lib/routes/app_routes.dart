import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/main_navigation_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/orders/user_orders_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/admin/admin_navigation_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String editProfile = '/edit-profile';
  static const String admin = '/admin';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        home: (context) => const MainNavigationScreen(),
        cart: (context) => const CartScreen(),
        checkout: (context) => const CheckoutScreen(),
        orders: (context) => const UserOrdersScreen(),
        editProfile: (context) => const EditProfileScreen(),
        admin: (context) => const AdminNavigationScreen(),
      };
}
