import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../homescreen/home_controller.dart';
import 'mineg_controller.dart';

class MineGScreen extends StatefulWidget {
  const MineGScreen({super.key});

  @override
  State<MineGScreen> createState() => _MineGScreenState();
}

class _MineGScreenState extends State<MineGScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final MineGController _controller = Get.put(MineGController());
  final HomeController _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.getScreenBgColor(),
      appBar: AppBar(
        backgroundColor: MyColor.getAppbarBgColor(),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: MyColor.getAppbarTitleColor(),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_controller.getBalance()} ',
              style: TextStyle(
                color: MyColor.getAppbarTitleColor(),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'G',
              style: TextStyle(
                color: MyColor.getGCoinPrimaryColor(),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: MyColor.getGCoinPrimaryColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'EN',
                  style: TextStyle(
                    color: MyColor.getGCoinPrimaryColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.language,
                  color: MyColor.getGCoinPrimaryColor(),
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Mining Session Timer Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: MyColor.getGCoinHeroGradient(),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: MyColor.getGCoinPrimaryColor().withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.access_time,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _homeController.isMining.value
                            ? 'Mining Session Ends'
                            : 'No Active Mining Session',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => Text(
                        _homeController.isMining.value
                            ? _homeController.formatTime(_homeController.miningTimeLeft.value)
                            : '00:00:00',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      )),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Total Mining Rate Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: MyColor.getGCoinCardColor(),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: MyColor.getGCoinDividerColor(),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: MyColor.getGCoinShadowColor(),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Total mining rate:',
                        style: TextStyle(
                          color: MyColor.getTextColor(),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: _controller.getPerHourRate(),
                              style: TextStyle(
                                color: MyColor.getGCoinPrimaryColor(),
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: MyColor.getGCoinPrimaryColor(),
                              ),
                            ),
                            TextSpan(
                              text: ' G/hr',
                              style: TextStyle(
                                color: MyColor.getTextColor(),
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Base Rate Section
                _buildExpandableSection(
                  title: 'Base Rate',
                  value: '${_controller.getMiningReward()} G/hr',
                  color: Colors.red.shade50,
                  borderColor: Colors.red,
                  icon: Icons.info_outline,
                  content: Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Your base mining rate is calculated based on your account verification and activity level.',
                      style: TextStyle(
                        color: MyColor.getTextColor(),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required String value,
    required Color color,
    required Color borderColor,
    required IconData icon,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          leading: Icon(icon, color: borderColor),
          title: Text(
            title,
            style: TextStyle(
              color: borderColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: borderColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.expand_more, color: borderColor),
            ],
          ),
          children: [content],
        ),
      ),
    );
  }
}