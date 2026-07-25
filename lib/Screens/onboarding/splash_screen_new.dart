import 'package:fizma/Screens/Auth/login_new.dart';
import 'package:fizma/Screens/onboarding/decorative_icon.dart';
import 'package:fizma/Screens/onboarding/fizma_logo.dart';
import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';

/// Splash screen that reproduces the actual designed animation:
///
/// 1. Solid brand-red screen.
/// 2. A diagonal wipe sweeps across, revealing the white background
///    with the scattered decorative icon pattern and the red Fizmaa
///    logo underneath (matches the Figma "wipe" transition frames).
/// 3. That stage holds briefly, then crossfades into the final solid
///    red screen with the white "Fizmaa" wordmark centered.
/// 4. Navigates to [LoginScreen].
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

    // 5) Hold, then hand off to the login screen.
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
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

  /// White icon-pattern + logo stage, with a solid-red layer on top
  /// that gets clipped away diagonally as [_wipeProgress] advances.
  Widget _buildWipeStage() {
    return SizedBox.expand(
      key: const ValueKey('wipeStage'),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Base: white background + decorative icons + centered logo.
          const _WhiteIconLogoStage(),
          // Overlay: solid red, clipped diagonally, shrinks to reveal
          // the base layer beneath as the wipe animates.
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

/// White background, decorative icon pattern and the red Fizmaa logo
/// centered on screen — matches the third reference frame.
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

/// Final solid red brand screen with the white wordmark centered —
/// matches the fourth reference frame.
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

/// Clips a quadrilateral that starts as the full screen (progress 0)
/// and shrinks toward the bottom-right corner (progress 1), with the
/// top edge sweeping faster than the bottom edge so the boundary
/// reads as a diagonal wipe rather than a straight vertical line.
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