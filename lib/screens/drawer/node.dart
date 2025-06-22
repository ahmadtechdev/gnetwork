import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api_service/api_service.dart';
import '../../utils/app_colors.dart';
import '../homescreen/home_controller.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with TickerProviderStateMixin {
  final TextEditingController _otpController = TextEditingController();
  final ApiService _apiService = ApiService();
  // Add this focus node at the top of your state class
  FocusNode _otpFocusNode = FocusNode();

  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  List<String> otpDigits = ['', '', '', ''];
  int currentIndex = 0;
  bool isLoading = false;
  bool isEmailVerified = false;
  String? verifiedAt;
  String userEmail = '';

  @override
  void initState() {
    super.initState();

    // Get user data from controller
    final homeController = Get.put(HomeController());
    isEmailVerified = homeController.userData['email_verified_at'] != null;
    verifiedAt = homeController.userData['email_verified_at'];
    userEmail = homeController.userData['email'] ?? 'your email';

    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _otpFocusNode.dispose();
    _animationController.dispose();
    _pulseController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _onOtpChanged(String value) {
    setState(() {
      for (int i = 0; i < 4; i++) {
        if (i < value.length) {
          otpDigits[i] = value[i];
        } else {
          otpDigits[i] = '';
        }
      }
      currentIndex = value.length;
    });
  }

  Future<void> _sendVerificationEmail() async {
    setState(() => isLoading = true);
    try {
      final response = await _apiService.sendEmailVerification();
      if (response?.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Verification code sent to $userEmail',
          backgroundColor: Color(0xFF7ED321),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _verifyEmail() async {
    if (_otpController.text.length != 4) {
      Get.snackbar(
        'Error',
        'Please enter a valid 4-digit code',
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final response = await _apiService.verifyEmailWithOtp(
        _otpController.text,
      );

      final homeController = Get.put(HomeController());
      if (response?.statusCode == 200) {
        // Refresh user data
        await homeController.fetchDashboardData();
        setState(() {
          isEmailVerified = true;
          verifiedAt = homeController.userData['email_verified_at'];
        });
        Get.snackbar(
          'Success',
          'Email verified successfully!',
          backgroundColor: Color(0xFF7ED321),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
  final homeController = Get.put(HomeController());
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
              SizedBox(
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
                              color: MyColor.getGCoinPrimaryColor().withOpacity(
                                0.3,
                              ),
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
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Text(
                                      homeController.getBalance() +
                                          ' G',
                                      style: TextStyle(
                                        color: MyColor.getTextColor(),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
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
                                  'Email Verification',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: MyColor.getHeadingTextColor(),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Secure your account',
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

                        if (isEmailVerified) _buildVerifiedStatus(),
                        if (!isEmailVerified) _buildVerificationForm(),

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

  Widget _buildVerifiedStatus() {
    return Column(
      children: [
        // Success icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: MyColor.getGCoinSuccessGradient(),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, color: Colors.white, size: 50),
        ),

        SizedBox(height: 24),

        // Success message
        Text(
          'Email Verified',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: MyColor.getGCoinSuccessColor(),
          ),
        ),

        SizedBox(height: 8),

        Text(
          'Your email $userEmail was verified',
          style: TextStyle(
            fontSize: 16,
            color: MyColor.getSecondaryTextColor(),
          ),
        ),

        SizedBox(height: 8),

        if (verifiedAt != null)
          Text(
            'Verified on ${_formatVerifiedDate(verifiedAt!)}',
            style: TextStyle(
              fontSize: 14,
              color: MyColor.getSecondaryTextColor(),
            ),
          ),
      ],
    );
  }

  Widget _buildVerificationForm() {
    return Column(
      children: [
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
                child: Icon(Icons.email, color: Colors.white, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verify your email address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: MyColor.getHeadingTextColor(),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'We sent a verification code to $userEmail. Enter the code below to verify your email.',
                      style: TextStyle(
                        fontSize: 14,
                        color: MyColor.getTextColor(),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 40),

        // OTP input section
        Text(
          'Verification Code',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: MyColor.getHeadingTextColor(),
          ),
        ),

        SizedBox(height: 20),

        // Custom OTP input boxes
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(_otpFocusNode);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              return Container(
                width: 50,
                height: 60,
                decoration: BoxDecoration(
                  gradient:
                      index < currentIndex
                          ? MyColor.getGCoinPrimaryGradient()
                          : null,
                  color:
                      index < currentIndex
                          ? null
                          : MyColor.getGCoinSurfaceColor(),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        index == currentIndex
                            ? MyColor.getGCoinPrimaryColor()
                            : MyColor.getGCoinDividerColor(),
                    width: index == currentIndex ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    otpDigits[index],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color:
                          index < currentIndex
                              ? Colors.white
                              : MyColor.getTextColor(),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        // Hidden text field for input
        Positioned(
          left: 0,
          top: 0,
          child: SizedBox(
            width: 1,
            height: 1,
            child: TextField(
              controller: _otpController,
              focusNode: _otpFocusNode,
              maxLength: 4,
              keyboardType: TextInputType.number,
              onChanged: _onOtpChanged,
              style: TextStyle(fontSize: 1), // Make text tiny
            ),
          ),
        ),

        SizedBox(height: 24),

        // Resend code button
        TextButton(
          onPressed: isLoading ? null : _sendVerificationEmail,
          child: Text(
            'Resend Verification Code',
            style: TextStyle(
              color: MyColor.getGCoinPrimaryColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        SizedBox(height: 32),

        // Verify button
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
              onTap: isLoading ? null : _verifyEmail,
              child: Center(
                child:
                    isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                          'Verify Email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),
          ),
        ),

        SizedBox(height: 40),

        // Security warning
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
                    child: Icon(Icons.security, color: Colors.white, size: 16),
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
              _buildSecurityPoint('Never share your verification code'),
              SizedBox(height: 8),
              _buildSecurityPoint('The code expires after 10 minutes'),
              SizedBox(height: 8),
              _buildSecurityPoint(
                'Check your spam folder if you don\'t see the email',
              ),
            ],
          ),
        ),
      ],
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

  String _formatVerifiedDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}
