// profile_controller.dart
import 'package:gcoin/utils/custom_snackbar.dart';
import 'package:get/get.dart';

import '../../../api_service/api_service.dart';


class ProfileController extends GetxController {
  final ApiService _apiService = Get.put(ApiService());
  var isLoading = true.obs;
  var userProfile = <String, dynamic>{}.obs;
  var hideRealName = false.obs;
  var hideBalance = false.obs;
  var pushNotifications = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading(true);
      final response = await _apiService.getProfile();
      if (response != null && response.data['success'] == true) {
        userProfile.value = response.data['user'];
      }
    } finally {
      isLoading(false);
    }
  }

  String getInitials(String? name) {
    if (name == null || name.isEmpty) return 'US';
    final parts = name.split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  void toggleHideRealName(bool value) {
    hideRealName(value);
    // Get.snackbar(
    //   'Success',
    //   'Real name visibility updated',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
    //
    CustomSnackBar.success('Soon it will be workable');
  }

  void toggleHideBalance(bool value) {
    hideBalance(value);
    // Get.snackbar(
    //   'Success',
    //   'Balance visibility updated',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
    CustomSnackBar.success('Soon it will be workable');
  }

  void togglePushNotifications(bool value) {
    pushNotifications(value);
    // Get.snackbar(
    //   'Success',
    //   'Push notifications updated',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
    CustomSnackBar.success('Soon it will be workable');
  }

  void handleVerificationAction(String type) {
    // Get.snackbar(
    //   'Info',
    //   '$type verification functionality coming soon',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
    CustomSnackBar.success('$type verification functionality coming soon');
  }

  void handleAccountAction(String type) {
    // Get.snackbar(
    //   'Info',
    //   '$type functionality coming soon',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
    CustomSnackBar.success('$type functionality coming soon');
  }

  Future<void> logout() async {
    final response = await _apiService.logoutUser();
    if (response != null && response.statusCode == 200) {
      Get.offAllNamed('/login'); // Adjust based on your routes
    }
  }
}