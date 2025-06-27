import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gcoin/screens/auth/signin/signin.dart';
import 'package:gcoin/utils/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api_service/api_service.dart';
import '../../api_service/local_stroge.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final Dio _dio = Dio();

  var isLoading = true.obs;
  var userData = {}.obs;
  var posts = [].obs;
  var logs = [].obs;
  var isMining = false.obs;
  var miningReward = "0.00".obs;
  var miningTimeLeft = 0.obs; // in seconds
  Timer? miningTimer;

  // Animation properties
  var animatedBalance = 0.0.obs;
  var baseBalance = 0.0.obs; // The balance from API without mining rewards
  late AnimationController balanceAnimationController;
  late Animation<double> balanceAnimation;
  Timer? balanceUpdateTimer;

  // Mining calculation properties
  double miningStartTime = 0;
  double totalMiningDuration = 3600; // 1 hour in seconds
  double currentMiningRate = 0;

  // Fast initial animation properties
  bool isInitialAnimation = false;
  double targetInitialBalance = 0.0;
  Timer? initialAnimationTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _checkTokenAndFetchData();
  }

  void _initializeAnimations() {
    balanceAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    balanceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: balanceAnimationController,
      curve: Curves.easeOutCubic,
    ));
  }

  Future<void> _checkTokenAndFetchData() async {
    try {
      isLoading(true);
      final token = LocalStorage.getToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _apiService.checkTokenValidity();

      if (response == null) {
        throw Exception('Invalid token');
      }

      await fetchDashboardData();
      _loadMiningState();
    } catch (e) {
      CustomSnackBar.error('Session expired. Please login again.');
      await LocalStorage.clear();
      Get.offAllNamed('/sign_in');
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    miningTimer?.cancel();
    balanceUpdateTimer?.cancel();
    initialAnimationTimer?.cancel();
    balanceAnimationController.dispose();
    super.onClose();
  }

  void _loadMiningState() {
    if (userData['mine_status'] == 1) {
      final remainingMinutes = userData['remaining_time'] ?? 0;
      if (remainingMinutes > 0) {
        isMining.value = true;
        miningTimeLeft.value = remainingMinutes * 60;

        // Calculate mining progress and setup animated balance
        _setupMiningBalance();
        _startMiningTimer();
        _startFastInitialAnimation(); // Start with fast animation
      } else {
        isMining.value = false;
        _stopBalanceAnimation();
      }
    } else {
      isMining.value = false;
      _stopBalanceAnimation();
    }
  }

  void _setupMiningBalance() {
    // Get base balance and mining rate
    baseBalance.value = double.parse(userData['balance']?.toString() ?? '0');
    currentMiningRate = double.parse(userData['mine_rate']?.toString() ?? '0');

    // Calculate how much time has passed in current mining session
    final remainingSeconds = miningTimeLeft.value;
    final elapsedSeconds = totalMiningDuration - remainingSeconds;

    // Calculate the reward that should have been earned so far
    final elapsedReward = (elapsedSeconds / totalMiningDuration) * currentMiningRate;

    // Set initial animated balance (base balance - already earned rewards)
    animatedBalance.value = max(0, baseBalance.value + elapsedReward);

    // Calculate target balance for fast initial animation
    targetInitialBalance = baseBalance.value;
  }

  void _startFastInitialAnimation() {
    isInitialAnimation = true;
    initialAnimationTimer?.cancel();

    final startBalance = animatedBalance.value;
    final targetBalance = targetInitialBalance;
    final difference = targetBalance - startBalance;

    if (difference <= 0) {
      // No need for initial animation
      isInitialAnimation = false;
      _startNormalBalanceAnimation();
      return;
    }

    // Fast animation over 2-3 seconds (30 steps over 2.5 seconds)
    const animationDuration = 2500; // 2.5 seconds
    const steps = 30;
    const stepDuration = animationDuration ~/ steps;

    int currentStep = 0;

    initialAnimationTimer = Timer.periodic(Duration(milliseconds: stepDuration), (timer) {
      currentStep++;

      // Use easeOut curve for smooth fast animation
      final progress = currentStep / steps;
      final easedProgress = 1 - pow(1 - progress, 3); // Cubic ease-out

      animatedBalance.value = startBalance + (difference * easedProgress);

      if (currentStep >= steps) {
        timer.cancel();
        isInitialAnimation = false;
        animatedBalance.value = targetBalance; // Ensure exact target
        _startNormalBalanceAnimation(); // Start normal animation
      }
    });
  }

  void _startNormalBalanceAnimation() {
    _startBalanceAnimation();
  }

  void _startBalanceAnimation() {
    balanceUpdateTimer?.cancel();
    balanceUpdateTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (isMining.value && miningTimeLeft.value > 0 && !isInitialAnimation) {
        _updateAnimatedBalance();
      } else if (!isMining.value || miningTimeLeft.value <= 0) {
        timer.cancel();
      }
    });
  }

  void _stopBalanceAnimation() {
    balanceUpdateTimer?.cancel();
    initialAnimationTimer?.cancel();
    isInitialAnimation = false;
    // Set animated balance to actual balance when not mining
    animatedBalance.value = double.parse(userData['balance']?.toString() ?? '0');
  }

  void _updateAnimatedBalance() {
    if (!isMining.value || currentMiningRate == 0 || isInitialAnimation) return;

    final remainingSeconds = miningTimeLeft.value;
    final elapsedSeconds = totalMiningDuration - remainingSeconds;

    // Calculate progress (0 to 1)
    final progress = elapsedSeconds / totalMiningDuration;

    // Calculate expected balance based on mining progress
    final earnedReward = progress * currentMiningRate;
    final expectedBalance = baseBalance.value + earnedReward;

    // Smooth interpolation to expected balance
    final currentAnimated = animatedBalance.value;
    final difference = expectedBalance - currentAnimated;

    // Use exponential smoothing for natural animation
    final smoothingFactor = 0.02; // Adjust for animation speed
    animatedBalance.value = currentAnimated + (difference * smoothingFactor);
  }

  void _startMiningTimer() {
    miningTimer?.cancel();
    miningTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (miningTimeLeft.value > 0) {
        miningTimeLeft.value--;

        // Sync with server every minute
        if (miningTimeLeft.value % 60 == 0) {
          fetchDashboardData();
        }
      } else {
        timer.cancel();
        isMining.value = false;
        _stopBalanceAnimation();
        fetchDashboardData();
      }
    });
  }

  Future<void> startMining() async {
    try {
      if (userData['mine_status'] == 1) {
        Get.snackbar(
          'Already Mining',
          'You are already mining. Please wait until completion.',
          backgroundColor: Colors.orange,
        );
        return;
      }

      isLoading(true);
      final response = await _apiService.startMining();

      if (response?.statusCode == 200) {
        final data = response?.data;
        miningReward.value = data['mining_reward'] ?? '0.00';
        await fetchDashboardData();
      }
    } catch (e) {
      CustomSnackBar.error("Failed to start mining: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  String formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading(true);
      final token = LocalStorage.getToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        'https://gnetwork.pro/api/dashboard',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        userData.value = response.data['user'];
        posts.value = response.data['posts'];
        logs.value = response.data['logs'];

        // Handle mining state based on API response
        if (userData['mine_status'] == 1) {
          final remainingMinutes = userData['remaining_time'] ?? 0;
          if (remainingMinutes > 0) {
            final wasAlreadyMining = isMining.value;
            isMining.value = true;

            if ((miningTimeLeft.value ~/ 60) != remainingMinutes) {
              miningTimeLeft.value = remainingMinutes * 60;
              _setupMiningBalance(); // Recalculate balance animation

              // Only start fast animation if we weren't already mining
              if (!wasAlreadyMining) {
                _startFastInitialAnimation();
              }
            }

            _startMiningTimer();
            if (!wasAlreadyMining || balanceUpdateTimer == null || !balanceUpdateTimer!.isActive) {
              if (!isInitialAnimation) {
                _startNormalBalanceAnimation();
              }
            }
          } else {
            isMining.value = false;
            miningTimer?.cancel();
            _stopBalanceAnimation();
          }
        } else {
          isMining.value = false;
          miningTimer?.cancel();
          _stopBalanceAnimation();
        }
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      CustomSnackBar.error('Failed to fetch dashboard data: ${e.toString()}', title: "Error");
    } finally {
      isLoading(false);
    }
  }

  String getBalance() {
    return userData['balance']?.toString() ?? '0.00';
  }

  String getAnimatedBalance() {
    return animatedBalance.value.toStringAsFixed(3);
  }

  String getMiningRate() {
    return userData['mine_rate']?.toString() ?? '0.00';
  }

  String getNetworkCount() {
    return '${userData['direct_refer_count'] ?? 0}/${userData['whole_team_count'] ?? 0}';
  }

  // Get mining progress as percentage
  double getMiningProgress() {
    if (!isMining.value) return 0.0;
    final elapsedSeconds = totalMiningDuration - miningTimeLeft.value;
    return (elapsedSeconds / totalMiningDuration).clamp(0.0, 1.0);
  }

  // Get estimated reward based on current progress
  String getEstimatedReward() {
    if (!isMining.value) return '0.00';
    final progress = getMiningProgress();
    final estimatedReward = progress * currentMiningRate;
    return estimatedReward.toStringAsFixed(3);
  }

  Future<void> shareReferralCode() async {
    try {
      final userName = userData['name'] ?? 'Your Friend';
      final referralCode = userData['username'] ?? '';

      final message = '''
🌟 *Join G Network & Start Mining G Coins!* 🌟

Hey! I'm $userName inviting you to join the revolutionary G Network! 

💰 *Earn G Coins daily* by mining & inviting friends
🚀 *Free to start* - No investment required
🔗 *Global community* of miners earning together
📱 *Simple mobile mining* - Just tap to mine!

*Your Referral Code:* `$referralCode`

📲 *Download G Network App:*
https://play.google.com/store/apps/details?id=pro.gnetwork.gnewtwork&hl=en

Join thousands of users already earning G Coins! 
Don't miss out on this opportunity! 🎯

#GNetwork #GCoin #CryptoMining #EarnDaily
      '''.trim();

      final generalShareUrl =
          'https://api.whatsapp.com/send?text=${Uri.encodeComponent(message)}';
      if (await canLaunchUrl(Uri.parse(generalShareUrl))) {
        await launchUrl(
          Uri.parse(generalShareUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        CustomSnackBar.error(
          'Unable to open WhatsApp. Please install WhatsApp first.',
        );
      }
    } catch (e) {
      CustomSnackBar.error('Error sharing referral code: ${e.toString()}');
    }
  }
}