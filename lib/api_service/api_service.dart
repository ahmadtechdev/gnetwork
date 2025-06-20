import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class ApiService {
  final  _dio = dio.Dio();

  Future<dio.Response?> registerUser({
    required String name,
    required String email,
    required String username,
    required String password,
    required String passwordConfirmation,
    String? referBy,
  }) async {
    try {
      var data = dio.FormData.fromMap({
        'name': name,
        'email': email,
        'username': username,
        'password': password,
        'password_confirmation': passwordConfirmation,
        if (referBy != null && referBy.isNotEmpty) 'refer_by': referBy,
      });

      final response = await _dio.post(
        'https://lightyellow-ape-562667.hostingersite.com/api/register',
        data: data,
      );

      return response;
    } on dio.DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Registration failed');
      return null;
    }
  }

  Future<dio.Response?> loginUser({
    required String emailOrUsername,
    required String password,
  }) async {
    try {
      var data = dio.FormData.fromMap({
        'emailorusername': emailOrUsername,
        'password': password,
      });

      final response = await _dio.post(
        'https://lightyellow-ape-562667.hostingersite.com/api/login',
        data: data,
      );

      return response;
    } on dio.DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Login failed');
      return null;
    }
  }
}