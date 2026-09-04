import 'package:fizmaa/Screens/Auth/login_new.dart';
import 'package:fizmaa/Screens/navbar/navbar.dart';
import 'package:fizmaa/Screens/onboarding/decorative_icon.dart';
import 'package:fizmaa/Screens/onboarding/fizma_logo.dart';
import 'package:fizmaa/utils/app_preference.dart';
import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _wipeController;
  late final Animation<double> _wipeProgress;

  bool _showFinalRed = false;

  @override
  void initState() {
    super.initState();

    _wipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _wipeProgress = CurvedAnimation(
      parent: _wipeController,
      curve: Curves.easeInOutCubic,
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    // 1) Hold on solid red.
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    // 2) Diagonal wipe reveals the white icon-pattern + logo stage.
    await _wipeController.forward();
    if (!mounted) return;

    // 3) Hold on the white icon-pattern stage.
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    // 4) Crossfade to the final solid-red wordmark stage.
    setState(() => _showFinalRed = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    // 5) Hold, then check login status and navigate.
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    // ✅ Check if user already logged in
    final token = await AppPreferences.getToken();
    if (token != null && token.isNotEmpty) {
      // Already logged in – go to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const EventsNavBar(initialIndex: 0),
        ),
      );
    } else {
      // Not logged in – go to login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _wipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _showFinalRed ? const _RedWordmarkStage() : _buildWipeStage(),
      ),
    );
  }

  Widget _buildWipeStage() {
    return SizedBox.expand(
      key: const ValueKey('wipeStage'),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _WhiteIconLogoStage(),
          AnimatedBuilder(
            animation: _wipeProgress,
            builder: (context, child) {
              return ClipPath(
                clipper: _DiagonalWipeClipper(_wipeProgress.value),
                child: Container(color: AppColors.primaryRed),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WhiteIconLogoStage extends StatelessWidget {
  const _WhiteIconLogoStage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.kWhite,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DecorativeIconPattern(),
          const Center(child: FizmaaLogo(fontSize: 30, markSize: 32)),
        ],
      ),
    );
  }
}

class _RedWordmarkStage extends StatelessWidget {
  const _RedWordmarkStage();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('redStage'),
      width: double.infinity,
      height: double.infinity,
      color: AppColors.primaryRed,
      child: const Center(
        child: Text(
          'Fizmaa',
          style: TextStyle(
            color: AppColors.kWhite,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

class _DiagonalWipeClipper extends CustomClipper<Path> {
  _DiagonalWipeClipper(this.progress);

  final double progress;

  @override
  Path getClip(Size size) {
    final double w = size.width;
    final double h = size.height;

    final double xTop = w * progress;
    final double bottomProgress = ((progress - 0.25) / 0.75).clamp(0.0, 1.0);
    final double xBottom = w * bottomProgress;

    return Path()
      ..moveTo(xTop, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h)
      ..lineTo(xBottom, h)
      ..close();
  }

  @override
  bool shouldReclip(covariant _DiagonalWipeClipper oldClipper) =>
      oldClipper.progress != progress;
}