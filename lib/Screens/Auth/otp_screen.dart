import 'dart:async';
import 'package:fizma/Screens/navbar/navbar.dart';
import 'package:fizma/Screens/onboarding/fizma_logo.dart';
import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// OTP verification screen shown after "Send OTP" on [LoginScreen].
/// Same soft gradient background and footer treatment as the login
/// screen, with 6 individual code boxes, a masked phone number +
/// "Change" link, a Verify button and a resend countdown.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phoneNumber});

  /// Full national number (without country code), e.g. "9912345610".
  final String phoneNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _codeLength = 6;
  static const int _resendSeconds = 28;

  final List<TextEditingController> _controllers =
      List.generate(_codeLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_codeLength, (_) => FocusNode());

  Timer? _timer;
  int _secondsLeft = _resendSeconds;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = _resendSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  String get _maskedNumber {
    final String n = widget.phoneNumber;
    if (n.length < 4) return n;
    final String start = n.substring(0, 2);
    final String end = n.substring(n.length - 2);
    return '$start${'*' * (n.length - 4)}$end';
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < _codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  bool get _isComplete =>
      _controllers.every((c) => c.text.trim().isNotEmpty);

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
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
                // ---------- Logo + decorative shield icon ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const FizmaaLogo(fontSize: 22, markSize: 24),
                    const _ShieldSparkleIcon(),
                  ],
                ),
                const SizedBox(height: 28),

                // ---------- Heading ----------
                const Text(
                  'Enter OTP',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We sent a 6-digit code to',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          const TextSpan(
                            text: '+91 ',
                            style: TextStyle(color: AppColors.primaryRed),
                          ),
                          TextSpan(
                            text: _maskedNumber,
                            style: const TextStyle(color: AppColors.kTextDark),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: const Text(
                    'Change',
                    style: TextStyle(
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 26),

                // ---------- OTP boxes ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    _codeLength,
                    (index) => _OtpBox(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      autofocus: index == 0,
                      onChanged: (value) => _onChanged(index, value),
                    ),
                  ),
                ),
                const SizedBox(height: 26),

                // ---------- Verify button ----------
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
                        disabledBackgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _isComplete ? () {
                        Navigator.push(context, 
                              MaterialPageRoute(builder: (context) => const EventsNavBar()));
                      } : null,
                      child: Text(
                        'Verify & continue',
                        style: TextStyle(
                          color: AppColors.kWhite.withOpacity(_isComplete ? 1 : 0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ---------- Resend ----------
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Didn't receive the code? ",
                        style: TextStyle(
                          color: AppColors.kTextDark,
                          fontSize: 13,
                        ),
                      ),
                      GestureDetector(
                        onTap: _secondsLeft == 0 ? _startTimer : null,
                        child: Text(
                          _secondsLeft == 0
                              ? 'Resend'
                              : 'Resend in ${_secondsLeft}s',
                          style: const TextStyle(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // ---------- Validity notice ----------
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.kPinkLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.shield_outlined,
                          size: 16, color: AppColors.primaryRed),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'OTP is valid for 10 minutes. please don\'t share it with anyone.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.5,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

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

/// One box of the 6-digit OTP input. Highlights with a red border
/// while focused, matching the active first box in the reference.
class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 52,
      child: AnimatedBuilder(
        animation: focusNode,
        builder: (context, child) {
          final bool isFocused = focusNode.hasFocus;
          return TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: autofocus,
            onChanged: onChanged,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(
              color: AppColors.kTextDark,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColors.kWhite,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isFocused ? AppColors.primaryRed : AppColors.kBorder,
                  width: isFocused ? 1.8 : 1.2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isFocused ? AppColors.primaryRed : AppColors.kBorder,
                  width: isFocused ? 1.8 : 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primaryRed, width: 1.8),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Decorative shield-with-checkmark + sparkles icon used top-right,
/// matching the small illustration in the reference design.
class _ShieldSparkleIcon extends StatelessWidget {
  const _ShieldSparkleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.kPinkLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_rounded,
                color: AppColors.kBorder,
                size: 24,
              ),
            ),
          ),
          Positioned(
            top: -2,
            right: -2,
            child: Icon(Icons.auto_awesome_rounded,
                size: 12, color: AppColors.kBorder.withOpacity(0.8)),
          ),
          Positioned(
            bottom: 2,
            left: -4,
            child: Icon(Icons.auto_awesome_rounded,
                size: 10, color: AppColors.kBorder.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}