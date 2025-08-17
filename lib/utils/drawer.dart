import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api_service/api_service.dart';
import '../api_service/local_stroge.dart';
import '../screens/drawer/active_status/active_status.dart';
import '../screens/drawer/faq/faq.dart';
import '../screens/drawer/kyc/kyc_screen.dart';
import '../screens/drawer/mineg/mineg.dart';
import '../screens/drawer/node.dart';
import '../screens/drawer/profile/profile.dart';
import '../screens/drawer/refferal/refferal_team.dart';
import '../screens/drawer/support/support.dart';
import '../screens/drawer/tree/tree.dart';
import '../screens/drawer/wallet/wallet.dart';
import '../screens/drawer/withdraw/withdraw.dart';
import 'custom_snackbar.dart';

class GNetworkDrawer extends StatelessWidget {
  const GNetworkDrawer({super.key});

  // Function to check if today is the 10th of the month
  bool _isWithdrawDay() {
    final now = DateTime.now();
    return now.day == 10;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF0D1F0F),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7ED321), Color(0xFF4CAF50)],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'G',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Grow Network',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 16),
                children: [
                  _buildDrawerItem(
                    context,
                    Icons.home_rounded,
                    'Home',
                    true,
                    null,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.sports_esports_rounded,
                    'FAQ',
                    false,
                        () => Get.to(() => FAQPage()),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.store_rounded,
                    'Referral Team',
                    false,
                        () => Get.to(() => ReferralTeamPage()),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.store_rounded,
                    'Team Tree',
                    false,
                        () => Get.to(() => NetworkTreeScreen()),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.military_tech,
                    'Rate network',
                    false,
                        () => Get.to(() => MineGScreen()),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.verified_user,
                    'Node',
                    false,
                        () => Get.to(() => EmailVerificationScreen()),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.support_agent,
                    'Support',
                    false,
                        () => Get.to(() => ModernSupportScreen()),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.wallet,
                    'Wallet',
                    false,
                        () => Get.to(() => WalletScreen()),
                  ),
                  // Conditionally show Withdraw option only on the 10th of the month
                  if (_isWithdrawDay())
                    _buildDrawerItem(
                      context,
                      Icons.wallet_giftcard,
                      'Withdraw',
                      false,
                          () => Get.to(() => WithdrawScreen()),
                    ),
                  _buildDrawerItem(
                    context,
                    Icons.account_circle,
                    'Profile',
                    false,
                        () => Get.to(() => ModernProfileScreen()),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.key,
                    'KYC',
                    false,
                        () => Get.to(() => KYCScreen()),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.query_stats,
                    'Active Status',
                    false,
                        () => Get.to(() => ActivityStatusScreen()),
                  ),
                  Divider(color: Color(0xFF7ED321).withOpacity(0.2)),
                  _buildDrawerItem(
                    context,
                    Icons.logout_rounded,
                    'Logout',
                    false,
                        () async {
                      final apiService = ApiService();
                      final response = await apiService.logoutUser();
                      if (response != null && response.statusCode == 200) {
                        await LocalStorage.clear();
                        CustomSnackBar.success("Logout Successfully");
                        Get.offAllNamed('/sign_in');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context,
      IconData icon,
      String title,
      bool isActive,
      VoidCallback? onTap,
      ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        gradient:
        isActive
            ? LinearGradient(colors: [Color(0xFF7ED321), Color(0xFF4CAF50)])
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : Color(0xFF7ED321),
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Color(0xFFE8F5E8),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        onTap:
        onTap ??
                () {
              Navigator.pop(context);
            },
      ),
    );
  }
}