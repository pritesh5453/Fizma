import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// ============================================================
// ASSET PATHS – use the splash-specific images
// ============================================================
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

// ============================================================
// SPLASH SCREEN
// ============================================================
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Make the gallery taller than in the sign‑in screen – here 60% of screen
    final galleryHeight = screenHeight * 0.60;
    // This spacer pushes the white content down so it starts just below
    // the lowest point of the wave (on the left side).
    final contentTopSpacer = galleryHeight * 0.76;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ---------- Layer 1: full‑screen white base ----------
          Positioned.fill(
            child: Container(
              color: Colors.white,
              child: SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: contentTopSpacer),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          children: [
                            // ---- Main Heading ----
                            const Text(
                              'Book Your Dream Event\nAnytime, Anywhere\nWith Ease',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2B2B2B),
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // ---- Subtitle ----
                            const Text(
                              'Design a unique experience tailored to your vision. '
                              'From intimate gatherings to grand celebrations, '
                              'we’ll help bring your ideas to life.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 40),
                            // ---- Get Started Button ----
                            _SplashButton(
                              onTap: () {
                                // TODO: navigate to your sign‑in / home screen
                              },
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ---------- Layer 2: scrolling photo gallery (foreground) ----------
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: galleryHeight,
            child: ClipPath(
              clipper: _GalleryWaveClipper(),
              child: Container(
                color: const Color(0xFFFDF1F1), // fallback background
                child: Row(
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
                    const SizedBox(width: 6),
                    Expanded(
                      flex: 32,
                      child: _MarqueeImageColumn(
                        images: SplashAssets.middleColumnImages,
                        itemHeight: 140,
                        scrollUp: true,
                        speed: 16,
                      ),
                    ),
                    const SizedBox(width: 6),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SPLASH BUTTON (similar to login button but with different label)
// ============================================================
class _SplashButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SplashButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEF5350), Color(0xFFB71C1C)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFB71C1C).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Text(
          'Get Started',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// GALLERY WAVE CLIPPER – same as in SignInScreen
// ============================================================
class _GalleryWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(w, 0);
    path.lineTo(w, h * 0.945);
    path.lineTo(w * 0.55, h * 0.945);
    path.quadraticBezierTo(w * 0.40, h * 1.0, w * 0.30, h * 0.88);
    path.quadraticBezierTo(w * 0.14, h * 0.70, 0, h * 0.76);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// ============================================================
// INFINITE AUTO-SCROLLING IMAGE COLUMN – same as before
// ============================================================
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
    this.borderRadius = 14,
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
            color: Colors.grey.shade200,
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