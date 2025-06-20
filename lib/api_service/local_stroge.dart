import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final _storage = GetStorage();

  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_data';

  static Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  static String? getToken() {
    return _storage.read(_tokenKey);
  }

  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _storage.write(_userKey, user);
  }

  static Map<String, dynamic>? getUser() {
    return _storage.read(_userKey);
  }

  static Future<void> clear() async {
    await _storage.erase();
  }
}