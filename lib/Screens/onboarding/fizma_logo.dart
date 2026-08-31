import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';


/// The small "flag/ribbon" glyph that sits to the left of the
/// "Fizmaa" wordmark. Drawn with CustomPainter so it can be recolored
/// (red on light backgrounds, white on the red brand background).
class FizmaaMark extends StatelessWidget {
  const FizmaaMark({super.key, this.size = 26, this.color = AppColors.primaryRed});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _FizmaaMarkPainter(color)),
    );
  }
}

class _FizmaaMarkPainter extends CustomPainter {
  _FizmaaMarkPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final double w = size.width;
    final double h = size.height;

    // Top-left triangle (pointing right/down)
    final Path top = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.62, 0)
      ..lineTo(0, h * 0.62)
      ..close();
    canvas.drawPath(top, paint);

    // Bottom-right triangle (pointing left/up), offset to form the
    // folded-ribbon/flag look.
    final Path bottom = Path()
      ..moveTo(w * 0.42, h * 0.42)
      ..lineTo(w, h * 0.42)
      ..lineTo(w, h)
      ..lineTo(w * 0.42, h)
      ..close();
    canvas.drawPath(bottom, paint..color = color.withOpacity(0.85));
  }

  @override
  bool shouldRepaint(covariant _FizmaaMarkPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Full logo: [FizmaaMark] + "Fizmaa" wordmark, used in the splash
/// screen, the login screen header and anywhere else the brand mark
/// is needed.
class FizmaaLogo extends StatelessWidget {
  const FizmaaLogo({
    super.key,
    this.color = AppColors.primaryRed,
    this.fontSize = 24,
    this.markSize = 26,
  });

  /// Pass [AppColors.kWhite] to render the light variant used on the
  /// solid red brand-color screens.
  final Color color;
  final double fontSize;
  final double markSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FizmaaMark(size: markSize, color: color),
        const SizedBox(width: 6),
        Text(
          'Fizmaa',
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}