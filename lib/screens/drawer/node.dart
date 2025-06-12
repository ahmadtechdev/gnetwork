import 'package:flutter/material.dart';

import '../../utils/app_colors.dart'; // Import your color file

class GNodeVerificationScreen extends StatefulWidget {
  @override
  _GNodeVerificationScreenState createState() => _GNodeVerificationScreenState();
}

class _GNodeVerificationScreenState extends State<GNodeVerificationScreen> with TickerProviderStateMixin {
  final TextEditingController _codeController = TextEditingController();
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  List<String> codeDigits = ['', '', '', '', '', '', '', ''];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _onCodeChanged(String value) {
    setState(() {
      for (int i = 0; i < 8; i++) {
        if (i < value.length) {
          codeDigits[i] = value[i].toUpperCase();
        } else {
          codeDigits[i] = '';
        }
      }
      currentIndex = value.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MyColor.getScreenBgColor(),
              MyColor.getGCoinSurfaceColor(),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom Header Section
              Container(
                height: screenHeight * 0.25,
                child: Stack(
                  children: [
                    // Background decoration
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: MyColor.getGCoinPrimaryGradient(),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: MyColor.getGCoinPrimaryColor().withOpacity(0.3),
                              blurRadius: 40,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Header content
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top navigation row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Back button
                              ScaleTransition(
                                scale: _pulseAnimation,
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.chevron_left,
                                      color: MyColor.getTextColor(),
                                      size: 24,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                              ),

                              // Balance and language
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Text(
                                      '0.08151 π',
                                      style: TextStyle(
                                        color: MyColor.getTextColor(),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'EN',
                                          style: TextStyle(
                                            color: MyColor.getTextColor(),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.expand_more,
                                          color: MyColor.getTextColor(),
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Spacer(),

                          // Title section
                          SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(_slideAnimation.value, 0),
                              end: Offset.zero,
                            ).animate(_animationController),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Node Verification',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: MyColor.getHeadingTextColor(),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Secure Access Required',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: MyColor.getSecondaryTextColor(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content Section
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyColor.getGCoinCardColor(),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: MyColor.getGCoinShadowColor(),
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Progress indicator
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: MyColor.getGCoinDividerColor(),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        SizedBox(height: 32),

                        // Description with icon
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                MyColor.getGCoinPrimaryColor().withOpacity(0.1),
                                MyColor.getGCoinSecondaryColor().withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: MyColor.getGCoinPrimaryColor().withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: MyColor.getGCoinPrimaryGradient(),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Icon(
                                  Icons.smartphone,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Enter the verification code from the G Node App to finish the Node sign-in process.',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: MyColor.getTextColor(),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 40),

                        // Code input section
                        Text(
                          'Verification Code',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: MyColor.getHeadingTextColor(),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Custom code input boxes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(8, (index) {
                            return Container(
                              width: 35,
                              height: 45,
                              decoration: BoxDecoration(
                                gradient: index < currentIndex
                                    ? MyColor.getGCoinPrimaryGradient()
                                    : null,
                                color: index < currentIndex
                                    ? null
                                    : MyColor.getGCoinSurfaceColor(),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: index == currentIndex
                                      ? MyColor.getGCoinPrimaryColor()
                                      : MyColor.getGCoinDividerColor(),
                                  width: index == currentIndex ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  codeDigits[index],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: index < currentIndex
                                        ? Colors.white
                                        : MyColor.getTextColor(),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),

                        // Hidden text field for input
                        Opacity(
                          opacity: 0.01,
                          child: TextField(
                            controller: _codeController,
                            maxLength: 8,
                            onChanged: _onCodeChanged,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                          ),
                        ),

                        SizedBox(height: 32),

                        // Continue button with modern design
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: MyColor.getGCoinHeroGradient(),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: MyColor.getGCoinPrimaryColor().withOpacity(0.4),
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                // Handle continue
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Verify & Continue',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 40),

                        // Download section with card design
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: MyColor.getGCoinElevatedCardColor(),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: MyColor.getGCoinDividerColor(),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.download,
                                color: MyColor.getGCoinPrimaryColor(),
                                size: 32,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Download G Node App',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: MyColor.getHeadingTextColor(),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Get the official app from:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: MyColor.getSecondaryTextColor(),
                                ),
                              ),
                              SizedBox(height: 12),
                              GestureDetector(
                                onTap: () {
                                  // Handle URL
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    gradient: MyColor.getGCoinAccentGradient(),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'node.mineg.com',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24),

                        // Security warning with modern alert design
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: MyColor.getGCoinWarningColor().withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: MyColor.getGCoinWarningColor().withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: MyColor.getGCoinWarningColor(),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      Icons.security,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Security Guidelines',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: MyColor.getGCoinWarningColor(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              _buildSecurityPoint('Only download from node.mineg.com'),
                              SizedBox(height: 8),
                              _buildSecurityPoint('Never share your verification code'),
                              SizedBox(height: 8),
                              _buildSecurityPoint('Only use codes from official G Node App'),
                            ],
                          ),
                        ),

                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: EdgeInsets.only(top: 6, right: 12),
          decoration: BoxDecoration(
            color: MyColor.getGCoinWarningColor(),
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: MyColor.getTextColor(),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}