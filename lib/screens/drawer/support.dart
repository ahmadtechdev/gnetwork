import 'package:flutter/material.dart';
import 'package:gcoin/theme_controller.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';

class ModernSupportScreen extends StatelessWidget {
  const ModernSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.getScreenBgColor(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with Gradient Background
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: MyColor.getGCoinHeroGradient(),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: MyColor.colorWhite.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: MyColor.colorWhite.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: MyColor.colorWhite,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Title
                      Text(
                        'Support Center',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: MyColor.colorWhite,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'We\'re here to help you 24/7',
                        style: TextStyle(
                          fontSize: 16,
                          color: MyColor.colorWhite.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Box
                    Container(
                      decoration: BoxDecoration(
                        color: MyColor.getGCoinCardColor(),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: MyColor.getGCoinShadowColor(),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: MyColor.getGCoinDividerColor(),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        style: TextStyle(
                          color: MyColor.getTextColor(),
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Type in this box to search for help',
                          hintStyle: TextStyle(
                            color: MyColor.getTextFieldHintColor(),
                            fontSize: 16,
                          ),
                          prefixIcon: Container(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.search,
                              color: MyColor.getGCoinPrimaryColor(),
                              size: 24,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40),

                    // Community Wiki Section
                    _buildSectionCard(
                      title: 'Read the Community Wiki',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to the G Network Support Portal and Community Wiki pages! In the Search Portal here, you can type your question in English, which will recommend community-generated wiki pages that may help answer your question. Go to the',
                            style: TextStyle(
                              color: MyColor.getSecondaryTextColor(),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              // Handle community wiki navigation
                            },
                            child: Text(
                              'Community Wiki here',
                              style: TextStyle(
                                color: MyColor.getGCoinPrimaryColor(),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Contact Section
                    _buildSectionCard(
                      title: 'Click on a category below to send us an email',
                      content: Column(
                        children: [
                          // Learn More Expandable
                          _buildExpandableItem(
                            icon: Icons.info_outline,
                            title: 'Learn more about',
                            subtitle: 'Translation of the Community Wiki',
                            description: 'The Community Wiki pages are created and translated by the Translation Task Force and are not official statements of the G Core Team.',
                          ),

                          SizedBox(height: 16),

                          // Contact Request
                          _buildExpandableItem(
                            icon: Icons.contact_support,
                            title: 'Need to raise a request? Contact us',
                            isExpandable: false,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),

                    // Suggested Forms Section
                    Text(
                      'Suggested forms',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: MyColor.getHeadingTextColor(),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Form Options
                    _buildFormOption(
                      icon: Icons.email_outlined,
                      title: 'KYC in Email Request',
                    ),
                    _buildFormOption(
                      icon: Icons.help_outline,
                      title: 'G Help in Email Request',
                    ),
                    _buildFormOption(
                      icon: Icons.web_outlined,
                      title: 'Wallet & Browser in Email Request',
                    ),
                    _buildFormOption(
                      icon: Icons.verified_user_outlined,
                      title: 'Verification of Account in Email Request',
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget content}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColor.getGCoinCardColor(),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: MyColor.getGCoinShadowColor(),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: MyColor.getGCoinDividerColor(),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MyColor.getHeadingTextColor(),
              ),
            ),
            SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableItem({
    required IconData icon,
    required String title,
    String? subtitle,
    String? description,
    bool isExpandable = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: MyColor.getGCoinElevatedCardColor(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MyColor.getGCoinDividerColor(),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: MyColor.getGCoinPrimaryColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: MyColor.getGCoinPrimaryColor(),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: MyColor.getTextColor(),
          ),
        ),
        subtitle: subtitle != null
            ? Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: MyColor.getSecondaryTextColor(),
          ),
        )
            : null,
        children: description != null
            ? [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: MyColor.getSecondaryTextColor(),
                height: 1.5,
              ),
            ),
          ),
        ]
            : [],
        iconColor: MyColor.getGCoinPrimaryColor(),
        collapsedIconColor: MyColor.getGCoinPrimaryColor(),
      ),
    );
  }

  Widget _buildFormOption({required IconData icon, required String title}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: MyColor.getGCoinCardColor(),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: MyColor.getGCoinShadowColor(),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: MyColor.getGCoinDividerColor(),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: MyColor.getGCoinPrimaryGradient(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: MyColor.colorWhite,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: MyColor.getTextColor(),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: MyColor.getGCoinPrimaryColor(),
          size: 16,
        ),
        onTap: () {
          // Handle form selection
        },
      ),
    );
  }
}