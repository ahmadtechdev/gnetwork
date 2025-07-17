import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import '../../api_service/api_service.dart';
import '../../utils/app_colors.dart';

class KYCField {
  final String label;
  final String type;
  final bool required;

  KYCField({
    required this.label,
    required this.type,
    required this.required,
  });

  factory KYCField.fromMap(Map<String, dynamic> map) {
    return KYCField(
      label: map['label'] ?? '',
      type: map['type'] ?? 'text',
      required: map['required'] == '1' || map['required'] == 1 || map['required'] == true,
    );
  }
}

class KYCScreen extends StatefulWidget {
  const KYCScreen({Key? key}) : super(key: key);

  @override
  State<KYCScreen> createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = true;
  bool _isSubmitting = false;
  String _message = '';
  String _formTitle = '';
  List<KYCField> _fields = [];
  Map<String, dynamic> _formData = {};
  Map<String, File?> _selectedFiles = {};
  Map<String, TextEditingController> _controllers = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _loadKYCForm();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _loadKYCForm() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await _apiService.getKYCForm();
print("kyc response:");
      print(response);
      if (response != null) {
        print("123");
        final data = response.data as Map<String, dynamic>;

        setState(() {
          _message = data['message'] ?? '';
          if (data['kyc'] != null) {
            final kycData = data['kyc'] as Map<String, dynamic>;
            _formTitle = kycData['name'] ?? 'KYC Verification';
            _fields = (kycData['fields'] as List?)
                ?.map((field) => KYCField.fromMap(field))
                .toList() ?? [];

            // Initialize controllers for text fields
            for (var field in _fields) {
              if (field.type != 'file') {
                _controllers[field.label] = TextEditingController();
              }
            }
          }
          _isLoading = false;
        });

        // Show message from API in snackbar if available
        if (_message.isNotEmpty) {
          Get.snackbar(
            'Info',
            _message,
            backgroundColor: MyColor.getGCoinInfoColor(),
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        }

        // Show success message for form loading
        if (_fields.isNotEmpty) {
          Get.snackbar(
            'Success',
            'KYC form loaded successfully',
            backgroundColor: MyColor.getGCoinSuccessColor(),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        } else {
          Get.snackbar(
            'Warning',
            'No KYC fields available at the moment',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }

        _animationController.forward();
      } else {
        setState(() {
          _isLoading = false;
        });

        Get.snackbar(
          'Error',
          'Failed to load KYC form. Please try again.',
          backgroundColor: MyColor.getErrorColor(),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      Get.snackbar(
        'Error',
        'Failed to load KYC form: ${e.toString()}',
        backgroundColor: MyColor.getErrorColor(),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> _pickImage(String fieldLabel) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedFiles[fieldLabel] = File(image.path);
        });

        // Show success message for image selection
        Get.snackbar(
          'Success',
          'Image selected for $fieldLabel',
          backgroundColor: MyColor.getGCoinSuccessColor(),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        backgroundColor: MyColor.getErrorColor(),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  bool _validateForm() {
    for (var field in _fields) {
      if (field.required) {
        if (field.type == 'file') {
          if (_selectedFiles[field.label] == null) {
            Get.snackbar(
              'Validation Error',
              '${field.label} is required',
              backgroundColor: MyColor.getErrorColor(),
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
            return false;
          }
        } else {
          final controller = _controllers[field.label];
          if (controller == null || controller.text.trim().isEmpty) {
            Get.snackbar(
              'Validation Error',
              '${field.label} is required',
              backgroundColor: MyColor.getErrorColor(),
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
            return false;
          }
        }
      }
    }
    return true;
  }

  Future<void> _submitKYC() async {
    if (!_validateForm()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final Map<String, dynamic> submitData = {};

      // Add text field data
      for (var field in _fields) {
        if (field.type != 'file') {
          final controller = _controllers[field.label];
          if (controller != null) {
            submitData[field.label.toLowerCase().replaceAll(' ', '_')] = controller.text.trim();
          }
        }
      }

      // Add file data
      for (String key in _selectedFiles.keys) {
        if (_selectedFiles[key] != null) {
          submitData[key.toLowerCase().replaceAll(' ', '_')] = await dio.MultipartFile.fromFile(
            _selectedFiles[key]!.path,
            filename: _selectedFiles[key]!.path.split('/').last,
          );
        }
      }

      final response = await _apiService.submitKYC(submitData);

      if (response != null && response.statusCode == 400) {
        Get.snackbar(
          'Success',
          'KYC submitted successfully! Your verification is under review.',
          backgroundColor: MyColor.getGCoinSuccessColor(),
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );

        // Clear form after successful submission
        _controllers.forEach((key, controller) => controller.clear());
        _selectedFiles.clear();

        // Navigate back after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          Get.back();
        });
      } else {
        // Handle different response scenarios
        String errorMessage = 'Failed to submit KYC. Please try again.';

        if (response?.data != null && response!.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          errorMessage = responseData['message'] ?? errorMessage;
        }

        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: MyColor.getErrorColor(),
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit KYC: ${e.toString()}',
        backgroundColor: MyColor.getErrorColor(),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Widget _buildTextField(KYCField field) {
    final controller = _controllers[field.label];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                field.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: MyColor.getTextColor(),
                ),
              ),
              if (field.required)
                Text(
                  ' *',
                  style: TextStyle(
                    fontSize: 16,
                    color: MyColor.getErrorColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              gradient: MyColor.getGCoinCardGradient(),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: MyColor.getFieldEnableBorderColor().withOpacity(0.3),
                width: 1,
              ),
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: field.type == 'number' ? TextInputType.number : TextInputType.text,
              style: TextStyle(
                color: MyColor.getTextColor(),
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Enter ${field.label.toLowerCase()}',
                hintStyle: TextStyle(
                  color: MyColor.getTextFieldHintColor(),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: MyColor.getCardBg(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: MyColor.getGCoinPrimaryColor(),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileField(KYCField field) {
    final selectedFile = _selectedFiles[field.label];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                field.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: MyColor.getTextColor(),
                ),
              ),
              if (field.required)
                Text(
                  ' *',
                  style: TextStyle(
                    fontSize: 16,
                    color: MyColor.getErrorColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _pickImage(field.label),
            child: Container(
              width: double.infinity,
              height: selectedFile != null ? 200 : 120,
              decoration: BoxDecoration(
                gradient: MyColor.getGCoinCardGradient(),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: MyColor.getGCoinPrimaryColor().withOpacity(0.3),
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
              child: selectedFile != null
                  ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      selectedFile,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: MyColor.getGCoinPrimaryColor(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Tap to change',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: MyColor.getGCoinPrimaryColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.cloud_upload_outlined,
                      size: 32,
                      color: MyColor.getGCoinPrimaryColor(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Upload ${field.label}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: MyColor.getTextColor(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to select image',
                    style: TextStyle(
                      fontSize: 14,
                      color: MyColor.getTextFieldHintColor(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
            color: MyColor.getTextColor(),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'KYC Verification',
          style: TextStyle(
            color: MyColor.getTextColor(),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_isLoading)
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      MyColor.getGCoinPrimaryColor(),
                    ),
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                MyColor.getGCoinPrimaryColor(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading KYC form...',
              style: TextStyle(
                color: MyColor.getTextColor(),
                fontSize: 16,
              ),
            ),
          ],
        ),
      )
          : FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: RefreshIndicator(
            onRefresh: _loadKYCForm,
            color: MyColor.getGCoinPrimaryColor(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: MyColor.getGCoinPrimaryGradient(),
                      borderRadius: BorderRadius.circular(16),
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
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.verified_user,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _formTitle.isNotEmpty ? _formTitle : 'KYC Verification',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Complete your verification to unlock all features',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Form Fields
                  if (_fields.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: MyColor.getCardBg(),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: MyColor.getGCoinShadowColor(),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Required Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: MyColor.getTextColor(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          ..._fields.map((field) {
                            if (field.type == 'file') {
                              return _buildFileField(field);
                            } else {
                              return _buildTextField(field);
                            }
                          }).toList(),
                        ],
                      ),
                    ),

                  if (_fields.isNotEmpty) const SizedBox(height: 32),

                  // Submit Button
                  if (_fields.isNotEmpty)
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: MyColor.getGCoinPrimaryGradient(),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: MyColor.getGCoinPrimaryColor().withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitKYC,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isSubmitting
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Submitting...',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                            : Text(
                          'Submit KYC',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  // Empty state message
                  if (_fields.isEmpty && !_isLoading)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: MyColor.getCardBg(),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: MyColor.getGCoinShadowColor(),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 64,
                            color: MyColor.getTextFieldHintColor(),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No KYC fields available',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: MyColor.getTextColor(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please try again later or contact support',
                            style: TextStyle(
                              fontSize: 14,
                              color: MyColor.getTextFieldHintColor(),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}