import 'package:fizmaa/Screens/Profile/profile_screen.dart';
import 'package:fizmaa/Screens/navbar/navbar.dart';
import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/models_n_services/bank_details/bank_details_model.dart';
import 'package:fizmaa/models_n_services/bank_details/bank_details_svc.dart';
import 'package:fizmaa/utils/app_preference.dart';
import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class BankDetailsScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onNextPressed;

  const BankDetailsScreen({
    Key? key,
    this.onBackPressed,
    this.onNextPressed,
  }) : super(key: key);

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  // ---------- Controllers ----------
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountHolderController = TextEditingController();
  final TextEditingController _upiController = TextEditingController();

  // ---------- States ----------
  bool _isLoading = true;
  bool _isSubmitting = false;
  int? _organiserId;

  // ---------- Service ----------
  late final BankService _bankService;

  @override
  void initState() {
    super.initState();
    final dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    _bankService = BankService(dio);
    _loadData();
  }

  // ---------- Load Bank Details ----------
  Future<void> _loadData() async {
    try {
      final id = await AppPreferences.getOrganiserId();
      if (id != null) {
        setState(() => _organiserId = id);
        await _fetchBankDetails();
      } else {
        _showSnackBar('Organiser ID not found. Please login again.');
      }
    } catch (e) {
      print('Error loading bank details: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchBankDetails() async {
    try {
      final response = await _bankService.getBankDetails();
      final data = response.data;

      if (data != null) {
        _accountNumberController.text = data.accountNumber;
        _ifscController.text = data.ifscCode;
        _bankNameController.text = data.bankName;
        _accountHolderController.text = data.accountHolderName;
        _upiController.text = data.upiId;
        print('✅ Bank details loaded successfully');
      }
    } catch (e) {
      // If no bank details exist, just show empty fields
      print('No bank details found or error: $e');
    }
  }

  // ---------- Submit Bank Details ----------
  Future<void> _submitBankDetails() async {
    // Validations
    if (_accountNumberController.text.trim().isEmpty) {
      _showSnackBar('Please enter Account Number');
      return;
    }
    if (_ifscController.text.trim().isEmpty) {
      _showSnackBar('Please enter IFSC Code');
      return;
    }
    if (_bankNameController.text.trim().isEmpty) {
      _showSnackBar('Please enter Bank Name');
      return;
    }
    if (_accountHolderController.text.trim().isEmpty) {
      _showSnackBar('Please enter Account Holder Name');
      return;
    }
    if (_upiController.text.trim().isEmpty) {
      _showSnackBar('Please enter UPI ID');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final request = BankDetailsRequest(
        accountNumber: _accountNumberController.text.trim(),
        ifscCode: _ifscController.text.trim(),
        bankName: _bankNameController.text.trim(),
        accountHolderName: _accountHolderController.text.trim(),
        upiId: _upiController.text.trim(),
      );

      final response = await _bankService.updateBankDetails(
        request: request,
      );

      _showSnackBar(response.message, isError: false);

      // Show success popup with navigation
      _showSavedSuccessDialog(context);
    } catch (e) {
      _showSnackBar(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ---------- Success Dialog ----------
  void _showSavedSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Close (X) Button – Navigates to ProfileManagementScreen
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EventsNavBar(initialIndex: 3), // Navigate to Profile tab
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEE2E2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.kRed,
                      ),
                    ),
                  ),
                ),

                // Success Icon with Confetti
                SizedBox(
                  height: 90,
                  width: 90,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(top: 0, right: 25, child: _buildDot(Colors.redAccent, 8)),
                      Positioned(top: 15, left: 15, child: _buildDot(Colors.orangeAccent, 6)),
                      Positioned(top: 30, left: 0, child: _buildDot(Colors.purpleAccent, 5)),
                      Positioned(bottom: 25, right: 10, child: _buildDot(Colors.blueAccent, 5)),
                      Positioned(bottom: 10, right: 20, child: _buildDot(Colors.greenAccent, 7)),
                      Positioned(bottom: 5, left: 20, child: _buildDot(Colors.yellow, 7)),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFDCFCE7),
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                const Text(
                  "Saved Successfully",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kTextDark,
                  ),
                ),
                const SizedBox(height: 8),

                const Text(
                  "Bank details updated successfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EventsNavBar(initialIndex: 3),
                        ),
                      );
                    },
                    child: const Text(
                      'Go to Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDot(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
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

  // ---------- Build ----------
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
              'Bank Details',
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
            'Bank Details',
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
              const SizedBox(height: 20),

              const Text(
                "Add Bank Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kTextDark,
                ),
              ),
              const SizedBox(height: 16),

              // Account Number
              _buildLabel("Account Number"),
              _buildTextField(
                controller: _accountNumberController,
                hintText: "Enter Account Number",
                prefixIcon: Icons.edit_outlined,
              ),
              const SizedBox(height: 14),

              // IFSC Code
              _buildLabel("IFSC Code"),
              _buildTextField(
                controller: _ifscController,
                hintText: "Enter IFSC Code",
                prefixIcon: Icons.edit_outlined,
              ),
              const SizedBox(height: 14),

              // Bank Name
              _buildLabel("Bank Name"),
              _buildTextField(
                controller: _bankNameController,
                hintText: "Enter Bank Name",
                prefixIcon: Icons.account_balance_outlined,
              ),
              const SizedBox(height: 14),

              // Account Holder Name
              _buildLabel("Account Holder Name"),
              _buildTextField(
                controller: _accountHolderController,
                hintText: "Enter Account Holder Name",
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 14),

              // UPI ID
              _buildLabel("UPI ID"),
              _buildTextField(
                controller: _upiController,
                hintText: "Enter UPI ID",
                prefixIcon: Icons.account_balance_wallet_outlined,
              ),
              const SizedBox(height: 32),

              // Bottom Action Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.kRed),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: widget.onBackPressed ?? () => Navigator.of(context).maybePop(),
                        child: const Text(
                          "Back",
                          style: TextStyle(
                            color: AppColors.kTextDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kRed,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isSubmitting ? null : _submitBankDetails,
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
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
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

  // ---------- UI Helpers ----------
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
          _stepItem(step: "1", title: "KYC Details", isActive: false, isCompleted: true),
          _stepDivider(),
          _stepItem(step: "2", title: "Bank Details", isActive: true, isCompleted: false),
        ],
      ),
    );
  }

  Widget _stepItem({
    required String step,
    required String title,
    required bool isActive,
    bool isCompleted = false,
  }) {
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hintText,
    IconData? prefixIcon,
  }) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.kBorder.withOpacity(0.5)),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.kTextDark,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.kHint, fontSize: 12),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 16, color: AppColors.kRed) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ),
      ),
    );
  }
}