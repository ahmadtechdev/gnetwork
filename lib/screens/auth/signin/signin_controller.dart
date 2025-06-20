import 'package:gcoin/api_service/api_service.dart';
import 'package:gcoin/api_service/local_stroge.dart';
import 'package:gcoin/screens/homescreen/homescreen.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final ApiService _apiService = ApiService();
  var isLoading = false.obs;
  var rememberMe = false.obs;

  Future<void> loginUser({
    required String emailOrUsername,
    required String password,
  }) async {
    try {
      isLoading(true);

      final response = await _apiService.loginUser(
        emailOrUsername: emailOrUsername,
        password: password,
      );

      if (response != null && response.data['success'] == true) {
        // Save token to local storage (you'll need to implement this)
        await LocalStorage.saveToken(response.data['data']['token']);
        await LocalStorage.saveUser(response.data['data']['user']);

        Get.snackbar('Success', response.data['message']);
        Get.to(
          () => PiNetworkHomeScreen(),
        ); // Navigate to home after successful login
      }
    } finally {
      isLoading(false);
    }
  }
}
