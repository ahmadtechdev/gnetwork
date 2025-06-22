// signin_controller.dart
import 'package:gcoin/api_service/api_service.dart';
import 'package:gcoin/api_service/local_stroge.dart';
import 'package:gcoin/screens/homescreen/homescreen.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final ApiService _apiService = ApiService();
  var isLoading = false.obs;
  var rememberMe = LocalStorage.getRememberMe().obs;

  Future<void> loginUser({
    required String emailOrUsername,
    required String password,
  }) async {
    try {
      isLoading(true);

      // Save remember me preference
      await LocalStorage.setRememberMe(rememberMe.value);

      final response = await _apiService.loginUser(
        emailOrUsername: emailOrUsername,
        password: password,
      );

      if (response != null && response.data['success'] == true) {
        await LocalStorage.saveToken(response.data['data']['token']);
        await LocalStorage.saveUser(response.data['data']['user']);

        // Save credentials if remember me is checked
        if (rememberMe.value) {
          await LocalStorage.saveCredentials(emailOrUsername, password);
        } else {
          await LocalStorage.saveCredentials('', ''); // Clear credentials
        }

        Get.offAll(() => PiNetworkHomeScreen());
      }
    } finally {
      isLoading(false);
    }
  }
}