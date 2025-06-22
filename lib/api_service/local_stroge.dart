// local_stroge.dart
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final _storage = GetStorage();

  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_data';
  static const _rememberMeKey = 'remember_me';
  static const _credentialsKey = 'user_credentials';
  static const _miningEndTimeKey = 'mining_end_time';
  static const _miningRewardKey = 'mining_reward';

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

  static Future<void> setRememberMe(bool value) async {
    await _storage.write(_rememberMeKey, value);
  }

  static bool getRememberMe() {
    return _storage.read(_rememberMeKey) ?? false;
  }

  static Future<void> saveCredentials(String email, String password) async {
    if (getRememberMe()) {
      await _storage.write(_credentialsKey, {
        'email': email,
        'password': password,
      });
    } else {
      await _storage.remove(_credentialsKey);
    }
  }

  static Map<String, dynamic>? getCredentials() {
    return _storage.read(_credentialsKey);
  }

  static Future<void> clear() async {
    await _storage.erase();
  }

  // Update local_stroge.dart
  static String _getMiningKey(String suffix) {
    final userId = getUser()?['id']?.toString() ?? 'unknown';
    return 'mining_${userId}_$suffix';
  }

  static Future<void> saveMiningData(DateTime endTime, {String? reward}) async {
    final userId = getUser()?['id']?.toString();
    if (userId == null) return;

    await _storage.write(_getMiningKey('end_time'), endTime.toIso8601String());
    if (reward != null) {
      await _storage.write(_getMiningKey('reward'), reward);
    }
  }

  static DateTime? getMiningEndTime() {
    final userId = getUser()?['id']?.toString();
    if (userId == null) return null;

    final timeString = _storage.read(_getMiningKey('end_time'));
    return timeString != null ? DateTime.parse(timeString) : null;
  }

  static String? getMiningReward() {
    final userId = getUser()?['id']?.toString();
    if (userId == null) return null;

    return _storage.read(_getMiningKey('reward'));
  }

  static Future<void> clearMiningData() async {
    final userId = getUser()?['id']?.toString();
    if (userId == null) return;

    await _storage.remove(_getMiningKey('end_time'));
    await _storage.remove(_getMiningKey('reward'));
  }

// Add this method to clear all mining data when user logs out
  static Future<void> clearAllMiningData() async {
    final keys = _storage.getKeys();
    for (var key in keys) {
      if (key.startsWith('mining_')) {
        await _storage.remove(key);
      }
    }
  }
}