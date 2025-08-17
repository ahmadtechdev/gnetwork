import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../api_service/api_service.dart';
import '../../../utils/ad_helper.dart';
import '../../../utils/app_colors.dart';


class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isRefreshing = false;

  Map<String, dynamic>? _walletData;
  List<dynamic> _transactions = [];
  double _miningBalance = 0.0;
  double _referralBalance = 0.0;

  // Add these ad variables
  BannerAd? _topBannerAd;
  BannerAd? _bottomBannerAd;
  bool _isTopBannerLoaded = false;
  bool _isBottomBannerLoaded = false;
  bool _isLoadingTopBanner = false;
  bool _isLoadingBottomBanner = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadWalletData();

    // Load ads after a small delay
    Future.delayed(Duration(milliseconds: 500), () {
      _loadTopBannerAd();
      _loadBottomBannerAd();
    });
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  Future<void> _loadWalletData() async {
    try {
      final response = await _apiService.getWalletData();
      if (response != null && response.statusCode == 200) {
        setState(() {
          _walletData = response.data;
          _miningBalance = double.parse(_walletData!['user']['mining_balance']);
          _referralBalance = double.parse(_walletData!['user']['referal_balance']);
          _transactions = _walletData!['transactions'] ?? [];
          _isLoading = false;
        });

        _slideController.forward();
        _fadeController.forward();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar('Error', 'Failed to load wallet data');
    }
  }

  Future<void> _refreshWalletData() async {
    setState(() {
      _isRefreshing = true;
    });

    await _loadWalletData();

    setState(() {
      _isRefreshing = false;
    });
  }

  String _getTransactionTypeText(String type) {
    switch (type) {
      case '1':
        return 'Mining Reward';
      case '2':
        return 'Referral Bonus';
      case '3':
        return 'Transfer';
      default:
        return 'Transaction';
    }
  }

  IconData _getTransactionIcon(String type) {
    switch (type) {
      case '1':
        return Icons.diamond;
      case '2':
        return Icons.people;
      case '3':
        return Icons.swap_horiz;
      default:
        return Icons.account_balance_wallet;
    }
  }

  Future<void> _loadTopBannerAd() async {
    if (_isLoadingTopBanner) return;

    _isLoadingTopBanner = true;

    if (_topBannerAd != null) {
      _topBannerAd?.dispose();
      _topBannerAd = null;
      _isTopBannerLoaded = false;
    }

    try {
      final banner = BannerAd(
        adUnitId: AdHelper.walletScreenTopAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (!mounted) {
              ad.dispose();
              return;
            }
            setState(() {
              _topBannerAd = ad as BannerAd;
              _isTopBannerLoaded = true;
              _isLoadingTopBanner = false;
            });
            if (kDebugMode) {
              print('Wallet top banner ad loaded successfully');
            }
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (mounted) {
              setState(() {
                _topBannerAd = null;
                _isTopBannerLoaded = false;
                _isLoadingTopBanner = false;
              });
            }
            if (kDebugMode) {
              print('Wallet top banner ad failed to load: $error');
            }
          },
        ),
      );

      await banner.load();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingTopBanner = false;
        });
      }
      if (kDebugMode) {
        print('Failed to load wallet top banner ad: $e');
      }
    }
  }

  Future<void> _loadBottomBannerAd() async {
    if (_isLoadingBottomBanner) return;

    _isLoadingBottomBanner = true;

    if (_bottomBannerAd != null) {
      _bottomBannerAd?.dispose();
      _bottomBannerAd = null;
      _isBottomBannerLoaded = false;
    }

    try {
      final banner = BannerAd(
        adUnitId: AdHelper.walletScreenBottomAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (!mounted) {
              ad.dispose();
              return;
            }
            setState(() {
              _bottomBannerAd = ad as BannerAd;
              _isBottomBannerLoaded = true;
              _isLoadingBottomBanner = false;
            });
            if (kDebugMode) {
              print('Wallet bottom banner ad loaded successfully');
            }
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (mounted) {
              setState(() {
                _bottomBannerAd = null;
                _isBottomBannerLoaded = false;
                _isLoadingBottomBanner = false;
              });
            }
            if (kDebugMode) {
              print('Wallet bottom banner ad failed to load: $error');
            }
          },
        ),
      );

      await banner.load();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingBottomBanner = false;
        });
      }
      if (kDebugMode) {
        print('Failed to load wallet bottom banner ad: $e');
      }
    }
  }

  Widget _buildTopBannerAd() {
    if (_isTopBannerLoaded && _topBannerAd != null) {
      return Container(
        width: _topBannerAd!.size.width.toDouble(),
        height: _topBannerAd!.size.height.toDouble(),
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 16, bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AdWidget(ad: _topBannerAd!),
        ),
      );
    } else if (_isLoadingTopBanner) {
      return Container(
        width: 320,
        height: 50,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 16, bottom: 16),
        decoration: BoxDecoration(
          color: MyColor.getScreenBgColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CircularProgressIndicator(
          color: MyColor.getGCoinPrimaryColor(),
          strokeWidth: 2,
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildBottomBannerAd() {
    if (_isBottomBannerLoaded && _bottomBannerAd != null) {
      return Container(
        width: _bottomBannerAd!.size.width.toDouble(),
        height: _bottomBannerAd!.size.height.toDouble(),
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 16, bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AdWidget(ad: _bottomBannerAd!),
        ),
      );
    } else if (_isLoadingBottomBanner) {
      return Container(
        width: 320,
        height: 50,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 16, bottom: 16),
        decoration: BoxDecoration(
          color: MyColor.getScreenBgColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CircularProgressIndicator(
          color: MyColor.getGCoinPrimaryColor(),
          strokeWidth: 2,
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    _topBannerAd?.dispose();
    _bottomBannerAd?.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.getScreenBgColor(),
      body: _isLoading
          ? _buildLoadingState()
          : RefreshIndicator(
        onRefresh: _refreshWalletData,
        color: MyColor.getGCoinPrimaryColor(),
        backgroundColor: MyColor.getCardBg(),
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Top Banner Ad - Right after app bar
                  _buildTopBannerAd(),

                  _buildBalanceCards(),
                  SizedBox(height: 20),
                  _buildTransactionSection(),

                  // Bottom Banner Ad - At the bottom
                  _buildBottomBannerAd(),

                  // Add some bottom padding
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: MyColor.getCardBg(),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: MyColor.getGCoinShadowColor(),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(MyColor.getGCoinPrimaryColor()),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Loading Wallet...',
            style: TextStyle(
              color: MyColor.getTextColor(),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: MyColor.getAppbarBgColor(),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'Grow Coin Wallet',
            style: TextStyle(
              color: MyColor.headingTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: MyColor.getGCoinPrimaryGradient(),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: MyColor.getAppbarTitleColor(),
          ),
          onPressed: _refreshWalletData,
        ),
      ],
    );
  }

  Widget _buildBalanceCards() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Total Balance Card
              _buildTotalBalanceCard(),
              SizedBox(height: 20),
              // Balance Breakdown Cards
              Row(
                children: [
                  Expanded(
                    child: _buildBalanceCard(
                      'Mining Balance',
                      _miningBalance,
                      Icons.diamond,
                      MyColor.getGCoinPrimaryColor(),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: _buildBalanceCard(
                      'Referral Balance',
                      _referralBalance,
                      Icons.people,
                      MyColor.getGCoinSecondaryColor(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalBalanceCard() {
    double totalBalance = _miningBalance + _referralBalance;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: MyColor.getGCoinHeroGradient(),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: MyColor.getGCoinPrimaryColor().withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 40,
                ),
                SizedBox(height: 15),
                Text(
                  'Total Balance',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${totalBalance.toStringAsFixed(2)} G',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBalanceCard(String title, double amount, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyColor.getCardBg(),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: MyColor.getGCoinShadowColor(),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(
              color: MyColor.getTextColor().withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '${amount.toStringAsFixed(2)} G',
            style: TextStyle(
              color: MyColor.getTextColor(),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: TextStyle(
                    color: MyColor.getTextColor(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to all transactions
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: MyColor.getGCoinPrimaryColor(),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildTransactionList(),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    if (_transactions.isEmpty) {
      return Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: MyColor.getCardBg(),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: MyColor.getGCoinShadowColor(),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long,
              size: 60,
              color: MyColor.getTextColor().withOpacity(0.3),
            ),
            SizedBox(height: 15),
            Text(
              'No transactions yet',
              style: TextStyle(
                color: MyColor.getTextColor().withOpacity(0.6),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final transaction = _transactions[index];
        return _buildTransactionItem(transaction, index);
      },
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction, int index) {
    final amount = double.parse(transaction['amount']);
    final type = transaction['type'] ?? 'Transaction';
    final remarks = transaction['remarks'] ?? '';
    final createdAt = transaction['created_at'];
    final isPositive = amount > 0;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      margin: EdgeInsets.only(bottom: 15),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: MyColor.getCardBg(),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: MyColor.getGCoinDividerColor(),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: MyColor.getGCoinShadowColor(),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MyColor.getGCoinPrimaryColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                _getTransactionIconByType(type),
                color: MyColor.getGCoinPrimaryColor(),
                size: 24,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          type,
                          style: TextStyle(
                            color: MyColor.getTextColor(),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: (isPositive
                              ? MyColor.getGCoinSuccessColor()
                              : MyColor.getGCoinLossColor()).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${isPositive ? '+' : '-'}${amount.toStringAsFixed(2)} G',
                          style: TextStyle(
                            color: isPositive
                                ? MyColor.getGCoinSuccessColor()
                                : MyColor.getGCoinLossColor(),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    createdAt,
                    style: TextStyle(
                      color: MyColor.getTextColor().withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (remarks.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Text(
                      remarks,
                      style: TextStyle(
                        color: MyColor.getTextColor().withOpacity(0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTransactionIconByType(String type) {
    switch (type.toLowerCase()) {
      case 'commission':
        return Icons.swap_horiz;
      case 'mining reward':
      case 'mining':
        return Icons.diamond;
      case 'referral bonus':
      case 'referral':
        return Icons.people;
      case 'transfer':
        return Icons.swap_horiz;
      case 'bonus':
        return Icons.card_giftcard;
      case 'withdrawal':
        return Icons.arrow_upward;
      case 'deposit':
        return Icons.arrow_downward;
      default:
        return Icons.account_balance_wallet;
    }
  }
}