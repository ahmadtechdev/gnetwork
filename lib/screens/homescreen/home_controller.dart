import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gcoin/utils/custom_snackbar.dart';
import 'package:get/get.dart';

import '../../api_service/api_service.dart';
import '../../api_service/local_stroge.dart';


class HomeController extends GetxController {
  final ApiService _apiService = ApiService();
  final Dio _dio = Dio();

  var isLoading = true.obs;
  var userData = {}.obs;
  var posts = [].obs;
  var logs = [].obs;
  var isMining = false.obs;
  var miningTimeLeft = 0.obs; // in seconds
  var miningReward = "0.00".obs;
  Timer? miningTimer;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
    _loadMiningState();
  }

  @override
  void onClose() {
    miningTimer?.cancel();
    super.onClose();
  }

// Update _loadMiningState in HomeController
  void _loadMiningState() {
    final miningEndTime = LocalStorage.getMiningEndTime();
    if (miningEndTime != null) {
      // Verify the mining data belongs to current user
      final currentUser = LocalStorage.getUser();
      if (currentUser?['mine_status'] == 1) {
        final remaining = miningEndTime.difference(DateTime.now()).inSeconds;
        if (remaining > 0) {
          isMining.value = true;
          miningTimeLeft.value = remaining;
          _startMiningTimer();
        } else {
          LocalStorage.clearMiningData();
        }
      } else {
        // Clear if mining data doesn't belong to current user
        LocalStorage.clearMiningData();
      }
    }
  }

  void _startMiningTimer() {
    miningTimer?.cancel();
    miningTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (miningTimeLeft.value > 0) {
        miningTimeLeft.value--;
      } else {
        timer.cancel();
        isMining.value = false;
        LocalStorage.clearMiningData();
        fetchDashboardData(); // Refresh data when mining completes
      }
    });
  }

  // Update startMining in HomeController
  Future<void> startMining() async {
    try {
      // Check if user can mine based on API data
      if (userData['mine_status'] == 1) {
        Get.snackbar(
          'Already Mining',
          'You are already mining. Please wait until completion.',
          backgroundColor: Colors.orange,
        );
        CustomSnackBar.error("You are already mining. Please wait until completion.", title: "Already Mining" );
        return;
      }

      isLoading(true);
      final response = await _apiService.startMining();

      if (response?.statusCode == 200) {
        final data = response?.data;
        final hours = int.tryParse(data['mining_after_hours'] ?? '1') ?? 1;
        miningReward.value = data['mining_reward'] ?? '0.00';

        // Save mining end time
        final endTime = DateTime.now().add(Duration(hours: hours));
        LocalStorage.saveMiningData(endTime, reward: miningReward.value);

        // Update user data
        userData.update('mine_status', (value) => 1);

        isMining.value = true;
        miningTimeLeft.value = hours * 3600; // Convert hours to seconds
        _startMiningTimer();

        Get.snackbar(
          'Success',
          'Mining started! Reward: ${miningReward.value} π',
          backgroundColor: Color(0xFF7ED321),
        );
        CustomSnackBar.success("Mining started! Reward: ${miningReward.value} G");
      }
    } catch (e) {
      // Get.snackbar(
      //   'Error',
      //   'Failed to start mining: ${e.toString()}',
      //   backgroundColor: Colors.red,
      // );
      CustomSnackBar.error("Failed to start mining: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }
  String formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  // Update home_controller.dart
  Future<void> fetchDashboardData() async {
    try {
      isLoading(true);
      final token = LocalStorage.getToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Clear mining data if user changed
      final currentUser = LocalStorage.getUser();
      final response = await _dio.get(
        'https://gnetwork.pro/api/dashboard',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final newUser = response.data['user'];
        // If user changed, clear mining data
        if (currentUser?['id'] != newUser['id']) {
          miningTimer?.cancel();
          isMining.value = false;
          miningTimeLeft.value = 0;
        }

        userData.value = newUser;
        posts.value = response.data['posts'];
        logs.value = response.data['logs'];

        // Check if user is already mining from API
        if (newUser['mine_status'] == 1) {
          _loadMiningState();
        }
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      // Get.snackbar('Error', 'Failed to fetch dashboard data: ${e.toString()}');
      CustomSnackBar.error('Failed to fetch dashboard data: ${e.toString()}', title: "Er1ror");
    } finally {
      isLoading(false);
    }
  }
  String getBalance() {
    return userData['balance']?.toString() ?? '0.00';
  }

  String getMiningRate() {
    return userData['mine_rate']?.toString() ?? '0.00';
  }

  String getNetworkCount() {
    return '${userData['direct_refer_count'] ?? 0}/${userData['whole_team_count'] ?? 0}';
  }
}