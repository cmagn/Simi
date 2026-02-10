import 'package:flutter/material.dart';
import 'package:flutter_simi/models/user.dart';
import 'package:flutter_simi/services/api_services.dart';

class UserController with ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;
  String _error = '';
  
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String get error => _error;
  
  Future<void> loadUsers() async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      _users = await ApiService.getUsers();
      _error = '';
    } catch (e) {
      _error = e.toString();
      _users = [];
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<bool> addUser(User user) async {
    try {
      final newUser = await ApiService.createUser(user);
      _users.add(newUser);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> updateUser(User user) async {
    try {
      final updatedUser = await ApiService.updateUser(user.id!, user);
      final index = _users.indexWhere((c) => c.id == user.id);
      if (index != -1) {
        _users[index] = updatedUser;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> deleteUser(int id) async {
    try {
      await ApiService.deleteUser(id);
      _users.removeWhere((user) => user.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}