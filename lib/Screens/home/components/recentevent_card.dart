import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';

/// A single event card in the "Recent Events" list.
class RecentEventCard extends StatelessWidget {
  final String title;
  final String tag;
  final bool isLive;
  final String location;
  final String date;
  final String sold;
  final String revenue;
  final double percentSold;
  final List<Color> thumbGradient;
  final IconData thumbIcon;

  const RecentEventCard({
    super.key,
    required this.title,
    required this.tag,
    required this.isLive,
    required this.location,
    required this.date,
    required this.sold,
    required this.revenue,
    required this.percentSold,
    required this.thumbGradient,
    required this.thumbIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Thumbnail(gradient: thumbGradient, icon: thumbIcon, isLive: isLive),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.tagBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.tagFg,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 11, color: AppColors.textSecondary),
                    const SizedBox(width: 3),
                    Text(location, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
                    const SizedBox(width: 8),
                    const Icon(Icons.calendar_today_outlined, size: 10, color: AppColors.textSecondary),
                    const SizedBox(width: 3),
                    Text(date, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _StatColumn(label: 'SOLD', value: sold),
                    const SizedBox(width: 20),
                    _StatColumn(label: 'REVENUE', value: revenue),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: percentSold,
                          minHeight: 5,
                          backgroundColor: AppColors.progressBg,
                          valueColor: const AlwaysStoppedAnimation(AppColors.progressFill),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(percentSold * 100).round()}% Sold',
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _IconChip(
                      icon: Icons.remove_red_eye_outlined,
                      bg: AppColors.chipViewBg,
                      fg: AppColors.chipViewFg,
                    ),
                    const SizedBox(width: 6),
                    _IconChip(
                      icon: Icons.edit_outlined,
                      bg: AppColors.chipEditBg,
                      fg: AppColors.chipEditFg,
                    ),
                    const SizedBox(width: 6),
                    _IconChip(
                      icon: Icons.delete_outline,
                      bg: AppColors.chipDeleteBg,
                      fg: AppColors.chipDeleteFg,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final List<Color> gradient;
  final IconData icon;
  final bool isLive;

  const _Thumbnail({required this.gradient, required this.icon, required this.isLive});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 118,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(icon, color: Colors.white70, size: 26),
        ),
        if (isLive)
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.liveBadgeBg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 8.5,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _IconChip extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color fg;
  const _IconChip({required this.icon, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 13, color: fg),
    );
  }
}