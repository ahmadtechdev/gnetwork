// mineg_controller.dart
import 'dart:async';
import 'package:get/get.dart';
import '../../../api_service/api_service.dart';
import '../../../api_service/local_stroge.dart';

class MineGController extends GetxController {
  final ApiService _apiService = Get.put(ApiService());
  var isLoading = true.obs;
  var miningData = <String, dynamic>{}.obs;
  var remainingTime = '00:00:00'.obs;
  Timer? _timer;
  DateTime? _miningEndTime;

  @override
  void onInit() {
    super.onInit();
    fetchMiningData();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> fetchMiningData() async {
    try {
      isLoading(true);
      final response = await _apiService.mineG();
      if (response != null && response.data['success'] == true) {
        miningData.value = response.data;

        // Get mining end time from local storage or API
        _miningEndTime = LocalStorage.getMiningEndTime();

        if (isMiningActive()) {
          // Start or restart the timer
          _startTimer();
        } else {
          remainingTime.value = '00:00:00';
          _timer?.cancel();
        }
      }
    } finally {
      isLoading(false);
    }
  }

  void _startTimer() {
    // Cancel any existing timer
    _timer?.cancel();

    // Check if we have an end time
    if (_miningEndTime == null) return;

    // Calculate initial remaining time
    _updateRemainingTime();

    // Start a new timer that updates every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
  }

  void _updateRemainingTime() {
    if (_miningEndTime == null) return;

    final now = DateTime.now();
    final difference = _miningEndTime!.difference(now);

    if (difference.isNegative) {
      // Mining session has ended
      remainingTime.value = '00:00:00';
      _timer?.cancel();
      // Optionally refresh mining data
      fetchMiningData();
    } else {
      // Format the remaining time as HH:MM:SS
      final hours = difference.inHours.remainder(24).toString().padLeft(2, '0');
      final minutes = difference.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = difference.inSeconds.remainder(60).toString().padLeft(2, '0');
      remainingTime.value = '$hours:$minutes:$seconds';
    }
  }

  String getBalance() {
    return miningData['balance']?.toString() ?? '0.00';
  }

  String getMiningReward() {
    return miningData['mining_reward']?.toString() ?? '0.00';
  }

  String getPerHourRate() {
    return miningData['per_hour_rate']?.toStringAsFixed(2) ?? '0.00';
  }

  bool isMiningActive() {
    return miningData['mining_session'] == true;
  }
}