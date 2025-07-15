import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/custom_snackbar.dart';
import 'local_stroge.dart';

class ApiService {
  final dio.Dio _dio = dio.Dio();
  // final String _baseUrl = 'https://ovoride.girdonawah.com/api';
  final String _baseUrl = 'https://gnetwork.pro/api';
  // final String _baseUrl = 'https://clone.gnetwork.pro/api';

  // Helper method for handling errors consistently
  void _handleError(dio.DioException e) {
    String errorMessage = 'Something went wrong. Please try again.';

    if (e.response != null && e.response!.data != null) {
      final responseData = e.response!.data;

      // Handle validation errors
      if (responseData is Map && responseData.containsKey('errors')) {
        final errors = responseData['errors'] as Map<String, dynamic>;
        if (errors.isNotEmpty) {
          final firstErrorKey = errors.keys.first;
          final firstErrorList = errors[firstErrorKey] as List;
          if (firstErrorList.isNotEmpty) {
            errorMessage = firstErrorList.first.toString();
          }
        }
      }
      // Handle general error message
      else if (responseData is Map && responseData.containsKey('message')) {
        errorMessage = responseData['message'];
      }
    }

    CustomSnackBar.error(errorMessage, title: 'Error');
  }

  // Helper method for authenticated requests
  Future<dio.Response?> _authenticatedRequest({
    required String method,
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final token = LocalStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      return await _dio.request(
        '$_baseUrl/$endpoint',
        data: data,
        queryParameters: queryParameters,
        options: dio.Options(
          method: method,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
    } on dio.DioException catch (e) {
      _handleError(e);
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: const Color(0xFFE53935),
        colorText: Colors.white,
      );
      return null;
    }
  }

  // Helper method for unauthenticated requests
  Future<dio.Response?> _unauthenticatedRequest({
    required String method,
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.request(
        '$_baseUrl/$endpoint',
        data: data,
        queryParameters: queryParameters,
        options: dio.Options(
          method: method,
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
    } on dio.DioException catch (e) {
      _handleError(e);
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: const Color(0xFFE53935),
        colorText: Colors.white,
      );
      return null;
    }
  }

  // Authentication endpoints
  Future<dio.Response?> registerUser({
    required String name,
    required String email,
    required String username,
    required String password,
    required String passwordConfirmation,
    String? referBy,
    required String recaptchaToken,
  }) async {
    final data = {
      'name': name,
      'email': email,
      'username': username,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'cf_turnstile_response': recaptchaToken,
      if (referBy != null && referBy.isNotEmpty) 'refer_by': referBy,
    };

    return await _unauthenticatedRequest(
      method: 'POST',
      endpoint: 'register',
      data: dio.FormData.fromMap(data),
    );
  }

  Future<dio.Response?> loginUser({
    required String emailOrUsername,
    required String password,
  }) async {
    return await _unauthenticatedRequest(
      method: 'POST',
      endpoint: 'login',
      data: dio.FormData.fromMap({
        'emailorusername': emailOrUsername,
        'password': password,
      }),
    );
  }

  Future<dio.Response?> logoutUser() async {
    final response = await _authenticatedRequest(
      method: 'POST',
      endpoint: 'logout',
    );

    if (response != null && response.statusCode == 200) {
      await LocalStorage.clear();
      // await LocalStorage.clearAllMiningData();
    }
    return response;
  }

  // Password recovery endpoints
  Future<dio.Response?> forgotPassword({required String email}) async {
    return await _unauthenticatedRequest(
      method: 'POST',
      endpoint: 'forgot-password',
      data: dio.FormData.fromMap({'email': email}),
    );
  }

  Future<dio.Response?> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String otp,
  }) async {
    return await _unauthenticatedRequest(
      method: 'POST',
      endpoint: 'reset-password',
      data: dio.FormData.fromMap({
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'otp': otp,
      }),
    );
  }

  Future<dio.Response?> resendOtp({required String email}) async {
    return await _unauthenticatedRequest(
      method: 'POST',
      endpoint: 'resend-otp',
      data: dio.FormData.fromMap({'email': email}),
    );
  }

  // Email verification
  Future<dio.Response?> sendEmailVerification() async {
    return await _authenticatedRequest(
      method: 'POST',
      endpoint: 'verify-email',
    );
  }

  Future<dio.Response?> verifyEmailWithOtp(String otp) async {
    return await _authenticatedRequest(
      method: 'POST',
      endpoint: 'verify-otp',
      data: {'otp': otp},
    );
  }

  // Mining endpoints
  Future<dio.Response?> startMining() async {
    return await _authenticatedRequest(
      method: 'POST',
      endpoint: 'start-mining',
    );
  }

  Future<dio.Response?> mineG() async {
    return await _authenticatedRequest(
      method: 'GET',
      endpoint: 'mine-g',
    );
  }

  // Wallet endpoints
  Future<dio.Response?> getWalletData() async {
    return await _authenticatedRequest(
      method: 'GET',
      endpoint: 'wallet',
    );
  }

  Future<dio.Response?> withdrawGCoin({required String amount}) async {
    return await _authenticatedRequest(
      method: 'POST',
      endpoint: 'withdraw-gcoin',
      data: dio.FormData.fromMap({
        'amount': amount,
      }),
    );
  }

  // User data endpoints
  Future<dio.Response?> getProfile() async {
    return await _authenticatedRequest(
      method: 'GET',
      endpoint: 'profile',
    );
  }

  Future<dio.Response?> getReferrals() async {
    return await _authenticatedRequest(
      method: 'GET',
      endpoint: 'referals',
    );
  }

  // Support endpoints
  Future<dio.Response?> getFAQs() async {
    return await _authenticatedRequest(
      method: 'GET',
      endpoint: 'faqs',
    );
  }

  Future<dio.Response?> getSupportArticles() async {
    return await _authenticatedRequest(
      method: 'GET',
      endpoint: 'support-article',
    );
  }

  Future<dio.Response?> checkTokenValidity() async {
    return await _authenticatedRequest(
      method: 'GET',
      endpoint: 'user',
    );
  }

  Future<dio.Response?> getDownlineTree(int userId) async {
    return await _authenticatedRequest(
      method: 'GET',
      endpoint: 'downline/$userId',
    );
  }

  Future<dio.Response?> searchUserByUsername(String username) async {
    return await _authenticatedRequest(
      method: 'GET',
      endpoint: 'search-user/$username',
    );
  }

  Future<dio.Response?> updateProfile({
    required String name,
    required String walletAddress,
    required String phone,
    required String walletType,
  }) async {
    return await _authenticatedRequest(
      method: 'POST',
      endpoint: 'update-profile',
      data: dio.FormData.fromMap({
        'name': name,
        'wallet_address': walletAddress,
        'phone': phone,
        'wallet_type': walletType,
      }),
    );
  }
}