import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gcoin/screens/drawer/kyc/kyc_screen.dart';
import 'dart:math';

import 'package:gcoin/utils/ad_helper.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/drawer.dart';
import 'animation.dart';
import 'home_controller.dart';

class PiNetworkHomeScreen extends StatefulWidget {
  const PiNetworkHomeScreen({super.key});

  @override
  PiNetworkHomeScreenState createState() => PiNetworkHomeScreenState();
}

class PiNetworkHomeScreenState extends State<PiNetworkHomeScreen>
    with TickerProviderStateMixin {
  final HomeController _homeController = Get.find<HomeController>();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;



  @override
  void initState() {
    super.initState();
    // Initialize animation controllers
    _initializeAnimations();

    // Start animations
    _startAnimations();


  }

  void _initializeAnimations() {
    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.bounceOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
  }


  @override
  void dispose() {

    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_homeController.isLoading.value) {
        return Scaffold(
          backgroundColor: Color(0xFF0D1F0F),
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFF7ED321)),
          ),
        );
      }

      // Add KYC check right after the loading check
      if (_homeController.userData['kyc_form'] == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.to(()=> KYCScreen());
        });
      }

      return Scaffold(
        backgroundColor: Color(0xFF0D1F0F),
        drawer: GNetworkDrawer(),
        body: SafeArea(
          child: RefreshIndicator(
            color: Color(0xFF7ED321),
            backgroundColor: Color(0xFF0D1F0F),
            onRefresh: () async {
              await _homeController.fetchDashboardData();

            },
            child: SingleChildScrollView(
              child: Column(
                children: [

                  // Add KYC message banner if kyc_form is true
                  if (_homeController.userData['kyc_form'] == true &&
                      _homeController.userData['kyc_message'] != null)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: Colors.orange, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _homeController.userData['kyc_message'].toString(),
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                  // Enhanced Header with gradient background
                  _buildEnhancedHeader(),

                  // Stats Cards Section
                  _buildStatsCardsSection(),

                  SizedBox(height: 8),

                  // Enhanced Game Apps Section
                  _buildEnhancedGameAppsSection(),

                  // Pioneer Posts Section
                  _buildPioneerPostsSection(),

                  SizedBox(height: 8),

                             SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: _buildFloatingActionButtons(),
      );
    });
  }

  // Updated _buildEnhancedHeader method
  Widget _buildEnhancedHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7ED321).withOpacity(0.1),
              Color(0xFF4CAF50).withOpacity(0.05),
              Color(0xFF0D1F0F),
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Column(
          children: [
            // Top navigation bar with slide animation
            SlideTransition(
              position: _slideAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: IconButton(
                          onPressed: () => Scaffold.of(context).openDrawer(),
                          icon: Icon(
                            Icons.menu_rounded,
                            color: Color(0xFFE8F5E8),
                            size: 32,
                          ),
                        ),
                      );
                    },
                  ),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF1B2E1C),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0xFF7ED321).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'EN',
                              style: TextStyle(
                                color: Color(0xFFE8F5E8),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.language_rounded,
                              color: Color(0xFF7ED321),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // G Balance Section with digit animation
            ScaleTransition(
              scale: _scaleAnimation,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF7ED321).withOpacity(0.15),
                            Color(0xFF4CAF50).withOpacity(0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Color(0xFF7ED321).withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF7ED321).withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Animated Balance Display with Digit Animation
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              // Use Obx to watch the animated balance changes
                              Obx(() {
                                final displayValue =
                                    _homeController.isMining.value
                                        ? _homeController.getAnimatedBalance()
                                        : double.parse(
                                          _homeController.getBalance(),
                                        ).toStringAsFixed(3);

                                return AnimatedDigitDisplay(
                                  value: displayValue,
                                  duration: Duration(milliseconds: 600),
                                  textStyle: TextStyle(
                                    color: Color(0xFFE8F5E8),
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                    shadows: [
                                      Shadow(
                                        color: Color(
                                          0xFF7ED321,
                                        ).withOpacity(0.3),
                                        offset: Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              SizedBox(width: 8),
                              AnimatedBuilder(
                                animation: _rotationController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle:
                                        _rotationAnimation.value * 2 * 3.14159,
                                    child: Text(
                                      'G',
                                      style: TextStyle(
                                        color: Color(0xFF7ED321),
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: Color(
                                              0xFF7ED321,
                                            ).withOpacity(0.5),
                                            offset: Offset(0, 2),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: 8),

                          // Balance Label with Mining Status
                          Obx(() {
                            return Column(
                              children: [
                                Text(
                                  _homeController.isMining.value
                                      ? 'Gaming Balance'
                                      : 'Available Balance',
                                  style: TextStyle(
                                    color: Color(0xFFCED9CE),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                // Mining Progress Indicator
                                if (_homeController.isMining.value) ...[
                                  SizedBox(height: 12),
                                  Container(
                                    width: double.infinity,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF1B2E1C),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor:
                                          _homeController.getMiningProgress(),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF7ED321),
                                              Color(0xFF4CAF50),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(
                                                0xFF7ED321,
                                              ).withOpacity(0.4),
                                              blurRadius: 4,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Earned: ${_homeController.getEstimatedReward()} G',
                                        style: TextStyle(
                                          color: Color(0xFF7ED321),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Rate: ${(_homeController.userData['mine_rate'])} G/ ${(int.parse(_homeController.userData['total_mine_time'])/60).toStringAsFixed(0)}m',
                                        style: TextStyle(
                                          color: Color(0xFFCED9CE),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCardsSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 600),
              // delay: Duration(milliseconds: 200),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 50 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: _buildStatCard(
                      icon: Icons.security_rounded,
                      title: 'Security',
                      value: '20%',
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 600),
              // delay: Duration(milliseconds: 400),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 50 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: _buildStatCard(
                      icon: Icons.flash_on_rounded,
                      title: 'Gaming Rate',
                      value: '${(_homeController.userData['mine_rate'])} G/ ${(int.parse(_homeController.userData['total_mine_time'])/60).toStringAsFixed(0)}m',
                      color: Color(0xFF7ED321),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 600),
              // delay: Duration(milliseconds: 600),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 50 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: _buildStatCard(
                      icon: Icons.people_rounded,
                      title: 'Network',
                      value: _homeController.getNetworkCount(),
                      color: Color(0xFF66BB6A),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1B2E1C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 800),
            builder: (context, animationValue, child) {
              return Transform.scale(
                scale: 0.5 + (0.5 * animationValue),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
              );
            },
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFFE8F5E8),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFFCED9CE),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedGameAppsSection() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1000),
      // delay: Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 100 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF7ED321).withOpacity(0.12),
                    Color(0xFF4CAF50).withOpacity(0.08),
                    Color(0xFF2E7D32).withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color(0xFF7ED321).withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF7ED321).withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Game Apps',
                    style: TextStyle(
                      color: Color(0xFFE8F5E8),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'in the Grow Network Ecosystem',
                    style: TextStyle(
                      color: Color(0xFF7ED321),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 32),

                  // Enhanced game icons with floating animation
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          0,
                          5 * sin(_pulseController.value * 2 * 3.14159),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF8BC34A).withOpacity(0.3),
                                    Color(0xFF66BB6A).withOpacity(0.2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Color(0xFF7ED321).withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF7ED321).withOpacity(0.2),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.sports_esports_rounded,
                                color: Color(0xFF7ED321),
                                size: 40,
                              ),
                            ),
                            SizedBox(width: 24),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF7ED321),
                                    Color(0xFF4CAF50),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF7ED321).withOpacity(0.4),
                                    blurRadius: 16,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Text(
                                'G',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 24),

                  Text(
                    'Build games on Grow Network &',
                    style: TextStyle(
                      color: Color(0xFFCED9CE),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Play the new FruityG Game!',
                    style: TextStyle(
                      color: Color(0xFFE8F5E8),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildModernButton('Learn More', false),
                      _buildModernButton('FruityG', true),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernButton(String text, bool isPrimary) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Container(
            decoration: BoxDecoration(
              gradient:
                  isPrimary
                      ? LinearGradient(
                        colors: [Color(0xFF7ED321), Color(0xFF4CAF50)],
                      )
                      : null,
              color: isPrimary ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(25),
              border:
                  isPrimary
                      ? null
                      : Border.all(color: Color(0xFF7ED321), width: 2),
              boxShadow:
                  isPrimary
                      ? [
                        BoxShadow(
                          color: Color(0xFF7ED321).withOpacity(0.3),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ]
                      : null,
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isPrimary ? Colors.white : Color(0xFF7ED321),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Update _buildFloatingActionButtons in homescreen.dart
  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildAnimatedStatFAB(
          icon: Icons.security_rounded,
          value: '20%',
          backgroundColor: Color(0xFF4CAF50),
          delay: 200,
        ),
        SizedBox(height: 12),
        _buildAnimatedStatFAB(
          icon: Icons.people_outline_rounded,
          value: _homeController.getNetworkCount(),
          backgroundColor: Color(0xFF66BB6A),
          delay: 400,
        ),
        SizedBox(height: 12),
        _buildMiningFAB(),
        SizedBox(height: 12),
        _buildAnimatedFAB(
          icon: Icons.send_rounded,
          backgroundColor: Color(0xFF7ED321),
          iconColor: Colors.white,
          heroTag: "invite",
          label: 'Invite',
          delay: 800,
          onPressed: () {
            _homeController.shareReferralCode();
          },
        ),
      ],
    );
  }

  // Update _buildMiningFAB to include onTap
  Widget _buildMiningFAB() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(100 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: GestureDetector(
              onTap: () {
                if (!_homeController.isMining.value) {
                  // Changed from startMining() to startMiningWithGame()
                  _homeController.startMiningWithGame(context);
                } else {
                  Get.snackbar(
                    'Game  in Progress',
                    'Please wait until current gaming completes',
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      _homeController.isMining.value
                          ? Colors.orange
                          : Color(0xFF7ED321),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: (_homeController.isMining.value
                              ? Colors.orange
                              : Color(0xFF7ED321))
                          .withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.flash_on_rounded, color: Colors.white, size: 18),
                    SizedBox(height: 4),
                    Obx(
                      () => Text(
                        _homeController.isMining.value
                            ? _homeController.formatTime(
                              _homeController.miningTimeLeft.value,
                            )
                            : '${(_homeController.userData['mine_rate'])} G/ ${(int.parse(_homeController.userData['total_mine_time'])/60).toStringAsFixed(0)}m',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedFAB({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required String heroTag,
    String? label,
    int delay = 0,
    VoidCallback? onPressed, // Add this parameter
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(100 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: backgroundColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: onPressed, // Use the passed callback
                backgroundColor: backgroundColor,
                elevation: 0,
                mini: true,
                heroTag: heroTag,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child:
                    label != null
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icon, color: iconColor, size: 16),
                            Text(
                              label,
                              style: TextStyle(
                                color: iconColor,
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                        : Icon(icon, color: iconColor, size: 20),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedStatFAB({
    required IconData icon,
    required String value,
    required Color backgroundColor,
    int delay = 0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600),
      builder: (context, animationValue, child) {
        return Transform.translate(
          offset: Offset(100 * (1 - animationValue), 0),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: backgroundColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(icon, color: Colors.white, size: 18),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPioneerPostsSection() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1000),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enhanced Post description with modern card design
                  // Container(
                  //   padding: EdgeInsets.all(20),
                  //   decoration: BoxDecoration(
                  //     color: Color(0xFF1B2E1C),
                  //     borderRadius: BorderRadius.circular(16),
                  //     border: Border.all(
                  //       color: Color(0xFF7ED321).withOpacity(0.2),
                  //       width: 1,
                  //     ),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Color(0xFF7ED321).withOpacity(0.1),
                  //         blurRadius: 12,
                  //         offset: Offset(0, 4),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Row(
                  //         children: [
                  //           Container(
                  //             padding: EdgeInsets.symmetric(
                  //               horizontal: 12,
                  //               vertical: 6,
                  //             ),
                  //             decoration: BoxDecoration(
                  //               gradient: LinearGradient(
                  //                 colors: [
                  //                   Color(0xFF7ED321),
                  //                   Color(0xFF4CAF50),
                  //                 ],
                  //               ),
                  //               borderRadius: BorderRadius.circular(12),
                  //             ),
                  //             child: Text(
                  //               '@PiCoreTeam',
                  //               style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 12,
                  //               ),
                  //             ),
                  //           ),
                  //           Spacer(),
                  //           Text(
                  //             'May 30th - 9:56pm',
                  //             style: TextStyle(
                  //               color: Color(0xFFCED9CE),
                  //               fontSize: 12,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       SizedBox(height: 16),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 20),

                  // Enhanced interaction buttons with wave animation
                  _buildPioneerPostsSectioncard(),

                  // Trending Topics Section with particle effect
                  _buildTrendingTopicsSection(),

                  // Community Stats with animated counters
                  _buildCommunityStatsSection(),

                  SizedBox(height: 20),

                  // Recent Activities Timeline
                  _buildRecentActivitiesSection(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPioneerPostsSectioncard() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Post description with modern card design

          // Pioneer Posts Header
          Row(
            children: [
              Text(
                'Pioneer Posts',
                style: TextStyle(
                  color: Color(0xFF7ED321),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF7ED321)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '?',
                  style: TextStyle(color: Color(0xFF7ED321), fontSize: 12),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Column(
            children:
                _homeController.posts
                    .map(
                      (post) => _buildPioneerPostCard(
                        title: post['title'],

                        description: post['content'],
                        likes: int.tryParse(post['like'] ?? '0') ?? 0,
                        imageUrl: post['image'],
                        shares:
                            int.tryParse(post['share'] ?? '0') ??
                            0, // Pass the image URL from API response
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPioneerPostCard({
    required String title,
    required String description,
    required int likes,
    required int shares,
    required String imageUrl,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Color(0xFF1B2E1C),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF7ED321).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container with Gradient Background
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF7ED321).withOpacity(0.3),
                  Color(0xFF4CAF50).withOpacity(0.1),
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  // Image with shimmer loading effect
                  if (imageUrl.isNotEmpty)
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Shimmer.fromColors(
                          baseColor: Color(0xFF1B2E1C),
                          highlightColor: Color(0xFF7ED321).withOpacity(0.2),
                          child: Container(color: Colors.white),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Color(0xFF7ED321).withOpacity(0.3),
                            size: 50,
                          ),
                        );
                      },
                    ),

                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),

                  // Floating tag
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF7ED321),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        'Grow Network',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content Section
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFFE8F5E8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),

                SizedBox(height: 12),

                // Description (only if not "none")
                if (description.isNotEmpty && description != "none")
                  Text(
                    description,
                    style: TextStyle(
                      color: Color(0xFFCED9CE),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    // Like Button
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Color(0xFF7ED321).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFF7ED321).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              // Handle like action
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    color: Color(0xFF7ED321),
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '$likes',
                                    style: TextStyle(
                                      color: Color(0xFFE8F5E8),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12),

                    // Share Button
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Color(0xFF7ED321).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFF7ED321).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              // Handle share action
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.share,
                                    color: Color(0xFF7ED321),
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '$shares',
                                    style: TextStyle(
                                      color: Color(0xFFE8F5E8),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingTopicsSection() {
    final topics = [
      '#GrowNetwork',
      '#GamingCommunity',
      '#PlayAndEarn',
      '#GamingCoins',
      '#FunWithFriends',
      '#DailyRewards',
      '#GameTogether'
    ];

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1000),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-50 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1B2E1C),
                    Color(0xFF0D1F0F).withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xFF7ED321).withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF7ED321).withOpacity(0.05),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF7ED321), Color(0xFF4CAF50)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.trending_up_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Trending Topics',
                        style: TextStyle(
                          color: Color(0xFFE8F5E8),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        topics.asMap().entries.map((entry) {
                          int index = entry.key;
                          String topic = entry.value;
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: Duration(milliseconds: 600),
                            builder: (context, animValue, child) {
                              return Transform.scale(
                                scale: 0.5 + (0.5 * animValue),
                                child: AnimatedBuilder(
                                  animation: _pulseController,
                                  builder: (context, child) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF7ED321).withOpacity(
                                              0.15 +
                                                  0.05 *
                                                      sin(
                                                        _pulseController.value *
                                                                2 *
                                                                pi +
                                                            index,
                                                      ),
                                            ),
                                            Color(0xFF4CAF50).withOpacity(
                                              0.1 +
                                                  0.03 *
                                                      cos(
                                                        _pulseController.value *
                                                                2 *
                                                                pi +
                                                            index,
                                                      ),
                                            ),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Color(
                                            0xFF7ED321,
                                          ).withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        topic,
                                        style: TextStyle(
                                          color: Color(0xFF7ED321),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommunityStatsSection() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1200),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 80 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.5,
                  colors: [
                    Color(0xFF7ED321).withOpacity(0.1),
                    Color(0xFF4CAF50).withOpacity(0.05),
                    Color(0xFF0D1F0F),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color(0xFF7ED321).withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF7ED321).withOpacity(0.1),
                    blurRadius: 25,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Community Impact',
                    style: TextStyle(
                      color: Color(0xFFE8F5E8),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildAnimatedStat(
                        '72K+',
                        'App installation',
                        Icons.people_rounded,
                        Color(0xFF7ED321),
                      ),
                      _buildAnimatedStat(
                        '230+',
                        'Countries',
                        Icons.public_rounded,
                        Color(0xFF4CAF50),
                      ),
                      _buildAnimatedStat(
                        '70K+',
                        'App User',
                        Icons.apps_rounded,
                        Color(0xFF66BB6A),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedStat(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1500),
      builder: (context, animValue, child) {
        return Column(
          children: [
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: sin(_rotationController.value * 2 * pi) * 0.05,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 32),
                  ),
                );
              },
            ),
            SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0.0,
                end: double.parse(value.replaceAll(RegExp(r'[^0-9.]'), '')),
              ),
              duration: Duration(seconds: 2),
              builder: (context, animatedValue, child) {
                String displayValue;
                if (value.contains('M')) {
                  displayValue = '${(animatedValue).toStringAsFixed(0)}M+';
                } else if (value.contains('K')) {
                  displayValue = '${(animatedValue).toStringAsFixed(0)}K+';
                } else {
                  displayValue = '${animatedValue.toInt()}+';
                }
                return Text(
                  displayValue,
                  style: TextStyle(
                    color: Color(0xFFE8F5E8),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            Text(
              label,
              style: TextStyle(
                color: Color(0xFFCED9CE),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecentActivitiesSection() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1000),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(100 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF1B2E1C),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xFF7ED321).withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF7ED321).withOpacity(0.08),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF7ED321), Color(0xFF4CAF50)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.history_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Recent Activities',
                        style: TextStyle(
                          color: Color(0xFFE8F5E8),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ..._homeController.logs.map(
                    (log) => Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF7ED321).withOpacity(0.05),
                            Color(0xFF4CAF50).withOpacity(0.03),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(0xFF7ED321).withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFF7ED321).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.notifications_rounded,
                              color: Color(0xFF7ED321),
                              size: 16,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Color(0xFFE8F5E8),
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: log['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF7ED321),
                                        ),
                                      ),
                                      TextSpan(text: ' ${log['action']}'),
                                    ],
                                  ),
                                ),
                                Text(
                                  log['created_at'],
                                  style: TextStyle(
                                    color: Color(0xFFCED9CE),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
