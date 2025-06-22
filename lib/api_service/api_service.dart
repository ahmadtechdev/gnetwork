import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import 'local_stroge.dart';

class ApiService {
  final _dio = dio.Dio();

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
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Registration failed',
      );
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

  // 1. Forgot Password - Send OTP to email
  Future<dio.Response?> forgotPassword({required String email}) async {
    try {
      var data = dio.FormData.fromMap({'email': email});

      final response = await _dio.post(
        'https://lightyellow-ape-562667.hostingersite.com/api/forgot-password',
        data: data,
      );

      return response;
    } on dio.DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to send OTP',
      );
      return null;
    }
  }

  // 2. Reset Password - Verify OTP and set new password
  Future<dio.Response?> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String otp,
  }) async {
    try {
      var data = dio.FormData.fromMap({
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'otp': otp,
      });

      final response = await _dio.post(
        'https://lightyellow-ape-562667.hostingersite.com/api/reset-password',
        data: data,
      );

      return response;
    } on dio.DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Password reset failed',
      );
      return null;
    }
  }

  // 3. Resend OTP - Send OTP again to email
  Future<dio.Response?> resendOtp({required String email}) async {
    try {
      var data = dio.FormData.fromMap({'email': email});

      final response = await _dio.post(
        'https://lightyellow-ape-562667.hostingersite.com/api/resend-otp',
        data: data,
      );

      return response;
    } on dio.DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to resend OTP',
      );
      return null;
    }
  }

  // Add this method to ApiService class
  Future<dio.Response?> logoutUser() async {
    try {
      final token = LocalStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.post(
        'https://lightyellow-ape-562667.hostingersite.com/api/logout',
        options: dio.Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        await LocalStorage.clear();
        await LocalStorage.clearAllMiningData(); // Add this line
      }
      return response;
    } on dio.DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Logout failed',
      );
      return null;
    }
  }

  // Add to api_service.dart
  Future<dio.Response?> getFAQs() async {
    try {
      final token = LocalStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        'https://lightyellow-ape-562667.hostingersite.com/api/faqs',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response;
    } on dio.DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to fetch FAQs',
      );
      return null;
    }
  }


  // Add to api_service.dart
  Future<dio.Response?> startMining() async {
    try {
      final token = LocalStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.post(
        'https://lightyellow-ape-562667.hostingersite.com/api/start-mining',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response;
    } on dio.DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to start mining',
      );
      return null;
    }
  }


  // Add to api_service.dart
  Future<dio.Response?> sendEmailVerification() async {
    try {
      final token = LocalStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.post(
        'https://lightyellow-ape-562667.hostingersite.com/api/verify-email',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response;
    } on dio.DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to send verification email',
      );
      return null;
    }
  }

  Future<dio.Response?> verifyEmailWithOtp(String otp) async {
    try {
      final token = LocalStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.post(
        'https://lightyellow-ape-562667.hostingersite.com/api/verify-email',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {'otp': otp},
      );

      return response;
    } on dio.DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to verify email',
      );
      return null;
    }
  }

  // Add to api_service.dart
  Future<dio.Response?> getSupportArticles() async {
    try {
      final token = LocalStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        'https://lightyellow-ape-562667.hostingersite.com/api/support-article',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response;
    } on dio.DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to fetch support articles',
      );
      return null;
    }
  }

  // Add to api_service.dart
  Future<dio.Response?> getProfile() async {
    try {
      final token = LocalStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        'https://lightyellow-ape-562667.hostingersite.com/api/profile',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response;
    } on dio.DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to fetch profile',
      );
      return null;
    }
  }

  // Add to api_service.dart
  Future<dio.Response?> mineG() async {
    try {
      final token = LocalStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        'https://lightyellow-ape-562667.hostingersite.com/api/mine-g',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response;
    } on dio.DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to mine G',
      );
      return null;
    }
  }

  // Add to api_service.dart
  Future<dio.Response?> getReferrals() async {
    try {
      final token = LocalStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        'https://lightyellow-ape-562667.hostingersite.com/api/referals',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response;
    } on dio.DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to fetch referrals',
      );
      return null;
    }
  }
}
