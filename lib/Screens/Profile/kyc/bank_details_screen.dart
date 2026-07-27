import 'package:fizma/Screens/navbar/navbar.dart';
import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';

class BankDetailsScreen extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onNextPressed;

  const BankDetailsScreen({
    Key? key,
    this.onBackPressed,
    this.onNextPressed,
  }) : super(key: key);

  // Success Dialog / Popup
  void _showSavedSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
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
                // Top Close (X) Button - Navigates directly to ProfileScreen
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(); // Popup close karega
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const EventsNavBar(initialIndex: 3)),
                        (route) => false, // Prevents going back to form after submission
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEE2E2), // Light red bg
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

                // Success Icon with Confetti effect decoration
                SizedBox(
                  height: 90,
                  width: 90,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Dots / Confetti elements
                      Positioned(top: 0, right: 25, child: _buildDot(Colors.redAccent, 8)),
                      Positioned(top: 15, left: 15, child: _buildDot(Colors.orangeAccent, 6)),
                      Positioned(top: 30, left: 0, child: _buildDot(Colors.purpleAccent, 5)),
                      Positioned(bottom: 25, right: 10, child: _buildDot(Colors.blueAccent, 5)),
                      Positioned(bottom: 10, right: 20, child: _buildDot(Colors.greenAccent, 7)),
                      Positioned(bottom: 5, left: 20, child: _buildDot(Colors.yellow, 7)),

                      // Main Green Check Badge
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFDCFCE7), // Light green outer ring
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E), // Solid green circle
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

                // Title Text
                const Text(
                  "Saved Successfully",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kTextDark,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle Text
                const Text(
                  "Business Information updated successfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  // Small Dot Builder for Confetti Effect
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppColors.screenGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.kTextDark, size: 20),
            onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
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
                initialValue: "C8893202",
                prefixIcon: Icons.edit_outlined,
              ),
              const SizedBox(height: 14),

              // IFSC Code
              _buildLabel("IFSC Code"),
              _buildTextField(
                hintText: "IFSC Code",
                prefixIcon: Icons.edit_outlined,
              ),
              const SizedBox(height: 14),

              // Bank Name
              _buildLabel("Bank Name"),
              _buildTextField(
                initialValue: "SBI Bank",
                prefixIcon: Icons.account_balance_outlined,
              ),
              const SizedBox(height: 14),

              // Account Holder Name
              _buildLabel("Account Holder Name"),
              _buildTextField(
                initialValue: "Vendor name",
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 14),

              // UPI ID
              _buildLabel("UPI ID"),
              _buildTextField(
                initialValue: "sanjay.m@okaxis",
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
                        onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
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
                        onPressed: () {
                          // Show Popup Dialog
                          _showSavedSuccessDialog(context);
                        },
                        child: const Text(
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

  // Stepper Bar Component
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
          _stepItem(step: "1", title: "Business Info", isActive: false, isCompleted: true),
          _stepDivider(),
          _stepItem(step: "2", title: "KYC Details", isActive: false, isCompleted: true),
          _stepDivider(),
          _stepItem(step: "3", title: "Bank Details", isActive: true, isCompleted: false),
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
    String? initialValue,
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
        initialValue: initialValue,
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