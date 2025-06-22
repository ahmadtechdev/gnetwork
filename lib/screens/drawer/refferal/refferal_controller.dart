// referral_team_controller.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api_service/api_service.dart';


class ReferralTeamController extends GetxController {
  final ApiService _apiService = Get.put(ApiService());
  var isLoading = true.obs;
  var referrals = <dynamic>[].obs;
  var totalMining = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReferrals();
  }

  Future<void> fetchReferrals() async {
    try {
      isLoading(true);
      final response = await _apiService.getReferrals();
      if (response != null && response.data['success'] == true) {
        referrals.value = response.data['referrals'] ?? [];
        // Calculate active mining members
        totalMining.value = referrals.where((ref) => ref['mine_status'] == 1).length;
      }
    } finally {
      isLoading(false);
    }
  }

  String getStatusText(int status) {
    return status == 1 ? 'Active' : 'Inactive';
  }

  Color getStatusColor(int status) {
    return status == 1 ? Colors.green : Colors.grey;
  }

  IconData getStatusIcon(int status) {
    return status == 1 ? Icons.check_circle : Icons.bedtime_rounded;
  }
}