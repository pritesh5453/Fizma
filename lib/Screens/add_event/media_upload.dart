import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'add_venue_screen.dart';

class MediaUploadScreen extends StatefulWidget {
  const MediaUploadScreen({super.key});

  @override
  State<MediaUploadScreen> createState() => _MediaUploadScreenState();
}

class _MediaUploadScreenState extends State<MediaUploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: AppColors.screenGradient,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              _buildProgressBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Event Banner'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _dashedUploadBox(
                              icon: Icons.desktop_windows_outlined,
                              title: 'Horizontal (Desktop)',
                              subtitle: '16:9 - up to 5MB',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _dashedUploadBox(
                              icon: Icons.stay_primary_portrait_outlined,
                              title: 'Vertical (Mobile)',
                              subtitle: '9:16 - up to 5MB',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      _sectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Promotional Video (Optional)'),
                            const SizedBox(height: 10),
                            _textField(hint: 'Paste YouTube or Vimeo link'),
                            const SizedBox(height: 10),
                            const Center(
                              child: Text(
                                'or',
                                style: TextStyle(color: AppColors.kHint, fontSize: 12.5),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _dashedUploadBox(
                              icon: Icons.file_upload_outlined,
                              title: 'Upload video file',
                              subtitle: 'MP4, MOV - up to 500MB',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      _sectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Gallery (Optional)'),
                            const SizedBox(height: 10),
                            _dashedUploadBox(
                              icon: Icons.add_circle_outline,
                              title: 'Add photo',
                              subtitle: null,
                              iconOnTop: false,
                              big: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      _label('Sponsor Name'),
                      _textField(hint: 'Enter name'),
                      const SizedBox(height: 16),

                      _label('Sponsor Website (Optional)'),
                      _textField(hint: 'Enter name'),
                      const SizedBox(height: 16),

                      _sectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Add Logo'),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _dashedUploadBox(
                                    icon: Icons.desktop_windows_outlined,
                                    title: 'Horizontal (Desktop)',
                                    subtitle: '16:9 - up to 5MB',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _dashedUploadBox(
                                    icon: Icons.stay_primary_portrait_outlined,
                                    title: 'Vertical (Mobile)',
                                    subtitle: '9:16 - up to 5MB',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildBottomButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Top App Bar ----------
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.kTextDark),
          ),
          const Text(
            'Media Upload',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.kTextDark,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Progress Bar (4 segments, step 2 partially active) ----------
  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: List.generate(4, (index) {
          double fill;
          if (index == 0) {
            fill = 1.0;
          } else if (index == 1) {
            fill = 0.5;
          } else {
            fill = 0.0;
          }
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index == 3 ? 0 : 6),
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: fill,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.kRed,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------- Section Label ----------
  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.kTextDark,
      ),
    );
  }

  // ---------- Card wrapper used for bordered pink-tinted sections ----------
  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: child,
    );
  }

  // ---------- Simple Text Field ----------
  Widget _textField({required String hint}) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.kHint, fontSize: 14),
        ),
        style: const TextStyle(fontSize: 14, color: AppColors.kTextDark),
      ),
    );
  }

  // ---------- Dashed Upload Box ----------
  Widget _dashedUploadBox({
    required IconData icon,
    required String title,
    String? subtitle,
    bool iconOnTop = true,
    bool big = false,
  }) {
    return CustomPaint(
      painter: _DashedBorderPainter(color: AppColors.kRed, radius: 10),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: big ? 26 : 16, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.kChipBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.kRed, size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.kTextDark,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 3),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10.5, color: AppColors.kHint),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ---------- Bottom Back / Save & Proceed Buttons ----------
  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.kWhite,
                  side: const BorderSide(color: AppColors.kRed, width: 1.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kRed,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddVenueScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kRed,
                  foregroundColor: AppColors.kWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save & Proceed',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Custom dashed rounded-rectangle border painter ----------
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double dashWidth;
  final double dashGap;

  _DashedBorderPainter({
    required this.color,
    this.radius = 10,
    this.dashWidth = 5,
    this.dashGap = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    final dashedPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        dashedPath.addPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          Offset.zero,
        );
        distance = next + dashGap;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) => false;
}