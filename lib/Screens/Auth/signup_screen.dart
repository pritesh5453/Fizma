import 'package:fizmaa/Screens/Auth/login_new.dart';
import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  // Category expanded state & selected items
  bool _isCategoryExpanded = false;
  final Map<String, bool> _categories = {
    'Venue Management': true,
    'Decoration Management': false,
    'Photographer Management': false,
    'Caterers Management': false,
  };

  bool _agreeToTerms = false;

  // Controllers
  final _businessNameController = TextEditingController(text: 'Luxury Architectural Marvel');
  final _experienceController = TextEditingController();
  final _fullNameController = TextEditingController(text: 'Pritesh Pawar');
  final _emailController = TextEditingController(text: 'pritesh@gmail.com');
  final _phoneController = TextEditingController(text: '9876543210');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppColors.screenGradient,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Logo & Illustration)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand Logo
                    Row(
                      children: [
                        Icon(
                          Icons.grid_view_rounded,
                          color: AppColors.primaryRed,
                          size: 24,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Fizmaa',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryRed,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    // Notepad / Clip Art Icon Placeholder
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.assignment_outlined,
                        size: 48,
                        color: AppColors.kRed.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Title & Subtitle
                const Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Reach more clients and expand your\nbusiness effortlessly',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 20),

                // Business Name Field
                _buildFieldLabel('Business Name'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _businessNameController,
                  hintText: 'Business Name',
                  icon: Icons.shopping_bag_outlined,
                ),
                const SizedBox(height: 16),

                // Category Field (Expandable Dropdown)
                _buildFieldLabel('Category'),
                const SizedBox(height: 6),
                _buildCategoryDropdown(),
                const SizedBox(height: 16),

                // Experience Field
                _buildFieldLabel('Experience (Years)'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _experienceController,
                  hintText: 'Experience (Years)',
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Full Name Field
                _buildFieldLabel('Full Name'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _fullNameController,
                  hintText: 'Full Name',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),

                // Email Field
                _buildFieldLabel('Email'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Mobile Number Field
                _buildFieldLabel('Mobile Number'),
                const SizedBox(height: 6),
                _buildPhoneTextField(),
                const SizedBox(height: 24),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      elevation: 4,
                      shadowColor: AppColors.primaryRed.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // OR Divider Text
                const Center(
                  child: Text(
                    'or',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Login Link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Terms & Conditions Checkbox
                Row(
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Checkbox(
                        value: _agreeToTerms,
                        activeColor: AppColors.primaryRed,
                        side: const BorderSide(color: AppColors.kHint),
                        onChanged: (val) {
                          setState(() {
                            _agreeToTerms = val ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          text: 'I have read and agree to the ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
      ),
    );
  }

  // Label Widget Helper
  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  // Standard Text Input Helper
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder.withOpacity(0.5)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.kHint, fontSize: 13),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.actionRedBg.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primaryRed, size: 18),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        ),
      ),
    );
  }

  // Phone Input Helper with Country Code
  Widget _buildPhoneTextField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder.withOpacity(0.5)),
      ),
      child: TextField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
        decoration: InputDecoration(
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.actionRedBg.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.phone_outlined, color: AppColors.primaryRed, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                '+91',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // Category Dropdown Widget
  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          // Header Bar for Dropdown
          InkWell(
            onTap: () {
              setState(() {
                _isCategoryExpanded = !_isCategoryExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.actionRedBg.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.category_outlined, color: AppColors.primaryRed, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Select Category',
                      style: TextStyle(color: AppColors.kHint, fontSize: 13),
                    ),
                  ),
                  Icon(
                    _isCategoryExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),

          // Dropdown Options List
          if (_isCategoryExpanded)
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.cardBorder),
                ),
              ),
              child: Column(
                children: _categories.keys.map((String key) {
                  final isSelected = _categories[key] ?? false;
                  return Container(
                    color: isSelected ? AppColors.actionRedBg.withOpacity(0.4) : Colors.transparent,
                    child: CheckboxListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      activeColor: AppColors.primaryRed,
                      value: isSelected,
                      title: Text(
                        key,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? AppColors.primaryRed : AppColors.textPrimary,
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) {
                        setState(() {
                          _categories[key] = value ?? false;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}