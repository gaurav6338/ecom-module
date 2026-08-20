import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/address.dart';
import '../services/storage_service.dart';
import '../services/mock_data_service.dart';

class UserProvider extends ChangeNotifier {
  List<User> _users = [];
  List<Address> _addresses = [];
  bool _isLoading = true;

  List<User> get users => _users;
  List<Address> get addresses => _addresses;
  bool get isLoading => _isLoading;

  int get totalUsersCount => _users.length;

  UserProvider() {
    _loadUsersAndAddresses();
  }

  Future<void> _loadUsersAndAddresses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final cachedUsers = await StorageService.getUsers();
      if (cachedUsers != null && cachedUsers.isNotEmpty) {
        _users = cachedUsers.map((json) => User.fromJson(json)).toList();
      } else {
        _users = MockDataService.getInitialUsers();
        await _saveUsersToStorage();
      }

      _addresses = MockDataService.getInitialAddresses();
    } catch (e) {
      _users = MockDataService.getInitialUsers();
      _addresses = MockDataService.getInitialAddresses();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveUsersToStorage() async {
    final listJson = _users.map((u) => u.toJson()).toList();
    await StorageService.saveUsers(listJson);
  }

  // Update Rishi Kumar or any user details
  Future<User?> updateUserProfile({
    required String userId,
    required String name,
    required String email,
    required String phone,
    required String address,
    String? avatarUrl,
  }) async {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      final updated = _users[index].copyWith(
        name: name,
        email: email,
        phone: phone,
        address: address,
        avatarUrl: avatarUrl ?? _users[index].avatarUrl,
      );
      _users[index] = updated;
      await _saveUsersToStorage();
      notifyListeners();
      return updated;
    }
    return null;
  }

  // Admin User Management
  Future<void> toggleUserRole(String userId) async {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      final currentRole = _users[index].role;
      final newRole = currentRole == 'admin' ? 'user' : 'admin';
      _users[index] = _users[index].copyWith(role: newRole);
      await _saveUsersToStorage();
      notifyListeners();
    }
  }

  Future<void> toggleUserActiveStatus(String userId) async {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      final currentStatus = _users[index].isActive;
      _users[index] = _users[index].copyWith(isActive: !currentStatus);
      await _saveUsersToStorage();
      notifyListeners();
    }
  }

  Future<void> deleteUser(String userId) async {
    _users.removeWhere((u) => u.id == userId);
    await _saveUsersToStorage();
    notifyListeners();
  }

  // Address Management
  void addAddress(Address address) {
    if (address.isDefault) {
      _addresses = _addresses.map((a) => a.copyWith(isDefault: false)).toList();
    }
    _addresses.add(address);
    notifyListeners();
  }

  void updateAddress(Address updatedAddress) {
    if (updatedAddress.isDefault) {
      _addresses = _addresses.map((a) => a.copyWith(isDefault: false)).toList();
    }
    final index = _addresses.indexWhere((a) => a.id == updatedAddress.id);
    if (index != -1) {
      _addresses[index] = updatedAddress;
      notifyListeners();
    }
  }

  void deleteAddress(String id) {
    _addresses.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  Address? get defaultAddress {
    try {
      return _addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }
}
