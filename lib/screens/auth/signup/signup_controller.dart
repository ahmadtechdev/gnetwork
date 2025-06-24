import 'package:gcoin/api_service/api_service.dart';
import 'package:gcoin/utils/custom_snackbar.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final ApiService _apiService = ApiService();
  var isLoading = false.obs;

  Future<void> registerUser({
    required String name,
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
    String? referBy,
  }) async {
    try {
      isLoading(true);
      
      final response = await _apiService.registerUser(
        name: name,
        email: email,
        username: username,
        password: password,
        passwordConfirmation: confirmPassword,
        referBy: referBy,
      );

      if (response != null && response.data['success'] == true) {
        // Get.snackbar('Success', response.data['message']);
        CustomSnackBar.success(response.data['message']);
        Get.offNamed('/sign_in'); // Navigate to sign in after successful registration
      }
    } finally {
      isLoading(false);
    }
  }
}