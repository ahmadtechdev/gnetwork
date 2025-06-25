// referral_team_controller.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api_service/api_service.dart';
import '../../../utils/custom_snackbar.dart';
import '../../homescreen/home_controller.dart';


class ReferralTeamController extends GetxController {
  final ApiService _apiService = Get.put(ApiService());
  var isLoading = true.obs;
  var referrals = <dynamic>[].obs;
  var totalMining = 0.obs;

  final HomeController _homeController = Get.put(HomeController());

  @override
  void onInit() {
    super.onInit();
    fetchReferrals();
  }

  Future<void> shareReferralCode() async {
    try {
      final userName = _homeController.userData['name'] ?? 'Your Friend';
      final referralCode = _homeController.userData['username'] ?? '';


      // Create beautiful WhatsApp message
      final message = '''
🌟 *Join G Network & Start Mining G Coins!* 🌟

Hey! I'm $userName inviting you to join the revolutionary G Network! 

💰 *Earn G Coins daily* by mining & inviting friends
🚀 *Free to start* - No investment required
🔗 *Global community* of miners earning together
📱 *Simple mobile mining* - Just tap to mine!

*Your Referral Code:* `$referralCode`

📲 *Download G Network App:*
https://play.google.com/store/apps/details?id=com.gnetwork.gcoin

Join thousands of users already earning G Coins! 
Don't miss out on this opportunity! 🎯

#GNetwork #GCoin #CryptoMining #EarnDaily
      '''.trim();

      // // Create WhatsApp URL
      // final whatsappUrl = 'https://wa.me/$senderNumber?text=${Uri.encodeComponent(message)}';


      // Fallback to general share
      final generalShareUrl = 'https://api.whatsapp.com/send?text=${Uri.encodeComponent(message)}';
      if (await canLaunchUrl(Uri.parse(generalShareUrl))) {
        await launchUrl(
          Uri.parse(generalShareUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        CustomSnackBar.error('Unable to open WhatsApp. Please install WhatsApp first.');
      }

    } catch (e) {
      CustomSnackBar.error('Error sharing referral code: ${e.toString()}');
    }
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