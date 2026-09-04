import 'package:fizmaa/models_n_services/buisness_info/buisness_info_model.dart';
import 'package:fizmaa/models_n_services/buisness_info/business_info_get/buisness_info_get_svc.dart';
import 'package:fizmaa/utils/app_preference.dart';
import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

// =============================================================================
// 1. MAIN PARENT WRAPPER (Flow)
// =============================================================================
class BusinessOnboardingFlow extends StatefulWidget {
  const BusinessOnboardingFlow({Key? key}) : super(key: key);

  @override
  State<BusinessOnboardingFlow> createState() => _BusinessOnboardingFlowState();
}

class _BusinessOnboardingFlowState extends State<BusinessOnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      children: [
        BusinessInformationScreen(onNextPressed: _nextPage),
        Scaffold(
          appBar: AppBar(title: const Text("KYC Details")),
          body: Center(
            child: ElevatedButton(
              onPressed: _previousPage,
              child: const Text("Back"),
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(title: const Text("Bank Details")),
          body: Center(
            child: ElevatedButton(
              onPressed: _previousPage,
              child: const Text("Back to KYC"),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// 2. BUSINESS INFORMATION SCREEN
// =============================================================================
class BusinessInformationScreen extends StatefulWidget {
  final VoidCallback? onNextPressed;

  const BusinessInformationScreen({Key? key, this.onNextPressed}) : super(key: key);

  @override
  State<BusinessInformationScreen> createState() => _BusinessInformationScreenState();
}

class _BusinessInformationScreenState extends State<BusinessInformationScreen> {
  // Controllers
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessEmailController = TextEditingController();
  final TextEditingController _businessMobileController = TextEditingController();
  final TextEditingController _businessLandlineController = TextEditingController();
  final TextEditingController _gstNumberController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _youtubeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _localityController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  // Files (for upload)
  File? _logoFile;
  File? _coverFile;
  File? _gstDocumentFile;

  // Existing image URLs (from GET response) – relative paths
  String? _logoImageUrl;
  String? _coverImageUrl;
  String? _gstDocumentUrl;

  bool _isLoading = true;
  bool _isSubmitting = false;
  int? _organiserId;

  // Service instance
  late final BusinessDetailsApiService _service;

  // Base URL for images (without /api)
  static const String _imageBaseUrl = 'http://fizmaa.gccltd.in';

  // Helper to get full image URL from relative path
  String? _getFullImageUrl(String? relativePath) {
    if (relativePath == null || relativePath.isEmpty) return null;
    // If it already starts with http, return as is
    if (relativePath.startsWith('http')) return relativePath;
    // Otherwise prepend base URL
    return '$_imageBaseUrl$relativePath';
  }

  @override
  void initState() {
    super.initState();
    final dio = Dio(BaseOptions(
      baseUrl: 'http://fizmaa.gccltd.in/api',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    _service = BusinessDetailsApiService(dio);
    _loadData();
  }

  Future<void> _loadData() async {
    final id = await AppPreferences.getOrganiserId();
    if (id != null) {
      setState(() {
        _organiserId = id;
      });
      await _fetchBusinessDetails(id);
    } else {
      _showSnackBar("Organiser ID not found. Please login again.");
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchBusinessDetails(int organiserId) async {
    try {
      final response = await _service.getBusinessDetails(organiserId);
      final data = response.data;

      // Pre-fill controllers
      _businessNameController.text = data.businessName;
      _businessEmailController.text = data.businessEmail;
      _businessMobileController.text = data.businessMobile;
      _businessLandlineController.text = data.businessLandline ?? '';
      _gstNumberController.text = data.gstNumber ?? '';
      _instagramController.text = data.instagramUrl ?? '';
      _facebookController.text = data.facebookUrl ?? '';
      _youtubeController.text = data.youtubeUrl ?? '';
      _addressController.text = data.completeAddress;
      _localityController.text = data.locality;
      _cityController.text = data.city;
      _stateController.text = data.state;
      _pincodeController.text = data.pincode;

      // Store image URLs (relative paths)
      _logoImageUrl = data.logoImage;
      _coverImageUrl = data.coverImage;
      _gstDocumentUrl = data.gstScannedDocument;

      print('✅ Data loaded successfully');
      print('Logo URL: $_logoImageUrl');
      print('Cover URL: $_coverImageUrl');
      print('GST Doc URL: $_gstDocumentUrl');
    } catch (e) {
      print('❌ Failed to load data: $e');
      _showSnackBar('Failed to load data: ${e.toString()}');
    }
  }

  Future<void> _submitBusinessDetails() async {
    if (_isSubmitting) return;

    if (_businessNameController.text.isEmpty) {
      _showSnackBar("Please enter Business Name");
      return;
    }

    if (_organiserId == null) {
      _showSnackBar("Organiser ID not found. Please login again.");
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final request = BusinessDetailsRequest(
        businessName: _businessNameController.text,
        businessEmail: _businessEmailController.text,
        businessMobile: _businessMobileController.text,
        businessLandline: _businessLandlineController.text,
        gstNumber: _gstNumberController.text,
        gstVerified: true,
        instagramUrl: _instagramController.text.isNotEmpty ? _instagramController.text : null,
        facebookUrl: _facebookController.text.isNotEmpty ? _facebookController.text : null,
        youtubeUrl: _youtubeController.text.isNotEmpty ? _youtubeController.text : null,
        completeAddress: _addressController.text,
        locality: _localityController.text,
        city: _cityController.text,
        state: _stateController.text,
        pincode: _pincodeController.text,
        latitude: 19.9975,
        longitude: 73.7898,
        logo: _logoFile,
        cover: _coverFile,
        gstDocument: _gstDocumentFile,
      );

      final response = await _service.updateBusinessDetails(
        organiserId: _organiserId!,
        request: request,
      );

      _showSnackBar(response.message, isError: false);
      widget.onNextPressed?.call();
    } catch (e) {
      _showSnackBar(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _pickFile(File? currentFile, Function(File?) setFile) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (result != null && result.isNotEmpty) {
        final file = result.first;
        if (file.path != null) {
          setFile(File(file.path!));
          setState(() {});
        }
      }
    } catch (e) {
      print('File picker error: $e');
      _showSnackBar('Failed to pick file');
    }
  }

  // =============================================================================
  // BUILD METHOD
  // =============================================================================
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        decoration: AppColors.screenGradient,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.kTextDark, size: 20),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: const Text(
              'Business Information',
              style: TextStyle(
                color: AppColors.kTextDark,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          body: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Container(
      decoration: AppColors.screenGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.kTextDark, size: 20),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text(
            'Business Information',
            style: TextStyle(
              color: AppColors.kTextDark,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildImageHeader(),
              const SizedBox(height: 20),

              Row(
                children: const [
                  Text("Basic Details ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("*", style: TextStyle(color: AppColors.kRed, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),

              _buildLabelWithAttachment(
                "GST Number (Optional)",
                onAttachmentTap: () => _pickFile(_gstDocumentFile, (f) => _gstDocumentFile = f),
              ),
              _buildTextField(controller: _gstNumberController, prefixIcon: Icons.edit_outlined),
              const SizedBox(height: 8),
              _buildDocumentCard(
                icon: Icons.verified_user_outlined,
                iconBg: AppColors.statGreenBg,
                iconFg: AppColors.statGreenFg,
                title: "GST",
                subtitle: "GST Document",
                statusText: "VERIFIED",
                statusBg: AppColors.statGreenBg,
                statusFg: AppColors.statGreenFg,
                fileName: _gstDocumentFile?.path.split('/').last ??
                    (_gstDocumentUrl != null ? _gstDocumentUrl!.split('/').last : "No document"),
                fileSize: _gstDocumentFile != null
                    ? "${(_gstDocumentFile!.lengthSync() / 1024 / 1024).toStringAsFixed(1)} MB"
                    : "Existing",
                onTap: () => _pickFile(_gstDocumentFile, (f) => _gstDocumentFile = f),
                // Pass full URL for preview if it's an image
                previewUrl: _gstDocumentUrl != null ? _getFullImageUrl(_gstDocumentUrl) : null,
              ),
              const SizedBox(height: 16),

              _buildLabel("Business Name"),
              _buildTextField(controller: _businessNameController, prefixIcon: Icons.business_outlined),
              const SizedBox(height: 12),

              _buildLabel("Business Email"),
              _buildTextField(controller: _businessEmailController, prefixIcon: Icons.email_outlined),
              const SizedBox(height: 12),

              _buildLabel("Business Mobile No."),
              _buildTextField(controller: _businessMobileController, prefixIcon: Icons.phone_outlined),
              const SizedBox(height: 12),

              _buildLabel("Business Landline No."),
              _buildTextField(controller: _businessLandlineController, prefixIcon: Icons.phone_in_talk_outlined),
              const SizedBox(height: 20),

              _buildSectionCard(
                title: "Social Media",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Instagram"),
                    _buildTextField(
                      controller: _instagramController,
                      hintText: "Enter Instagram URL",
                      prefixIconWidget: const Icon(Icons.camera_alt, color: Colors.pink, size: 18),
                    ),
                    const SizedBox(height: 10),
                    _buildLabel("Facebook"),
                    _buildTextField(
                      controller: _facebookController,
                      hintText: "Enter Facebook URL",
                      prefixIconWidget: const Icon(Icons.facebook, color: Colors.blue, size: 18),
                    ),
                    const SizedBox(height: 10),
                    _buildLabel("YouTube"),
                    _buildTextField(
                      controller: _youtubeController,
                      hintText: "Enter YouTube URL",
                      prefixIconWidget: const Icon(Icons.play_arrow_rounded, color: Colors.red, size: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                title: "Address",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Complete Address"),
                    _buildTextField(controller: _addressController, prefixIcon: Icons.location_on_outlined),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Locality"),
                              _buildTextField(controller: _localityController, prefixIcon: Icons.location_on_outlined),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("City"),
                              _buildTextField(controller: _cityController, prefixIcon: Icons.location_on_outlined),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("State"),
                              _buildTextField(controller: _stateController, prefixIcon: Icons.location_on_outlined),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Pincode"),
                              _buildTextField(controller: _pincodeController, prefixIcon: Icons.location_on_outlined),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _isSubmitting ? null : _submitBusinessDetails,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================================
  // UI HELPER METHODS
  // =============================================================================

  Widget _stepItem({required String step, required String title, required bool isActive}) {
    Color bg = isActive ? AppColors.kRed : Colors.grey.shade300;
    Color textCol = isActive ? AppColors.kRed : AppColors.textSecondary;

    return Row(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: bg,
          child: Text(
            step,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          title,
          style: TextStyle(
            color: textCol,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _stepDivider() {
    return Container(width: 8, height: 1, color: Colors.grey.shade300);
  }

  Widget _buildImageHeader() {
    // Build full URLs for cover and logo using helper
    final fullCoverUrl = _getFullImageUrl(_coverImageUrl);
    final fullLogoUrl = _getFullImageUrl(_logoImageUrl);

    final coverImageProvider = _coverFile != null
        ? FileImage(_coverFile!)
        : (fullCoverUrl != null ? NetworkImage(fullCoverUrl) as ImageProvider : null);

    final logoImageProvider = _logoFile != null
        ? FileImage(_logoFile!)
        : (fullLogoUrl != null ? NetworkImage(fullLogoUrl) as ImageProvider : null);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: coverImageProvider != null
                ? DecorationImage(image: coverImageProvider, fit: BoxFit.cover)
                : const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=500'),
                    fit: BoxFit.cover,
                  ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => _pickFile(_coverFile, (f) => _coverFile = f),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.edit, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text("Change Cover", style: TextStyle(color: Colors.white, fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: -25,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () => _pickFile(_logoFile, (f) => _logoFile = f),
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6),
                    ],
                    image: logoImageProvider != null
                        ? DecorationImage(image: logoImageProvider, fit: BoxFit.cover)
                        : null,
                  ),
                  child: logoImageProvider == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.shield, size: 30, color: Colors.black87),
                            Text("LOGO DESIGN", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold)),
                          ],
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: -4,
                right: -4,
                child: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.edit, size: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildLabelWithAttachment(String text, {VoidCallback? onAttachmentTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
          GestureDetector(
            onTap: onAttachmentTap,
            child: const Icon(Icons.attach_file, size: 16, color: AppColors.kRed),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    String? hintText,
    IconData? prefixIcon,
    Widget? prefixIconWidget,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.kBorder.withOpacity(0.5)),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 13, color: AppColors.kTextDark, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.kHint, fontSize: 12),
          prefixIcon: prefixIconWidget ?? (prefixIcon != null ? Icon(prefixIcon, size: 16, color: AppColors.kRed) : null),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, IconData? titleIcon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.kPinkLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (titleIcon != null) ...[
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: AppColors.kPink, borderRadius: BorderRadius.circular(6)),
                  child: Icon(titleIcon, size: 16, color: AppColors.kRed),
                ),
                const SizedBox(width: 8),
              ],
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.kTextDark)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildDocumentCard({
    required IconData icon,
    required Color iconBg,
    required Color iconFg,
    required String title,
    String? subtitle,
    required String statusText,
    required Color statusBg,
    required Color statusFg,
    required String fileName,
    String fileSize = "1.2 MB",
    String? warningText,
    VoidCallback? onTap,
    String? previewUrl, // optional preview URL for image
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.kPinkLight.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.kBorder.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: iconFg, size: 20),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.kTextDark)),
                    if (subtitle != null)
                      Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    statusText,
                    style: TextStyle(color: statusFg, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (warningText != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(6)),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 14, color: Color(0xFFD97706)),
                    const SizedBox(width: 6),
                    Text(warningText, style: const TextStyle(color: Color(0xFFD97706), fontSize: 10, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            // Show preview if previewUrl is provided and it's an image (check extension)
            if (previewUrl != null && _isImageFile(previewUrl))
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(previewUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            _buildPdfFileTile(fileName: fileName, fileSize: fileSize),
          ],
        ),
      ),
    );
  }

  bool _isImageFile(String url) {
    final ext = url.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'svg'].contains(ext);
  }

  Widget _buildPdfFileTile({required String fileName, required String fileSize}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file, size: 20, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fileName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.kTextDark)),
                const SizedBox(height: 2),
                Text("$fileSize •", style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.more_vert, size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}