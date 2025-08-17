import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';
import '../../../api_service/api_service.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/custom_snackbar.dart';
import 'profile_controller.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _walletAddressController = TextEditingController();
  final _phoneController = TextEditingController();

  final ApiService _apiService = ApiService();
  final ProfileController profileController = Get.put(ProfileController());

  String selectedWalletType = 'BEP-20'; // Default value
  Country selectedCountry = Country.parse('GB');

  bool _isLoading = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUserData();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  void _loadUserData() {
    // Load existing user data if available
    String? walletType = profileController.userProfile['wallet_type'];

    // Fix: Ensure selectedWalletType is always a valid option
    if (walletType != null && (walletType == 'BEP-20' || walletType == 'TRC-20')) {
      selectedWalletType = walletType;
    } else {
      selectedWalletType = 'BEP-20'; // Default fallback
    }

    _walletAddressController.text = profileController.userProfile['wallet_address'] ?? "";
    _nameController.text = profileController.userProfile['name'] ?? "";
    _phoneController.text = profileController.userProfile['phone'] ?? "";
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _nameController.dispose();
    _walletAddressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Function to remove leading zeros from phone number
  String _removeLeadingZeros(String phoneNumber) {
    if (phoneNumber.isEmpty) return phoneNumber;

    // Remove leading zeros
    String cleaned = phoneNumber.replaceFirst(RegExp(r'^0+'), '');

    // If all digits were zeros, return a single zero
    if (cleaned.isEmpty) return '0';

    return cleaned;
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Remove leading zeros from phone number before sending
      String cleanedPhone = _removeLeadingZeros(_phoneController.text);
      final fullPhoneNumber = '${selectedCountry.phoneCode}$cleanedPhone';

      final response = await _apiService.updateProfile(
        name: _nameController.text.trim(),
        walletAddress: _walletAddressController.text.trim(),
        phone: fullPhoneNumber,
        walletType: selectedWalletType,
      );

      if (response != null && response.statusCode == 200) {
        CustomSnackBar.success(
          'Profile updated successfully',
          title: 'Success',
        );
        Get.back();
      }
    } catch (e) {
      CustomSnackBar.error(
        'Failed to update profile. Please try again.',
        title: 'Error',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Update Your Profile',
          style: TextStyle(
            color: MyColor.getAppbarTitleColor(),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(),
                  const SizedBox(height: 30),
                  _buildNameField(),
                  const SizedBox(height: 20),
                  _buildPhoneField(),
                  const SizedBox(height: 20),
                  _buildWalletAddressField(),
                  const SizedBox(height: 20),
                  _buildWalletTypeDropdown(),
                  const SizedBox(height: 40),
                  _buildUpdateButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: MyColor.getGCoinPrimaryGradient(),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: MyColor.getGCoinShadowColor(),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Update your personal information',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return _buildAnimatedField(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Full Name',
            style: TextStyle(
              color: MyColor.getLabelTextColor(),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            style: TextStyle(color: MyColor.getInputTextColor()),
            decoration: _buildInputDecoration(
              hintText: 'Enter your full name',
              prefixIcon: Icons.person_outline,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWalletAddressField() {
    return _buildAnimatedField(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wallet Address',
            style: TextStyle(
              color: MyColor.getLabelTextColor(),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _walletAddressController,
            style: TextStyle(color: MyColor.getInputTextColor()),
            decoration: _buildInputDecoration(
              hintText: 'Enter your wallet address',
              prefixIcon: Icons.account_balance_wallet_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your wallet address';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return _buildAnimatedField(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phone Number',
            style: TextStyle(
              color: MyColor.getLabelTextColor(),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: MyColor.getTextFieldBg(),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: MyColor.getFieldEnableBorderColor(),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      countryListTheme: CountryListThemeData(
                        backgroundColor: MyColor.getDialogBg(),
                        textStyle: TextStyle(color: MyColor.getTextColor()),
                      ),
                      onSelect: (Country country) {
                        setState(() {
                          selectedCountry = country;
                        });
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      color: MyColor.getGCoinPrimaryColor().withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedCountry.flagEmoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+${selectedCountry.phoneCode}',
                          style: TextStyle(
                            color: MyColor.getTextColor(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_drop_down,
                          color: MyColor.getTextColor(),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    style: TextStyle(color: MyColor.getInputTextColor()),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      // Custom formatter to remove leading zeros
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        if (newValue.text.isEmpty) return newValue;

                        // Remove leading zeros from the new input
                        String cleaned = _removeLeadingZeros(newValue.text);

                        return TextEditingValue(
                          text: cleaned,
                          selection: TextSelection.collapsed(offset: cleaned.length),
                        );
                      }),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Enter phone number',
                      hintStyle: TextStyle(color: MyColor.getHintTextColor()),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletTypeDropdown() {
    return _buildAnimatedField(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wallet Type',
            style: TextStyle(
              color: MyColor.getLabelTextColor(),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: MyColor.getTextFieldBg(),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: MyColor.getFieldEnableBorderColor(),
                width: 1.5,
              ),
            ),
            child: DropdownButtonFormField<String>(
              value: selectedWalletType,
              style: TextStyle(color: MyColor.getInputTextColor()),
              dropdownColor: MyColor.getCardBg(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.account_balance_wallet,
                  color: MyColor.getGCoinPrimaryColor(),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              items: ['BEP-20', 'TRC-20']
                  .map((type) => DropdownMenuItem(
                value: type,
                child: Text(
                  type,
                  style: TextStyle(color: MyColor.getTextColor()),
                ),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedWalletType = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
    return _buildAnimatedField(
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: MyColor.getGCoinPrimaryGradient(),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: MyColor.getGCoinPrimaryColor().withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _updateProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.update,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Update Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedField({required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: MyColor.getCardBg(),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: MyColor.getGCoinShadowColor(),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: child,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: MyColor.getHintTextColor()),
      prefixIcon: Icon(
        prefixIcon,
        color: MyColor.getGCoinPrimaryColor(),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: MyColor.getFieldEnableBorderColor(),
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: MyColor.getFieldEnableBorderColor(),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: MyColor.getGCoinPrimaryColor(),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: MyColor.getErrorColor(),
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: MyColor.getErrorColor(),
          width: 2,
        ),
      ),
      filled: true,
      fillColor: MyColor.getTextFieldBg(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}