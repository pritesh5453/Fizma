import 'package:fizmaa/Screens/Profile/kyc/bank_details_screen.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/models_n_services/kyc/kyc_model.dart';
import 'package:fizmaa/models_n_services/kyc/kyc_svc.dart';
import 'package:fizmaa/utils/app_preference.dart';
import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

// =============================================================================
// KYC DETAILS SCREEN – NOW HANDLES NAVIGATION DIRECTLY
// =============================================================================
class KycDetailsScreen extends StatefulWidget {
  final VoidCallback? onBackPressed; // Optional, but we'll use Navigator.pop

  const KycDetailsScreen({
    Key? key,
    this.onBackPressed,
  }) : super(key: key);

  @override
  State<KycDetailsScreen> createState() => _KycDetailsScreenState();
}

class _KycDetailsScreenState extends State<KycDetailsScreen> {
  // ---------- Controllers ----------
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _certificateNameController = TextEditingController();

  // ---------- Upload Files ----------
  File? _aadhaarFile;
  File? _panFile;
  File? _licenseFile;
  File? _certificateFile;

  // ---------- Existing Document URLs (from GET) ----------
  String? _aadhaarDocUrl;
  String? _panDocUrl;
  String? _licenseDocUrl;
  String? _certificateDocUrl;

  // ---------- Status Fields (for display) ----------
  int _aadhaarVerified = 0; // 0/1
  int _panVerified = 0; // 0/1
  int _businessLicenseVerified = 0; // 0/1
  String _businessLicenseStatus = ''; // pending, approved, rejected
  String _businessLicenseReviewNotes = '';

  // ---------- States ----------
  bool _isLoading = true;
  bool _isSubmitting = false;
  int? _organiserId;

  // ---------- Service ----------
  late final KycService _kycService;

  // ---------- Helper: Full Image URL ----------
  String? _getFullImageUrl(String? relativePath) {
    if (relativePath == null || relativePath.isEmpty) return null;
    if (relativePath.startsWith('http')) return relativePath;
    return '${ApiEndpoints.baseUrl}$relativePath';
  }

  // ---------- Helper: Status Text & Color ----------
  String _getStatusText(int verified, {String? status, String? reviewNotes}) {
    if (status != null) {
      // For business license, use the status string
      switch (status.toLowerCase()) {
        case 'approved':
          return 'VERIFIED';
        case 'pending':
          return 'PENDING';
        case 'rejected':
          return 'REJECTED';
        default:
          return status.toUpperCase();
      }
    }
    // For Aadhaar and PAN (0/1)
    return verified == 1 ? 'VERIFIED' : 'UNVERIFIED';
  }

