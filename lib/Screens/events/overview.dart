import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';

class EventOverviewTab extends StatelessWidget {
  const EventOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- 4 METRIC CARDS GRID ----------
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Revenue',
                  value: '₹276,000',
                  subtitle: 'total earned',
                  bgColor: const Color(0xFFFFF0F0),
                  textColor: const Color(0xFFE53935),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Tickets Sold',
                  value: '1,840',
                  subtitle: 'of 2,500',
                  bgColor: const Color(0xFFEEF2FF),
                  textColor: const Color(0xFF4F46E5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Tiers',
                  value: '3',
                  subtitle: 'ticket based',
                  bgColor: const Color(0xFFECFDF5),
                  textColor: const Color(0xFF059669),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Sessions',
                  value: '4',
                  subtitle: '2 venues',
                  bgColor: const Color(0xFFFFFBEB),
                  textColor: const Color(0xFFD97706),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ---------- CAPACITY FILL CARD ----------
          _buildCapacityFillCard(),
          const SizedBox(height: 16),

          // ---------- ABOUT CARD ----------
          _buildAboutCard(),
          const SizedBox(height: 16),

          // ---------- ARTISTS / SPEAKERS CARD ----------
          _buildArtistsCard(),
          const SizedBox(height: 16),

          // ---------- FACILITIES CARD ----------
          _buildFacilitiesCard(),
          const SizedBox(height: 20),

          // ---------- BOTTOM ACTION BUTTONS ----------
          _buildBottomActionButtons(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Metric Card Widget
  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: textColor.withOpacity(0.9),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10.5,
              color: textColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  // Capacity Fill Card
  Widget _buildCapacityFillCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Capacity Fill',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kTextDark,
                ),
              ),
              Text(
                '74%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFD97706),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: const LinearProgressIndicator(
              value: 0.74,
              minHeight: 8,
              backgroundColor: Color(0xFFF3F4F6),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '1,840 sold',
                style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
              Text(
                '660 remaining',
                style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // About Card
  Widget _buildAboutCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.kTextDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'The world\'s largest tech conference bringing together founders, CEOs, and innovators across AI, Web3, and the future of software. 3 days of keynotes, workshops, and networking.',
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.shield_outlined, 'Age: 18+'),
          const SizedBox(height: 6),
          _buildInfoRow(Icons.language, 'English, Spanish'),
          const SizedBox(height: 6),
          _buildInfoRow(Icons.calendar_today_outlined, '12 Sept 2025 – 14 Sept 2025'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildTag('#tech'),
              _buildTag('#AI'),
              _buildTag('#startup'),
              _buildTag('#networking'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 11.5, color: Color(0xFF4B5563)),
        ),
      ],
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: AppColors.kRed,
        ),
      ),
    );
  }

  // Artists Card
  Widget _buildArtistsCard() {
    final artists = [
      {'name': 'Sundar Pichai', 'initials': 'SP', 'color': const Color(0xFFEF4444)},
      {'name': 'Sam Altman', 'initials': 'SA', 'color': const Color(0xFFF59E0B)},
      {'name': 'Fei-Fei Li', 'initials': 'FL', 'color': const Color(0xFF10B981)},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.mic_none_rounded, size: 16, color: AppColors.kRed),
              SizedBox(width: 6),
              Text(
                'Artists / Speakers',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.kTextDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: artists.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final artist = artists[index];
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: artist['color'] as Color,
                      child: Text(
                        artist['initials'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            artist['name'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.kTextDark,
                            ),
                          ),
                          Row(
                            children: const [
                              Icon(Icons.star, size: 10, color: Color(0xFFF59E0B)),
                              SizedBox(width: 3),
                              Text(
                                'Featured Artist',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Lineup',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.kRed,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Facilities Card
  Widget _buildFacilitiesCard() {
    final facilities = [
      {'icon': Icons.wifi, 'label': 'WiFi'},
      {'icon': Icons.directions_car_outlined, 'label': 'Parking'},
      {'icon': Icons.local_cafe_outlined, 'label': 'F&B'},
      {'icon': Icons.accessible_rounded, 'label': 'Accessibility Ramp'},
      {'icon': Icons.temple_hindu_outlined, 'label': 'Prayer Room'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Facilities',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.kTextDark,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: facilities.map((f) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(f['icon'] as IconData, size: 13, color: const Color(0xFF4F46E5)),
                    const SizedBox(width: 6),
                    Text(
                      f['label'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Bottom Buttons
  Widget _buildBottomActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.edit_outlined,
            label: 'Edit Event',
            bgColor: const Color(0xFFEEF2FF),
            textColor: const Color(0xFF4F46E5),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionButton(
            icon: Icons.bar_chart_rounded,
            label: 'Analytics',
            bgColor: const Color(0xFFECFDF5),
            textColor: const Color(0xFF059669),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionButton(
            icon: Icons.share_outlined,
            label: 'Share',
            bgColor: const Color(0xFFFFFBEB),
            textColor: const Color(0xFFD97706),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}