// mineg_controller.dart
import 'dart:async';

import 'package:get/get.dart';

import '../../../api_service/api_service.dart';

class MineGController extends GetxController {
  final ApiService _apiService = Get.put(ApiService());
  var isLoading = true.obs;
  var miningData = <String, dynamic>{}.obs;
  var remainingTime = '00:00:00'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMiningData();
    startTimer();
  }

  Future<void> fetchMiningData() async {
    try {
      isLoading(true);
      final response = await _apiService.mineG();
      if (response != null && response.data['success'] == true) {
        miningData.value = response.data;
        if (miningData['mining_session'] == true) {
          // Initialize timer if mining session is active
          // You would need to get the actual remaining time from the API
          remainingTime.value = '20:28:57'; // Example value
        } else {
          remainingTime.value = '00:00:00';
        }
      }
    } finally {
      isLoading(false);
    }
  }

  void startTimer() {
    // This is a simplified timer implementation
    // In a real app, you would calculate the actual remaining time
    // based on the mining session end time from the API
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      if (remainingTime.value == '00:00:00') {
        timer.cancel();
      } else {
        // This is just a mock countdown - replace with actual time calculation
        final parts = remainingTime.split(':');
        int hours = int.parse(parts[0]);
        int minutes = int.parse(parts[1]);
        int seconds = int.parse(parts[2]);

        if (seconds > 0) {
          seconds--;
        } else {
          if (minutes > 0) {
            minutes--;
            seconds = 59;
          } else if (hours > 0) {
            hours--;
            minutes = 59;
            seconds = 59;
          }
        }

        remainingTime.value =
        '${hours.toString().padLeft(2, '0')}:'
            '${minutes.toString().padLeft(2, '0')}:'
            '${seconds.toString().padLeft(2, '0')}';
      }
    });
  }

  String getBalance() {
    return miningData['balance']?.toString() ?? '0.00';
  }

  String getMiningReward() {
    return miningData['mining_reward']?.toString() ?? '0.00';
  }

  String getPerHourRate() {
    return miningData['per_hour_rate']?.toString() ?? '0.00';
  }

  bool isMiningActive() {
    return miningData['mining_session'] == true;
  }
}