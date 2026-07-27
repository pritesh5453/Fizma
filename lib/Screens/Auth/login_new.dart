// lib/Screens/Auth/login_screen.dart

import 'package:fizma/Screens/Auth/otp_screen.dart';
import 'package:fizma/Screens/Auth/signup_screen.dart';
import 'package:fizma/Screens/onboarding/fizma_logo.dart';
import 'package:fizma/models_n_services/login/login_svc.dart';
import 'package:fizma/utils/app_preference.dart';
import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final OrganiserAuthService _authService = OrganiserAuthService();
  bool _isLoading = false;

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
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CreateAccountScreen()),
                          );
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

  // ------------------------------------------------------------------------
  // LOGIC
  // ------------------------------------------------------------------------
  Future<void> _login() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your mobile number")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      const String staticPassword = "password123";

      final response = await _authService.login(
        emailOrPhone: phone,
        password: staticPassword,
      );

      print("🔹 Success : ${response.success}");
      print("🔹 Message : ${response.message}");
      print("🔹 Token   : ${response.token}");
      print("🔹 Organiser ID   : ${response.organiser.id}");
      print("🔹 Organiser Email: ${response.organiser.email}");
      print("🔹 Organiser Phone: ${response.organiser.phoneNo}");
      print("🔹 Organisation    : ${response.organiser.organisationName}");

      if (response.success) {
        // ✅ Save organiser ID and other details in SharedPreferences
        await AppPreferences.setOrganiserId(response.organiser.id);
        await AppPreferences.setToken(response.token);
        await AppPreferences.setOrganiserDetails(
          email: response.organiser.email,
          phone: response.organiser.phoneNo,
          organisationName: response.organiser.organisationName,
        );

        // ✅ Navigate to OTP screen (as originally intended)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpScreen(phoneNumber: phone),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

/// Country-code chip ("+91") joined with the mobile number input.
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