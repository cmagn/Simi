import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.100:3000/api';
  static const String usersEndpoint = '$baseUrl/users';
  
  static Future<List<User>> getUsers() async {
    try {
      final response = await http.get(Uri.parse(usersEndpoint));
      
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((user) => User.fromJson(user)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }
  
  static Future<User> getUser(int id) async {
    final response = await http.get(Uri.parse('$usersEndpoint/$id'));
    
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }
  
  static Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse(usersEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }
  
  static Future<User> updateUser(int id, User user) async {
    final response = await http.put(
      Uri.parse('$usersEndpoint/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }
  
  static Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$usersEndpoint/$id'));
    
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }
}