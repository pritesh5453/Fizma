import 'dart:math' as math;
import 'package:fizma/Screens/Auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// ============================================================
/// ASSET PATHS — just replace these with your own image paths.
/// Add more images to any list for a longer, smoother loop.
/// ============================================================
class SplashAssets {
  static const List<String> leftColumnImages = [
    'assets/images/splash1.png',
    'assets/images/splash2.png',
  ];

  static const List<String> middleColumnImages = [
    'assets/images/splash3.png',
    'assets/images/splash4.png',
    'assets/images/splash5.png',
  ];

  static const List<String> rightColumnImages = [
    'assets/images/splash6.png',
    'assets/images/splash7.png',
  ];
}

/// ============================================================
/// SPLASH / SIGN-UP SCREEN
///
/// Full-bleed auto-scrolling photo gallery in the background, a
/// pink -> red gradient fading in from the middle of the screen
/// down to the bottom, small white line-art icons scattered over
/// the gradient, and a headline + CTA button pinned near the bottom.
/// ============================================================
class SplashScreen2 extends StatelessWidget {
  const SplashScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ---------- Layer 1: full-screen scrolling photo gallery ----------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 34,
                child: _MarqueeImageColumn(
                  images: SplashAssets.leftColumnImages,
                  itemHeight: 165,
                  scrollUp: false,
                  speed: 12,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 32,
                child: _MarqueeImageColumn(
                  images: SplashAssets.middleColumnImages,
                  itemHeight: 140,
                  scrollUp: true,
                  speed: 16,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 34,
                child: Padding(
                  padding: const EdgeInsets.only(top: 36),
                  child: _MarqueeImageColumn(
                    images: SplashAssets.rightColumnImages,
                    itemHeight: 165,
                    scrollUp: false,
                    speed: 10,
                  ),
                ),
              ),
            ],
          ),

          // ---------- Layer 2: pink -> red gradient fade ----------
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.42, 0.6, 0.78, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      const Color(0xFFEF5350).withOpacity(0.55),
                      const Color(0xFFD32F2F).withOpacity(0.92),
                      const Color(0xFFB71C1C),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ---------- Layer 3: scattered white line-art decorations ----------
          // Swap these Icon widgets for your own line-art SVG/PNG assets
          // if you want an exact match — positions are % of screen size.
          const Positioned.fill(
            child: IgnorePointer(
              child: _DecorativeIcons(),
            ),
          ),

          // ---------- Layer 4: headline + subtext + CTA button ----------
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sign Up For New Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Enjoy seamless booking, secure payments, and\ntrusted stays — all in one app.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _GetStartedButton(onTap: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================
/// SCATTERED DECORATIVE ICONS
/// ============================================================
class _DecorativeIcons extends StatelessWidget {
  const _DecorativeIcons();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        Widget icon(
          IconData data, {
          required double xPct,
          required double yPct,
          double size = 22,
          double opacity = 0.35,
          double angle = 0,
        }) {
          return Positioned(
            left: w * xPct,
            top: h * yPct,
            child: Transform.rotate(
              angle: angle,
              child: Icon(
                data,
                size: size,
                color: Colors.white.withOpacity(opacity),
              ),
            ),
          );
        }

        return Stack(
          children: [
            icon(Icons.favorite_border, xPct: 0.08, yPct: 0.50, size: 20),
            icon(Icons.favorite_border, xPct: 0.80, yPct: 0.44, size: 16),
            icon(Icons.celebration, xPct: 0.68, yPct: 0.49, size: 26),
            icon(Icons.local_florist, xPct: 0.15, yPct: 0.58, size: 22),
            icon(Icons.music_note, xPct: 0.85, yPct: 0.58,
                size: 24, angle: -0.3),
            icon(Icons.card_giftcard, xPct: 0.72, yPct: 0.66, size: 26),
            icon(Icons.calendar_today, xPct: 0.10, yPct: 0.68, size: 22),
            icon(Icons.local_activity, xPct: 0.38, yPct: 0.62, size: 22),
            icon(Icons.all_inclusive, xPct: 0.10, yPct: 0.78, size: 22),
            icon(Icons.star_border, xPct: 0.85, yPct: 0.76, size: 20),
            icon(Icons.star_border, xPct: 0.30, yPct: 0.82, size: 14),
            icon(Icons.emoji_events, xPct: 0.60, yPct: 0.80, size: 20),
            icon(Icons.music_note, xPct: 0.55, yPct: 0.72, size: 24,
                angle: 0.15),
          ],
        );
      },
    );
  }
}

/// ============================================================
/// GET STARTED BUTTON — semi-transparent fill, dashed border
/// ============================================================
class _GetStartedButton extends StatelessWidget {
  final VoidCallback onTap;
  const _GetStartedButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      },
      child: CustomPaint(
        painter: _DashedRRectPainter(
          color: Colors.white.withOpacity(0.8),
          radius: 28,
        ),
        child: Container(
          width: double.infinity,
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.14),
            borderRadius: BorderRadius.circular(28),
          ),
          child: const Text(
            'Get Started',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double dashWidth;
  final double dashGap;
  final double strokeWidth;

  _DashedRRectPainter({
    required this.color,
    required this.radius,
    this.dashWidth = 6,
    this.dashGap = 4,
    this.strokeWidth = 1.4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = math.min(distance + dashWidth, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) => false;
}

/// ============================================================
/// INFINITE AUTO-SCROLLING IMAGE COLUMN (the "moving images")
/// ============================================================
///
/// Renders [images] stacked vertically and continuously scrolls them
/// up or down forever, looping seamlessly. No user interaction needed.
/// Uses LayoutBuilder so it always fills whatever height its parent
/// gives it, regardless of how many images are in the list.
class _MarqueeImageColumn extends StatefulWidget {
  final List<String> images;
  final double itemHeight;
  final bool scrollUp;
  final double speed; // pixels per second
  final double spacing;
  final double borderRadius;

  const _MarqueeImageColumn({
    required this.images,
    required this.itemHeight,
    this.scrollUp = true,
    this.speed = 15,
    this.spacing = 8,
    this.borderRadius = 0,
  });

  @override
  State<_MarqueeImageColumn> createState() => _MarqueeImageColumnState();
}

class _MarqueeImageColumnState extends State<_MarqueeImageColumn>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _offset = 0;
  Duration _lastElapsed = Duration.zero;

  double get _setHeight =>
      widget.images.length * (widget.itemHeight + widget.spacing);

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    final dt = (elapsed - _lastElapsed).inMicroseconds / 1e6;
    _lastElapsed = elapsed;
    final setHeight = _setHeight;
    if (setHeight <= 0) return;

    setState(() {
      _offset += widget.speed * dt;
      if (_offset >= setHeight) {
        _offset -= setHeight;
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Widget _buildTile(String path) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.spacing),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Image.asset(
          path,
          height: widget.itemHeight,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: widget.itemHeight,
            color: Colors.grey.shade300,
            alignment: Alignment.center,
            child: const Icon(Icons.image_outlined, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    final doubledImages = [...widget.images, ...widget.images];
    final setHeight = _setHeight;
    final translateY = widget.scrollUp ? -_offset : (_offset - setHeight);

    // Fills exactly whatever height the parent gives it.
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRect(
          child: SizedBox(
            height: constraints.maxHeight,
            width: double.infinity,
            child: OverflowBox(
              maxHeight: double.infinity,
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: Offset(0, translateY),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: doubledImages.map(_buildTile).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}