import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../api_service/api_service.dart';
import '../../../utils/ad_helper.dart';
import '../../../utils/app_colors.dart';

class WithdrawScreen extends StatefulWidget {
  final double? currentBalance;

  const WithdrawScreen({Key? key, this.currentBalance}) : super(key: key);

  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _successController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _successAnimation;

  final ApiService _apiService = ApiService();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isSuccess = false;
  double _currentBalance = 0.0;
  String _responseMessage = '';
  bool _showResponseMessage = false;

  // Add banner ad variables
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;
  bool _isLoadingBanner = false;

  // Quick amount options
  final List<double> _quickAmounts = [3000, 5000, 10000, 25000, 50000];

  @override
  void initState() {
    super.initState();
    _currentBalance = widget.currentBalance ?? 0.0;
    _initializeAnimations();
    _loadCurrentBalance();

    // Load banner ad after a small delay
    Future.delayed(Duration(milliseconds: 500), _loadBannerAd);
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

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _successController = AnimationController(
      duration: Duration(milliseconds: 1200),
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

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _successAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _slideController.forward();
    _fadeController.forward();
    _scaleController.forward();
  }

  Future<void> _loadCurrentBalance() async {
    if (_currentBalance == 0.0) {
      try {
        final response = await _apiService.getWalletData();
        if (response != null && response.statusCode == 200) {
          final data = response.data;
          setState(() {
            _currentBalance = double.parse(data['user']['mining_balance']) +
                double.parse(data['user']['referal_balance']);
          });
        }
      } catch (e) {
        // Handle error silently or show message
      }
    }
  }

  Future<void> _processWithdrawal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _showResponseMessage = false;
    });

    try {
      final response = await _apiService.withdrawGCoin(
        amount: _amountController.text.trim(),
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;

        setState(() {
          _isLoading = false;
          _responseMessage = data['message'];
          _showResponseMessage = true;
          _isSuccess = data['success'] == true;
        });

        if (_isSuccess) {
          // Update balance if provided in response
          if (data.containsKey('new_balance')) {
            setState(() {
              _currentBalance = double.parse(data['new_balance'].toString());
            });
          }

          // Start success animation
          _successController.forward();

          // Clear form after successful withdrawal
          _amountController.clear();

          // Show success message
          Get.snackbar(
            'Success',
            _responseMessage,
            backgroundColor: MyColor.getGCoinSuccessColor(),
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
          );
        } else {
          // Show error message
          Get.snackbar(
            'Error',
            _responseMessage,
            backgroundColor: MyColor.getGCoinLossColor(),
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _responseMessage = 'An unexpected error occurred. Please try again.';
        _showResponseMessage = true;
        _isSuccess = false;
      });

      Get.snackbar(
        'Error',
        _responseMessage,
        backgroundColor: MyColor.getGCoinLossColor(),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void _selectQuickAmount(double amount) {
    setState(() {
      _amountController.text = amount.toStringAsFixed(0);
    });
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid number';
    }

    if (amount < 3000) {
      return 'Minimum withdrawal amount is 3000 G';
    }

    if (amount > _currentBalance) {
      return 'Insufficient balance';
    }

    return null;
  }

  Future<void> _loadBannerAd() async {
    if (_isLoadingBanner) return;

    _isLoadingBanner = true;

    if (_bannerAd != null) {
      _bannerAd?.dispose();
      _bannerAd = null;
      _isBannerLoaded = false;
    }

    try {
      final banner = BannerAd(
        adUnitId: AdHelper.withdrawScreenAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (!mounted) {
              ad.dispose();
              return;
            }
            setState(() {
              _bannerAd = ad as BannerAd;
              _isBannerLoaded = true;
              _isLoadingBanner = false;
            });
            if (kDebugMode) {
              print('Withdraw screen banner ad loaded successfully');
            }
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (mounted) {
              setState(() {
                _bannerAd = null;
                _isBannerLoaded = false;
                _isLoadingBanner = false;
              });
            }
            if (kDebugMode) {
              print('Withdraw screen banner ad failed to load: $error');
            }
          },
        ),
      );

      await banner.load();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingBanner = false;
        });
      }
      if (kDebugMode) {
        print('Failed to load withdraw screen banner ad: $e');
      }
    }
  }

  Widget _buildBannerAd() {
    if (_isBannerLoaded && _bannerAd != null) {
      return Container(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 20),
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
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    } else if (_isLoadingBanner) {
      return Container(
        width: 320,
        height: 50,
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 20),
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
    _bannerAd?.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _successController.dispose();
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.getScreenBgColor(),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banner Ad - Above balance card
              _buildBannerAd(),

              _buildBalanceCard(),
              SizedBox(height: 30),
              _buildWithdrawForm(),
              SizedBox(height: 30),
              _buildQuickAmountSection(),
              SizedBox(height: 40),
              _buildWithdrawButton(),
              if (_showResponseMessage) ...[
                SizedBox(height: 20),
                _buildResponseMessage(),
              ],
              if (_isSuccess) ...[
                SizedBox(height: 30),
                _buildSuccessAnimation(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: MyColor.getAppbarBgColor(),
      elevation: 0,
      title: FadeTransition(
        opacity: _fadeAnimation,
        child: Text(
          'Withdraw G Coins',
          style: TextStyle(
            color: MyColor.getAppbarTitleColor(),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: MyColor.getAppbarTitleColor(),
        ),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            gradient: MyColor.getGCoinPrimaryGradient(),
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
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
                size: 40,
              ),
              SizedBox(height: 15),
              Text(
                'Available Balance',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${_currentBalance.toStringAsFixed(2)} G',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWithdrawForm() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: EdgeInsets.all(25),
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Withdrawal Amount',
                style: TextStyle(
                  color: MyColor.getTextColor(),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _amountController,
                focusNode: _amountFocusNode,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: _validateAmount,
                style: TextStyle(
                  color: MyColor.getTextColor(),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter amount to withdraw',
                  hintStyle: TextStyle(
                    color: MyColor.getTextFieldHintColor(),
                  ),
                  prefixIcon: Container(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'G',
                      style: TextStyle(
                        color: MyColor.getGCoinPrimaryColor(),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: MyColor.getTextFieldBg(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: MyColor.getFieldDisableBorderColor(),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: MyColor.getFieldEnableBorderColor(),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: MyColor.getFieldDisableBorderColor(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Minimum withdrawal: 3000 G',
                style: TextStyle(
                  color: MyColor.getTextColor().withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAmountSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Amount',
            style: TextStyle(
              color: MyColor.getTextColor(),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _quickAmounts.map((amount) {
              return GestureDetector(
                onTap: () => _selectQuickAmount(amount),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: _amountController.text == amount.toStringAsFixed(0)
                        ? MyColor.getGCoinPrimaryColor()
                        : MyColor.getCardBg(),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: MyColor.getGCoinPrimaryColor().withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: MyColor.getGCoinShadowColor(),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '${amount.toStringAsFixed(0)} G',
                    style: TextStyle(
                      color: _amountController.text == amount.toStringAsFixed(0)
                          ? Colors.white
                          : MyColor.getTextColor(),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawButton() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _processWithdrawal,
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColor.getGCoinPrimaryColor(),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            shadowColor: MyColor.getGCoinPrimaryColor().withOpacity(0.3),
          ),
          child: _isLoading
              ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
          )
              : Text(
            'Withdraw G Coins',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponseMessage() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isSuccess
            ? MyColor.getGCoinSuccessColor().withOpacity(0.1)
            : MyColor.getGCoinLossColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _isSuccess
              ? MyColor.getGCoinSuccessColor()
              : MyColor.getGCoinLossColor(),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isSuccess ? Icons.check_circle : Icons.error,
            color: _isSuccess
                ? MyColor.getGCoinSuccessColor()
                : MyColor.getGCoinLossColor(),
            size: 24,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              _responseMessage,
              style: TextStyle(
                color: _isSuccess
                    ? MyColor.getGCoinSuccessColor()
                    : MyColor.getGCoinLossColor(),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessAnimation() {
    return AnimatedBuilder(
      animation: _successAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _successAnimation.value,
          child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: MyColor.getGCoinSuccessColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: MyColor.getGCoinSuccessColor(),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle,
                  color: MyColor.getGCoinSuccessColor(),
                  size: 60,
                ),
                SizedBox(height: 15),
                Text(
                  'Withdrawal Successful!',
                  style: TextStyle(
                    color: MyColor.getGCoinSuccessColor(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Your G Coins have been successfully withdrawn.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MyColor.getTextColor().withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}