  Color _getStatusBgColor(String statusText) {
    switch (statusText) {
      case 'VERIFIED':
        return AppColors.statGreenBg;
      case 'PENDING':
        return AppColors.statOrangeBg;
      case 'REJECTED':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getStatusFgColor(String statusText) {
    switch (statusText) {
      case 'VERIFIED':
        return AppColors.statGreenFg;
      case 'PENDING':
        return AppColors.statOrangeFg;
      case 'REJECTED':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  void initState() {
    super.initState();
    final dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    _kycService = KycService(dio);
    _loadData();
  }

  // ---------- Load Data ----------
  Future<void> _loadData() async {
    final id = await AppPreferences.getOrganiserId();
    if (id != null) {
      setState(() => _organiserId = id);
      await _fetchKyc(id);
    } else {
      _showSnackBar("Organiser ID not found. Please login again.");
    }
    setState(() => _isLoading = false);
  }

  Future<void> _fetchKyc(int organiserId) async {
    try {
      final response = await _kycService.getKyc(organiserId);
      final data = response.data;

      _aadhaarController.text = data.aadhaarNumber;
      _panController.text = data.panNumber;
      _licenseController.text = data.businessLicenseNumber;
      _certificateNameController.text = data.certificateName;

      _aadhaarDocUrl = data.aadhaarDocument;
      _panDocUrl = data.panDocument;
      _licenseDocUrl = data.businessLicenseDocument;
      _certificateDocUrl = data.certificateDocument;

      // Store status values
      _aadhaarVerified = data.aadhaarVerified;
      _panVerified = data.panVerified;
      _businessLicenseVerified = data.businessLicenseVerified;
      _businessLicenseStatus = data.businessLicenseStatus;
      _businessLicenseReviewNotes = data.businessLicenseReviewNotes ?? '';

      print('✅ KYC data loaded successfully');
    } catch (e) {
      print('❌ Failed to load KYC: $e');
      _showSnackBar('Failed to load KYC: ${e.toString()}');
    }
  }

  // ---------- Submit / Update ----------
  Future<void> _submitKyc() async {
    if (_isSubmitting) return;

    if (_aadhaarController.text.isEmpty) {
      _showSnackBar("Please enter Aadhaar number");
      return;
    }
    if (_panController.text.isEmpty) {
      _showSnackBar("Please enter PAN number");
      return;
    }
    if (_organiserId == null) {
      _showSnackBar("Organiser ID not found. Please login again.");
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final request = KycRequest(
        aadhaarNumber: _aadhaarController.text,
        panNumber: _panController.text,
        businessLicenseNumber: _licenseController.text.isNotEmpty ? _licenseController.text : null,
        certificateName: _certificateNameController.text.isNotEmpty ? _certificateNameController.text : null,
        aadhaarDocument: _aadhaarFile,
        panDocument: _panFile,
        businessLicenseDocument: _licenseFile,
        certificateDocument: _certificateFile,
      );

      final response = await _kycService.updateKyc(
        organiserId: _organiserId!,
        request: request,
      );

      _showSnackBar("KYC updated successfully!", isError: false);
      await _fetchKyc(_organiserId!);

      // ✅ Navigate to Bank Details Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BankDetailsScreen(
            onBackPressed: () => Navigator.pop(context),
            onNextPressed: () {
              print('Onboarding complete!');
              Navigator.pop(context);
            },
          ),
        ),
      );
    } catch (e) {
      _showSnackBar(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ---------- Helpers ----------
  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ✅ FILE PICKER – Working Pattern
  Future<void> _pickFile(Function(File?) setFile) async {
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

  bool _isImageFile(String url) {
    final ext = url.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'svg'].contains(ext);
  }

  // =============================================================================
  // BUILD
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
              onPressed: widget.onBackPressed ?? () => Navigator.of(context).maybePop(),
            ),
            title: const Text(
              'KYC Details',
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
            onPressed: widget.onBackPressed ?? () => Navigator.of(context).maybePop(),
          ),
          title: const Text(
            'KYC Details',
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
              _buildStepperHeader(),
              const SizedBox(height: 16),

              const Text(
                "KYC Verification Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.kTextDark),
              ),
              const SizedBox(height: 16),

              // ---------- Aadhaar ----------
              _buildLabelWithAttachment(
                "Aadhaar Number",
                onAttachmentTap: () => _pickFile((f) => _aadhaarFile = f),
              ),
              _buildTextField(controller: _aadhaarController, prefixIcon: Icons.edit_outlined),
              const SizedBox(height: 8),
              _buildDocumentCard(
                icon: Icons.badge_outlined,
                iconBg: AppColors.statGreenBg,
                iconFg: AppColors.statGreenFg,
                title: "Aadhaar Card",
                subtitle: "**** **** ${_aadhaarController.text.length >= 4 ? _aadhaarController.text.substring(_aadhaarController.text.length - 4) : ''}",
                statusText: _getStatusText(_aadhaarVerified),
                statusBg: _getStatusBgColor(_getStatusText(_aadhaarVerified)),
                statusFg: _getStatusFgColor(_getStatusText(_aadhaarVerified)),
                fileName: _aadhaarFile?.path.split('/').last ??
                    (_aadhaarDocUrl != null ? _aadhaarDocUrl!.split('/').last : "No document"),
                fileSize: _aadhaarFile != null
                    ? "${(_aadhaarFile!.lengthSync() / 1024 / 1024).toStringAsFixed(1)} MB"
                    : "Existing",
                previewUrl: _getFullImageUrl(_aadhaarDocUrl),
                onTap: () => _pickFile((f) => _aadhaarFile = f),
              ),
              const SizedBox(height: 16),

              // ---------- PAN ----------
              _buildLabelWithAttachment(
                "PAN Card",
                onAttachmentTap: () => _pickFile((f) => _panFile = f),
              ),
              _buildTextField(controller: _panController, prefixIcon: Icons.edit_outlined),
              const SizedBox(height: 8),
              _buildDocumentCard(
                icon: Icons.account_balance_wallet_outlined,
                iconBg: AppColors.statGreenBg,
                iconFg: AppColors.statGreenFg,
                title: "PAN Card",
                subtitle: "**** **** ${_panController.text.length >= 4 ? _panController.text.substring(_panController.text.length - 4) : ''}",
                statusText: _getStatusText(_panVerified),
                statusBg: _getStatusBgColor(_getStatusText(_panVerified)),
                statusFg: _getStatusFgColor(_getStatusText(_panVerified)),
                fileName: _panFile?.path.split('/').last ??
                    (_panDocUrl != null ? _panDocUrl!.split('/').last : "No document"),
                fileSize: _panFile != null
                    ? "${(_panFile!.lengthSync() / 1024 / 1024).toStringAsFixed(1)} MB"
                    : "Existing",
                previewUrl: _getFullImageUrl(_panDocUrl),
                onTap: () => _pickFile((f) => _panFile = f),
              ),
              const SizedBox(height: 16),

              // ---------- Business License ----------
              _buildLabelWithAttachment(
                "Business License (Optional)",
                onAttachmentTap: () => _pickFile((f) => _licenseFile = f),
              ),
              _buildTextField(controller: _licenseController, prefixIcon: Icons.edit_outlined),
              const SizedBox(height: 8),
              _buildDocumentCard(
                icon: Icons.restaurant,
                iconBg: _businessLicenseVerified == 1 ? AppColors.statGreenBg : AppColors.statOrangeBg,
                iconFg: _businessLicenseVerified == 1 ? AppColors.statGreenFg : AppColors.statOrangeFg,
                title: "License",
                statusText: _getStatusText(0, status: _businessLicenseStatus),
                statusBg: _getStatusBgColor(_getStatusText(0, status: _businessLicenseStatus)),
                statusFg: _getStatusFgColor(_getStatusText(0, status: _businessLicenseStatus)),
                fileName: _licenseFile?.path.split('/').last ??
                    (_licenseDocUrl != null ? _licenseDocUrl!.split('/').last : "No document"),
                fileSize: _licenseFile != null
                    ? "${(_licenseFile!.lengthSync() / 1024 / 1024).toStringAsFixed(1)} MB"
                    : "Existing",
                warningText: _businessLicenseReviewNotes.isNotEmpty ? _businessLicenseReviewNotes : null,
                previewUrl: _getFullImageUrl(_licenseDocUrl),
                onTap: () => _pickFile((f) => _licenseFile = f),
              ),
              const SizedBox(height: 20),

              // ---------- Certificates ----------
              _buildSectionCard(
                title: "Certificates",
                titleIcon: Icons.verified_outlined,
                child: Column(
                  children: [
                    _buildLabelWithAttachment(
                      "Certificate Name (Optional)",
                      onAttachmentTap: () => _pickFile((f) => _certificateFile = f),
                    ),
                    _buildTextField(controller: _certificateNameController, prefixIcon: Icons.edit_outlined),
                    const SizedBox(height: 8),
                    _buildDocumentCard(
                      icon: Icons.verified_user_outlined,
                      iconBg: AppColors.statGreenBg,
                      iconFg: AppColors.statGreenFg,
                      title: "Certificate",
                      subtitle: _certificateNameController.text,
                      statusText: "UPLOADED",
                      statusBg: AppColors.statGreenBg,
                      statusFg: AppColors.statGreenFg,
                      fileName: _certificateFile?.path.split('/').last ??
                          (_certificateDocUrl != null ? _certificateDocUrl!.split('/').last : "No document"),
                      fileSize: _certificateFile != null
                          ? "${(_certificateFile!.lengthSync() / 1024 / 1024).toStringAsFixed(1)} MB"
                          : "Existing",
                      previewUrl: _getFullImageUrl(_certificateDocUrl),
                      onTap: () => _pickFile((f) => _certificateFile = f),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFFBEB),
                        side: const BorderSide(color: Color(0xFFFCD34D)),
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.add_circle_outline, color: Color(0xFFD97706), size: 18),
                      label: const Text("Buy Certifications", style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ---------- Navigation ----------
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.kRed),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: widget.onBackPressed ?? () => Navigator.of(context).maybePop(),
                        child: const Text("Back", style: TextStyle(color: AppColors.kTextDark, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kRed,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _isSubmitting ? null : _submitKyc,
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
                                "Next",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================================
  // UI HELPERS
  // =============================================================================

  Widget _buildStepperHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _stepItem(step: "1", title: "KYC Details", isActive: true, isCompleted: false),
          _stepDivider(),
          _stepItem(step: "2", title: "Bank Details", isActive: false, isCompleted: false),
        ],
      ),
    );
  }

  Widget _stepItem({required String step, required String title, required bool isActive, bool isCompleted = false}) {
    Color bg = isActive || isCompleted ? AppColors.kRed : Colors.grey.shade300;
    Color textCol = isActive || isCompleted ? AppColors.kRed : AppColors.textSecondary;

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
            fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _stepDivider() {
    return Container(width: 8, height: 1, color: Colors.grey.shade300);
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
    String? previewUrl,
    VoidCallback? onTap,
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
            if (previewUrl != null && _isImageFile(previewUrl))
              Container(
                height: 80,
                margin: const EdgeInsets.only(bottom: 8),
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