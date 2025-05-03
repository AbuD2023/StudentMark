import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import 'api_service.dart';
import '../../config/constants.dart';
import 'dart:convert';

class AuthService {
  final ApiService _apiService;
  final FlutterSecureStorage _storage;

  AuthService(this._apiService, this._storage);

  Future<User?> login(String username, String password) async {
    try {
      final response = await _apiService.post(
        AppConstants.login,
        data: {
          'username': username,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        final token = response.data['token'];
        final user = User.fromJson(response.data['user']);

        await _storage.write(key: AppConstants.tokenKey, value: token);
        await _storage.write(
            key: AppConstants.userKey, value: user.toJson().toString());

        return user;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.userKey);
  }

  Future<User?> getCurrentUser() async {
    try {
      final userJson = await _storage.read(key: AppConstants.userKey);
      if (userJson != null) {
        return User.fromJson(json.decode(userJson));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: AppConstants.tokenKey);
    return token != null;
  }
}
