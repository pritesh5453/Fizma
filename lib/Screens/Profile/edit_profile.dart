import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';

/// Function to trigger the popup dialog
void showBasicDetailsDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return const BasicDetailsDialog();
    },
  );
}

class BasicDetailsDialog extends StatefulWidget {
  const BasicDetailsDialog({Key? key}) : super(key: key);

  @override
  State<BasicDetailsDialog> createState() => _BasicDetailsDialogState();
}

class _BasicDetailsDialogState extends State<BasicDetailsDialog> {
  // Form controllers pre-filled with the UI data
  final TextEditingController _nameController =
      TextEditingController(text: 'Pritesh Pawar');
  final TextEditingController _emailController =
      TextEditingController(text: 'pritesh@gmail.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '+91 98765 43210');
  final TextEditingController _dobController =
      TextEditingController(text: '01 January 1999');
  final TextEditingController _genderController =
      TextEditingController(text: 'Male');
  final TextEditingController _cityController =
      TextEditingController(text: 'Nashik');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          // Uses soft pinkish bottom gradient from screenGradient palette
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3, 1.0],
            colors: [
              Colors.white,
              AppColors.kPink, // Color(0xFFFBBEBE) / Color(0xFFF9C9CB)
            ],
          ),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: Colors.white.withOpacity(0.6),
            width: 1.5,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section (Title + Close Button)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Basic Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.kTextDark,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.actionRedBg, // Light pinkish tint
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Full Name
              _buildLabel('Full Name'),
              const SizedBox(height: 6),
              _buildInputField(
                controller: _nameController,
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 14),

              // Email Address
              _buildLabel('Email Address'),
              const SizedBox(height: 6),
              _buildInputField(
                controller: _emailController,
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 14),

              // Phone Number
              _buildLabel('Phone Number'),
              const SizedBox(height: 6),
              _buildInputField(
                controller: _phoneController,
                icon: Icons.phone_outlined,
              ),
              const SizedBox(height: 14),

              // Date of Birth
              _buildLabel('Date of Birth'),
              const SizedBox(height: 6),
              _buildInputField(
                controller: _dobController,
                icon: Icons.calendar_today_outlined,
              ),
              const SizedBox(height: 14),

              // Gender & City Side-by-Side Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Gender'),
                        const SizedBox(height: 6),
                        _buildInputField(
                          controller: _genderController,
                          icon: Icons.person_outline_rounded,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('City'),
                        const SizedBox(height: 6),
                        _buildInputField(
                          controller: _cityController,
                          icon: Icons.anchor_rounded,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Gradient Save Button
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.headerStart, // 0xFFE13A46
                      AppColors.primaryRed,  // 0xFFE63950
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryRed.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                  
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.kWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Label Widget Helper
  Widget _buildLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }

  // Rounded Input Field Helper with Custom Border & Pink Tinted Icons
  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.kTextDark,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          prefixIcon: Icon(
            icon,
            size: 18,
            color: AppColors.primaryRed.withOpacity(0.7),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 36,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}