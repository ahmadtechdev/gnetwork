import 'package:flutter/material.dart';
import 'dart:math';

import 'package:gcoin/screens/drawer/refferal_team.dart';
import 'package:get/get.dart';

class PiNetworkHomeScreen extends StatefulWidget {
  @override
  _PiNetworkHomeScreenState createState() => _PiNetworkHomeScreenState();
}

class _PiNetworkHomeScreenState extends State<PiNetworkHomeScreen>
    with TickerProviderStateMixin {
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

    // Start animations
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
    return Scaffold(
      backgroundColor: Color(0xFF0D1F0F),
      drawer: PiNetworkDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Enhanced Header with gradient background
              _buildEnhancedHeader(),

              // Stats Cards Section
              _buildStatsCardsSection(),

              // Enhanced Game Apps Section
              _buildEnhancedGameAppsSection(),

              // Pioneer Posts Section
              _buildPioneerPostsSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

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
                        child: GestureDetector(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: Duration(milliseconds: 300),
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: 0.9 + (0.1 * value),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF1B2E1C),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Color(0xFF7ED321).withOpacity(0.3),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(
                                          0xFF7ED321,
                                        ).withOpacity(0.2 * value),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.menu_rounded,
                                    color: Color(0xFF7ED321),
                                    size: 24,
                                  ),
                                ),
                              );
                            },
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

            // Pi Balance Section with scale animation
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 122.34280),
                                duration: Duration(seconds: 2),
                                builder: (context, value, child) {
                                  return Text(
                                    value.toStringAsFixed(5),
                                    style: TextStyle(
                                      color: Color(0xFFE8F5E8),
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 8),
                              AnimatedBuilder(
                                animation: _rotationController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle:
                                        _rotationAnimation.value * 2 * 3.14159,
                                    child: Text(
                                      'π',
                                      style: TextStyle(
                                        color: Color(0xFF7ED321),
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Available Balance',
                            style: TextStyle(
                              color: Color(0xFFCED9CE),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
                      title: 'Mining Rate',
                      value: '0.00 π/h',
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
                      value: '0/1',
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
                    'in the Pi Ecosystem',
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
                                'π',
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
                    'Build games on Pi &',
                    style: TextStyle(
                      color: Color(0xFFCED9CE),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Play the new FruityPi Game!',
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
                      _buildModernButton('FruityPi', true),
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

  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Chat Button
        _buildAnimatedFAB(
          icon: Icons.chat_bubble_outline_rounded,
          backgroundColor: Color(0xFF1B2E1C),
          iconColor: Color(0xFF7ED321),
          heroTag: "chat",
          delay: 0,
        ),
        SizedBox(height: 12),

        // Shield Button
        _buildAnimatedStatFAB(
          icon: Icons.security_rounded,
          value: '20%',
          backgroundColor: Color(0xFF4CAF50),
          delay: 200,
        ),
        SizedBox(height: 12),

        // People Button
        _buildAnimatedStatFAB(
          icon: Icons.people_outline_rounded,
          value: '0/1',
          backgroundColor: Color(0xFF66BB6A),
          delay: 400,
        ),
        SizedBox(height: 12),

        // Mining Rate Button
        _buildAnimatedStatFAB(
          icon: Icons.flash_on_rounded,
          value: '0.00 π/h',
          backgroundColor: Color(0xFF7ED321),
          delay: 600,
        ),
        SizedBox(height: 12),

        // Invite Button
        _buildAnimatedFAB(
          icon: Icons.send_rounded,
          backgroundColor: Color(0xFF7ED321),
          iconColor: Colors.white,
          heroTag: "invite",
          label: 'Invite',
          delay: 800,
        ),
      ],
    );
  }

  Widget _buildAnimatedFAB({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required String heroTag,
    String? label,
    int delay = 0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600),
      // delay: Duration(milliseconds: delay),
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
                onPressed: () {},
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
                  Container(
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
                          color: Color(0xFF7ED321).withOpacity(0.1),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF7ED321),
                                    Color(0xFF4CAF50),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '@PiCoreTeam',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Spacer(),
                            Text(
                              'May 30th - 9:56pm',
                              style: TextStyle(
                                color: Color(0xFFCED9CE),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),

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

          // Pioneer Post Cards (keeping existing implementation)
          _buildPioneerPostCard(
            username: '@ron123cash',
            tag: '#PiArt',
            date: '7 May',
            title: 'GLOBAL PI MARKET',
            subtitle: 'GPM',
            description:
                'MAINNET ECOSYSTEM LISTED\nBuyer Protection & Seller Reviews\nglobalpimarket.com',
            likes: 3988,
            comments: 23689,
            backgroundColor: Colors.lightBlue[200]!,
          ),

          SizedBox(height: 16),
          _buildPioneerPostCard(
            username: '@ron123cash',
            tag: '#PiArt',
            date: '8 May',
            title: 'GLOBAL PI MARKET',
            subtitle: 'GPM',
            description:
                'MAINNET ECOSYSTEM LISTED\nBuyer Protection & Seller Reviews\nglobalpimarket.com',
            likes: 3988,
            comments: 23689,
            backgroundColor: Colors.lightBlue[200]!,
          ),
        ],
      ),
    );
  }

  Widget _buildPioneerPostCard({
    required String username,
    required String tag,
    required String date,
    required String title,
    required String subtitle,
    required String description,
    required int likes,
    required int comments,
    required Color backgroundColor,
    bool isVPSCard = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1B2E1C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF7ED321).withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF7ED321).withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7ED321), Color(0xFF4CAF50)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  username[1].toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Text(
                username,
                style: TextStyle(
                  color: Color(0xFFE8F5E8),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF7ED321).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: Color(0xFF7ED321),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Spacer(),
              Text(
                date,
                style: TextStyle(color: Color(0xFFCED9CE), fontSize: 12),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Content Card (keeping existing implementation but with updated colors)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                isVPSCard
                    ? Column(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue[800],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.computer,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    )
                    : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'GLOBAL PI MARKET',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 3),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'GPM',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'π',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'MAINNET ECOSYSTEM LISTED\nBuyer Protection & Seller Reviews\nglobalpimarket.com',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
          ),

          if (!isVPSCard) ...[
            SizedBox(height: 16),
            Text(
              'Join the future and boost the\necosystem 🚀🚀🚀',
              style: TextStyle(color: Color(0xFFE8F5E8), fontSize: 14),
            ),

            SizedBox(height: 16),

            // Actions with updated colors
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF7ED321).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '−',
                    style: TextStyle(
                      color: Color(0xFF7ED321),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        likes.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF7ED321).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '+',
                    style: TextStyle(
                      color: Color(0xFF7ED321),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  '$comments 💬',
                  style: TextStyle(color: Color(0xFFCED9CE), fontSize: 12),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
    int delay = 0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800),
      // delay: Duration(milliseconds: delay),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.3 + (0.7 * value),
          child: GestureDetector(
            onTap: () {
              // Add haptic feedback
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.3), width: 1),
              ),
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _rotationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: sin(_rotationController.value * 2 * pi) * 0.1,
                        child: Icon(icon, color: color, size: 20),
                      );
                    },
                  ),
                  SizedBox(height: 4),
                  TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: 0.0,
                      end: double.parse(
                        count.replaceAll('K', '000').replaceAll('.', ''),
                      ),
                    ),
                    duration: Duration(seconds: 2),
                    builder: (context, animatedCount, child) {
                      String displayCount = count;
                      if (count.contains('K')) {
                        displayCount =
                            '${(animatedCount / 1000).toStringAsFixed(1)}K';
                      } else {
                        displayCount = animatedCount.toInt().toString();
                      }
                      return Text(
                        displayCount,
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      color: Color(0xFFCED9CE),
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
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

  Widget _buildTrendingTopicsSection() {
    final topics = [
      '#PiNetwork',
      '#Blockchain',
      '#Cryptocurrency',
      '#FruityPi',
      '#Mining',
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
                        '47M+',
                        'Pioneers',
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
                        '15K+',
                        'Apps',
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
    final activities = [
      {
        'user': 'Alex',
        'action': 'started mining',
        'time': '2m ago',
        'icon': Icons.flash_on_rounded,
      },
      {
        'user': 'Maria',
        'action': 'joined security circle',
        'time': '5m ago',
        'icon': Icons.security_rounded,
      },
      {
        'user': 'John',
        'action': 'played FruityPi',
        'time': '12m ago',
        'icon': Icons.sports_esports_rounded,
      },
      {
        'user': 'Sarah',
        'action': 'invited 3 friends',
        'time': '1h ago',
        'icon': Icons.person_add_rounded,
      },
    ];

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
                  ...activities.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> activity = entry.value;
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 600),
                      builder: (context, animValue, child) {
                        return Transform.translate(
                          offset: Offset(30 * (1 - animValue), 0),
                          child: Opacity(
                            opacity: animValue,
                            child: Container(
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
                                  AnimatedBuilder(
                                    animation: _pulseController,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale:
                                            1.0 +
                                            0.1 *
                                                sin(
                                                  _pulseController.value *
                                                          2 *
                                                          pi +
                                                      index,
                                                ),
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Color(
                                              0xFF7ED321,
                                            ).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Icon(
                                            activity['icon'] as IconData,
                                            color: Color(0xFF7ED321),
                                            size: 16,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              color: Color(0xFFE8F5E8),
                                              fontSize: 14,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: activity['user'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF7ED321),
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' ${activity['action']}',
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          activity['time'],
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
                        );
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PiNetworkDrawer extends StatelessWidget {
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
                      'π',
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
                        'Pi Network',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Pioneer Dashboard',
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
                    Icons.account_balance_wallet_rounded,
                    'Wallet',
                    false,
                    null,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.security_rounded,
                    'Security Circle',
                    false,
                    null,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.sports_esports_rounded,
                    'Games',
                    false,
                    null,
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
                    Icons.person_rounded,
                    'Profile',
                    false,
                    null,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.settings_rounded,
                    'Settings',
                    false,
                    null,
                  ),
                  Divider(color: Color(0xFF7ED321).withOpacity(0.2)),
                  _buildDrawerItem(
                    context,
                    Icons.help_outline_rounded,
                    'Help & Support',
                    false,
                    null,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.logout_rounded,
                    'Logout',
                    false,
                    null,
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

// MyColor class reference (you already have this in your project)
