import 'package:fizma/Screens/Auth/otp_screen.dart';
import 'package:fizma/Screens/Auth/signup_screen.dart';
import 'package:fizma/Screens/onboarding/fizma_logo.dart';
import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';

/// Login screen — mobile number + OTP flow, matching the actual
/// reference design: soft white-to-pink [AppColors.screenGradient]
/// background (no colored header), Fizmaa logo top-left, a faint
/// unlock illustration top-right, and a bottom "Sign Up" / privacy
/// policy footer.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: AppColors.screenGradient,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- Logo + decorative unlock icon ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const FizmaaLogo(fontSize: 22, markSize: 24),
                    Icon(
                      Icons.lock_open_rounded,
                      size: 44,
                      color: AppColors.kBorder.withOpacity(0.6),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ---------- Heading ----------
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your bookings and grow your business effortlessly.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 28),

                // ---------- Mobile number field ----------
                const Text(
                  'MOBILE NUMBER',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 8),
                _MobileNumberField(controller: _phoneController),
                const SizedBox(height: 14),

                // ---------- OTP notice ----------
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.kPinkLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined,
                          size: 16, color: AppColors.primaryRed),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "We'll send a secure OTP to verify your access.",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // ---------- Send OTP button ----------
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryRed, AppColors.primaryRedDark],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => const OtpScreen(phoneNumber: '',)));
                      },
                      child: const Text(
                        'Send OTP',
                        style: TextStyle(
                          color: AppColors.kWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),

                // ---------- Divider ----------
                Row(
                  children: [
                    Expanded(
                        child: Divider(color: AppColors.kBorder, thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or',
                        style: TextStyle(
                          color: AppColors.primaryRed,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Divider(color: AppColors.kBorder, thickness: 1)),
                  ],
                ),
                const SizedBox(height: 18),

                // ---------- Sign up ----------
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'New vendor? ',
                        style: TextStyle(
                            color: AppColors.kTextDark, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => const CreateAccountScreen()));
                        },
                        child: const Text(
                          'Sign Up Now',
                          style: TextStyle(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // ---------- Footer: privacy policy links ----------
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.privacy_tip_outlined,
                          size: 14, color: AppColors.kHint),
                      const SizedBox(width: 4),
                      Text(
                        'Privacy Policy',
                        style: TextStyle(color: AppColors.kHint, fontSize: 12),
                      ),
                      const SizedBox(width: 14),
                      Container(width: 1, height: 12, color: AppColors.kHint),
                      const SizedBox(width: 14),
                      Icon(Icons.lock_outline_rounded,
                          size: 14, color: AppColors.kHint),
                      const SizedBox(width: 4),
                      Text(
                        'Privacy Policy',
                        style: TextStyle(color: AppColors.kHint, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Country-code chip ("+91") joined with the mobile number input,
/// styled with the app's pink border palette.
class _MobileNumberField extends StatelessWidget {
  const _MobileNumberField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.kPinkLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.phone_rounded, size: 16, color: AppColors.primaryRed),
                SizedBox(width: 4),
                Text(
                  '+91',
                  style: TextStyle(
                    color: AppColors.kTextDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 2),
                Icon(Icons.keyboard_arrow_down_rounded,
                    size: 16, color: AppColors.kHint),
              ],
            ),
          ),
          Container(width: 1, height: 26, color: AppColors.kBorder),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: AppColors.kTextDark, fontSize: 15),
              decoration: const InputDecoration(
                hintText: 'Enter number',
                hintStyle: TextStyle(color: AppColors.kHint, fontSize: 14),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}