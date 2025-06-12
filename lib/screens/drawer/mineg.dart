import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class MineGScreen extends StatefulWidget {
  const MineGScreen({Key? key}) : super(key: key);

  @override
  State<MineGScreen> createState() => _MineGScreenState();
}

class _MineGScreenState extends State<MineGScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '0.08224 ',
              style: TextStyle(
                color: MyColor.getAppbarTitleColor(),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'π',
              style: TextStyle(
                color: MyColor.getGCoinPrimaryColor(),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
      body: SingleChildScrollView(
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
                      'Mining Session Ends',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '20:28:57',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
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
                            text: '0.0030',
                            style: TextStyle(
                              color: MyColor.getGCoinPrimaryColor(),
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: MyColor.getGCoinPrimaryColor(),
                            ),
                          ),
                          TextSpan(
                            text: ' π/hr',
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

              // Rate Components Row
              Row(
                children: [
                  Expanded(
                    child: _buildRateCard(
                      title: 'Base Rate',
                      value: '0.0030',
                      unit: 'π/hr',
                      color: Colors.red.shade100,
                      borderColor: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '×',
                    style: TextStyle(
                      color: MyColor.getTextColor(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildRateCard(
                      title: 'Boosters',
                      value: '100.00',
                      unit: '%',
                      color: MyColor.getGCoinPrimaryColor().withOpacity(0.1),
                      borderColor: MyColor.getGCoinPrimaryColor(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '×',
                    style: TextStyle(
                      color: MyColor.getTextColor(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildRateCard(
                      title: 'Rewards',
                      value: '1.00',
                      unit: '',
                      color: Colors.purple.shade100,
                      borderColor: Colors.purple,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Base Rate Section
              _buildExpandableSection(
                title: 'Base Rate',
                value: '0.0030 π/hr',
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

              const SizedBox(height: 16),

              // Boosters Section
              _buildExpandableSection(
                title: 'Boosters',
                value: '100.00%',
                color: MyColor.getGCoinPrimaryColor().withOpacity(0.05),
                borderColor: MyColor.getGCoinPrimaryColor(),
                icon: Icons.rocket_launch,
                content: Column(
                  children: [
                    _buildBoosterItem('Pioneer', '100%', true),
                    _buildBoosterItem('Security Circle', '0 × 20% = 0.00%', false),
                    _buildBoosterItem('Lockup reward', '0.00%', false),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColor.getGCoinPrimaryColor(),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Increase',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Rewards Section
              _buildExpandableSection(
                title: 'Rewards',
                value: '1.00',
                color: Colors.purple.shade50,
                borderColor: Colors.purple,
                icon: Icons.card_giftcard,
                content: Column(
                  children: [
                    _buildRewardItem('Pioneer', '1.00', true),
                    _buildRewardItem('Referral Team', '0 × 0.25 = 0.00', false),
                    _buildRewardItem('Utility usage bonus', '0.00', false,
                        subtitle: 'Tuning in progress. This value may change'),
                    _buildRewardItem('Node Bonus', '0.00', false,
                        subtitle: 'Tuning in progress. This value may change'),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Increase',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRateCard({
    required String title,
    required String value,
    required String unit,
    required Color color,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: borderColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: borderColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(
                      color: borderColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
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

  Widget _buildBoosterItem(String name, String value, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: MyColor.getTextColor(),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isActive ? MyColor.getGCoinPrimaryColor() : MyColor.getTextColor(),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardItem(String name, String value, bool isActive, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: MyColor.getTextColor(),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: isActive ? Colors.purple : MyColor.getTextColor(),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                subtitle,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}