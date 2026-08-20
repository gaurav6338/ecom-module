import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/storage_service.dart';
import '../services/mock_data_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = true;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin';
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _initAuth();
  }

  Future<void> _initAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userMap = await StorageService.getCurrentUser();
      if (userMap != null) {
        _currentUser = User.fromJson(userMap);
      } else {
        // Auto seed default Rishi login session if first launch
        _currentUser = MockDataService.demoUser;
        await StorageService.saveCurrentUser(_currentUser!.toJson());
      }
    } catch (e) {
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Pre-seed helper to login as Rishi Kumar or Admin
  Future<bool> login(String email, String password, {List<User>? allUsers}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600)); // Simulate async network call

    final users = allUsers ?? MockDataService.getInitialUsers();

    // Check credentials
    final emailClean = email.trim().toLowerCase();
    final foundUser = users.firstWhere(
      (u) => u.email.toLowerCase() == emailClean,
      orElse: () => User(
        id: '',
        name: '',
        email: '',
        phone: '',
        address: '',
        avatarUrl: '',
        role: '',
        registrationDate: DateTime.now(),
      ),
    );

    if (foundUser.id.isEmpty) {
      _errorMessage = 'No user found with this email address.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (!foundUser.isActive) {
      _errorMessage = 'Your account has been deactivated by an Administrator.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Demo password rules:
    // Rishi: rishi123 | Admin: admin123 | Default fallback: password
    bool isPasswordValid = false;
    if (emailClean == 'rishi@gmail.com' && password == 'rishi123') {
      isPasswordValid = true;
    } else if (emailClean == 'admin@gmail.com' && password == 'admin123') {
      isPasswordValid = true;
    } else if (password.length >= 6) {
      isPasswordValid = true;
    }

    if (!isPasswordValid) {
      _errorMessage = 'Invalid password. Please check your credentials.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _currentUser = foundUser;
    await StorageService.saveCurrentUser(_currentUser!.toJson());
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final newUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: email.trim().toLowerCase(),
      phone: '+91 98000 00000',
      address: 'Add your shipping address in Profile',
      avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400&auto=format&fit=crop&q=80',
      role: 'user',
      registrationDate: DateTime.now(),
      isActive: true,
    );

    _currentUser = newUser;
    await StorageService.saveCurrentUser(_currentUser!.toJson());
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> updateCurrentUser(User updatedUser) async {
    _currentUser = updatedUser;
    await StorageService.saveCurrentUser(_currentUser!.toJson());
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    await StorageService.saveCurrentUser(null);
    notifyListeners();
  }
}
