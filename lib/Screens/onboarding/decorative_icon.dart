import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';

/// Faint scattered outline icons (calendar, wallet, gift, camera,
/// people, building, dots, sparkles, coins, music note, shop, tray...)
/// used as a decorative backdrop on the splash screen, matching the
/// hand-drawn "party/booking" motif around the Fizmaa logo.
class DecorativeIconPattern extends StatelessWidget {
  const DecorativeIconPattern({super.key, this.opacity = 1.0});

  final double opacity;

  static const List<_IconSpec> _icons = [
    _IconSpec(Icons.card_giftcard_rounded, 0.10, 0.06, 20, -0.2),
    _IconSpec(Icons.event_note_rounded, 0.09, 0.42, 26, 0.1),
    _IconSpec(Icons.account_balance_wallet_rounded, 0.11, 0.68, 24, 0.15),
    _IconSpec(Icons.photo_camera_rounded, 0.19, 0.14, 20, -0.15),
    _IconSpec(Icons.favorite_rounded, 0.16, 0.30, 12, 0.0),
    _IconSpec(Icons.groups_rounded, 0.28, 0.66, 24, 0.1),
    _IconSpec(Icons.receipt_long_rounded, 0.26, 0.78, 20, -0.1),
    _IconSpec(Icons.account_balance_rounded, 0.33, 0.25, 30, 0.0),
    _IconSpec(Icons.grid_4x4_rounded, 0.38, 0.80, 20, 0.0),
    _IconSpec(Icons.work_rounded, 0.52, 0.12, 22, -0.2),
    _IconSpec(Icons.dinner_dining_rounded, 0.53, 0.72, 24, 0.15),
    _IconSpec(Icons.grid_4x4_rounded, 0.60, 0.10, 20, 0.0),
    _IconSpec(Icons.music_note_rounded, 0.66, 0.16, 22, -0.1),
    _IconSpec(Icons.currency_rupee_rounded, 0.63, 0.86, 22, 0.0),
    _IconSpec(Icons.auto_awesome_rounded, 0.71, 0.30, 16, 0.0),
    _IconSpec(Icons.auto_awesome_rounded, 0.75, 0.66, 14, 0.0),
    _IconSpec(Icons.currency_rupee_rounded, 0.72, 0.20, 18, 0.0),
    _IconSpec(Icons.storefront_rounded, 0.83, 0.36, 24, 0.0),
    _IconSpec(Icons.mic_rounded, 0.85, 0.10, 20, -0.1),
    _IconSpec(Icons.redeem_rounded, 0.85, 0.24, 22, 0.1),
    _IconSpec(Icons.local_bar_rounded, 0.85, 0.48, 20, 0.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double w = constraints.maxWidth;
          final double h = constraints.maxHeight;
          return Stack(
            children: _icons
                .map(
                  (spec) => Positioned(
                    left: spec.left * w,
                    top: spec.top * h,
                    child: Transform.rotate(
                      angle: spec.rotation,
                      child: Icon(
                        spec.icon,
                        size: spec.size,
                        color: AppColors.primaryRed.withOpacity(0.28),
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

class _IconSpec {
  const _IconSpec(this.icon, this.top, this.left, this.size, this.rotation);

  final IconData icon;
  final double top;
  final double left;
  final double size;
  final double rotation;
}