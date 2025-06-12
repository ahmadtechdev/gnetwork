import 'package:flutter/material.dart';
import 'package:gcoin/utils/app_colors.dart';
import 'package:get/get.dart';

class ReferralTeamPage extends StatefulWidget {
  @override
  _ReferralTeamPageState createState() => _ReferralTeamPageState();
}

class _ReferralTeamPageState extends State<ReferralTeamPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.getScreenBgColor(),
      appBar: _buildAppBar(),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildReferralStatsCard(),
                    SizedBox(height: 20),
                    _buildWarningCard(),
                    SizedBox(height: 24),
                    _buildMembersSection(),
                    SizedBox(height: 16),
                    _buildMembersList(),
                    SizedBox(height: 20),
                    _buildActionButtons(),
                    SizedBox(height: 100), // Extra space for bottom navigation
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: MyColor.getAppbarBgColor(),
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: MyColor.getAppbarTitleColor(),
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        children: [
          Text(
            '122.34966',
            style: TextStyle(
              color: MyColor.getAppbarTitleColor(),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'π',
            style: TextStyle(
              color: MyColor.getAppbarTitleColor(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: EdgeInsets.only(right: 16),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: MyColor.getGCoinPrimaryColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: MyColor.getGCoinPrimaryColor().withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'EN',
                style: TextStyle(
                  color: MyColor.getGCoinPrimaryColor(),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.language_rounded,
                color: MyColor.getGCoinPrimaryColor(),
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReferralStatsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: MyColor.getGCoinPrimaryGradient(),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: MyColor.getGCoinPrimaryColor().withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Referral Team',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(text: 'You have invited '),
                        TextSpan(
                          text: '0 new Pioneers',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' so far.'),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Your Referral Team has 1 members.\n0 of 1 are currently mining.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_active_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Ping Inactive',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Mining',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(

              children: [
                Icon(Icons.warning_rounded, color: Colors.red, size: 24),
                SizedBox(width: 8),
                Text(
                  'You are at risk of losing G Coin!',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Text(
            'If your Referral and Security Team members don\'t finish the Mainnet Checklist by the Grace Period deadline, you will lose some bonus G Network attributed to their contributions. If they only migrate the balance within their 6-month rolling window, you\'ll only receive bonuses contributed by them within that period.',
            style: TextStyle(
              color: MyColor.getTextColor(),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Ask your team to migrate so you also don\'t lose your bonus attributable to them.',
            style: TextStyle(
              color: MyColor.getTextColor(),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColor.getGCoinPrimaryColor(),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'See Pioneers',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Members',
              style: TextStyle(
                color: MyColor.getHeadingTextColor(),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: MyColor.getCardBg(),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: MyColor.getGCoinPrimaryColor().withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'All',
                    style: TextStyle(
                      color: MyColor.getGCoinPrimaryColor(),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: MyColor.getGCoinPrimaryColor(),
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          'Invite new Pioneers to join your Referral Team!\nBoost your mining rate for every actively mining Member. Ping daily to remind them to mine!',
          style: TextStyle(
            color: MyColor.getTextColor1(),
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMembersList() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyColor.getCardBg(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MyColor.getGCoinDividerColor(), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: MyColor.getGCoinPrimaryColor().withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: MyColor.getGCoinPrimaryColor(),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.person_rounded,
              color: MyColor.getGCoinPrimaryColor(),
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hafiz Muhammad',
                  style: TextStyle(
                    color: MyColor.getHeadingTextColor(),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Nabras asif',
                  style: TextStyle(
                    color: MyColor.getTextColor1(),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bedtime_rounded, color: Colors.grey, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'zzz',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Inactive',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(width: 8),
          Icon(
            Icons.shield_rounded,
            color: MyColor.getGCoinPrimaryColor(),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: MyColor.getGCoinPrimaryColor(),
                width: 1.5,
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Referral Team Chat',
              style: TextStyle(
                color: MyColor.getGCoinPrimaryColor(),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColor.getGCoinPrimaryColor(),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Invite More',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
