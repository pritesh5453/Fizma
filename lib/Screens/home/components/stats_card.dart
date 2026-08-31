import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';

/// A single stat card in the "Overview" 2x2 grid
/// (Active Events / Tickets Sold / Revenue / Upcoming).
class StatCard extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color fg;
  final String value;
  final String label;
  final String? subtext;

  const StatCard({
    super.key,
    required this.icon,
    required this.bg,
    required this.fg,
    required this.value,
    required this.label,
    this.subtext,
  });

  @override
@override
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: fg.withOpacity(0.12),
          blurRadius: 24,
          spreadRadius: 2,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Icon Box
        Container(
          width: 35,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                fg,
                fg.withOpacity(.75),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),

        const SizedBox(width: 14),

        /// Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtext != null) ...[
                const SizedBox(height: 8),
                Text(
                  "↗ $subtext",
                  style: TextStyle(
                    fontSize: 11,
                    color: fg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}
}