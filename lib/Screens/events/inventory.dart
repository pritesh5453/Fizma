import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';

class EventInventoryTab extends StatelessWidget {
  const EventInventoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- BANNER CARD ----------
          _buildTopSummaryBanner(),
          const SizedBox(height: 16),

          // ---------- REVENUE BY TIER SUMMARY CARD ----------
          _buildRevenueByTierCard(),
          const SizedBox(height: 16),

          // ---------- TIER 1: GENERAL ----------
          _buildTicketTierCard(
            tierNumber: '1',
            tierName: 'General',
            price: '₹99',
            description: 'Full 3-day access to all keynotes and networking zones.',
            sold: '1,200',
            total: '1,500',
            revenue: '₹118,800',
            fillPercentage: 0.80,
            fillRateText: '80%',
            remainingText: '300 remaining',
            badgeColor: const Color(0xFFEF4444),
            progressColor: const Color(0xFFF59E0B),
            tags: [
              _buildTag('🔞 18+', const Color(0xFFFEF3C7), const Color(0xFFD97706)),
            ],
          ),
          const SizedBox(height: 14),

          // ---------- TIER 2: PRO ----------
          _buildTicketTierCard(
            tierNumber: '2',
            tierName: 'Pro',
            price: '₹199',
            description: 'All General perks + workshop access + speaker meet & greet.',
            sold: '540',
            total: '800',
            revenue: '₹107,460',
            fillPercentage: 0.68,
            fillRateText: '68%',
            remainingText: '260 remaining',
            badgeColor: const Color(0xFF4F46E5),
            progressColor: const Color(0xFFF59E0B),
            tags: [
              _buildTag('🔞 18+', const Color(0xFFFEF3C7), const Color(0xFFD97706)),
              _buildTag('⚡ Dynamic', const Color(0xFFFEF3C7), const Color(0xFFD97706)),
            ],
          ),
          const SizedBox(height: 14),

          // ---------- TIER 3: VIP ----------
          _buildTicketTierCard(
            tierNumber: '3',
            tierName: 'VIP',
            price: '₹499',
            description: 'All Pro perks + VIP lounge, priority seating, and gala dinner.',
            sold: '100',
            total: '200',
            revenue: '₹49,900',
            fillPercentage: 0.50,
            fillRateText: '50%',
            remainingText: '100 remaining',
            badgeColor: const Color(0xFF10B981),
            progressColor: const Color(0xFF10B981),
            tags: [
              _buildTag('🔞 18+', const Color(0xFFFEF3C7), const Color(0xFFD97706)),
              _buildTag('🎟️ Advance 50%', const Color(0xFFEEF2FF), const Color(0xFF4F46E5)),
            ],
          ),
          const SizedBox(height: 20),

          // ---------- ADD TICKET TIER BUTTON ----------
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kRed,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.confirmation_number_outlined, size: 18),
              label: const Text(
                '+ Add Ticket Tier',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Top Light Red Banner
  Widget _buildTopSummaryBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFFCA5A5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.confirmation_number_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Ticket-Based Event',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF991B1B),
                ),
              ),
              SizedBox(height: 1),
              Text(
                '3 tiers · ₹276,160 collected',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFFB91C1C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Revenue By Tier Breakdown
  Widget _buildRevenueByTierCard() {
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
            'Revenue by Tier',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.kTextDark,
            ),
          ),
          const SizedBox(height: 12),
          _buildRevenueRow('General', '₹118,800', '(43%)', 0.43, const Color(0xFFEF4444)),
          const SizedBox(height: 10),
          _buildRevenueRow('Pro', '₹107,460', '(39%)', 0.39, const Color(0xFF4F46E5)),
          const SizedBox(height: 10),
          _buildRevenueRow('VIP', '₹49,900', '(18%)', 0.18, const Color(0xFF10B981)),
        ],
      ),
    );
  }

  Widget _buildRevenueRow(String label, String amount, String percentage, double val, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 11.5, color: Color(0xFF4B5563))),
            Row(
              children: [
                Text(amount, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.kTextDark)),
                const SizedBox(width: 4),
                Text(percentage, style: const TextStyle(fontSize: 10.5, color: Color(0xFF9CA3AF))),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: val,
            minHeight: 5,
            backgroundColor: const Color(0xFFF3F4F6),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  // Individual Ticket Tier Card
  Widget _buildTicketTierCard({
    required String tierNumber,
    required String tierName,
    required String price,
    required String description,
    required String sold,
    required String total,
    required String revenue,
    required double fillPercentage,
    required String fillRateText,
    required String remainingText,
    required Color badgeColor,
    required Color progressColor,
    required List<Widget> tags,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: badgeColor,
                    child: Text(
                      tierNumber,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tierName,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.kTextDark),
                  ),
                ],
              ),
              Text(
                price,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.kTextDark),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280), height: 1.3),
          ),
          const SizedBox(height: 12),

          // Metrics Box
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCardStat(sold, 'Sold'),
                Container(width: 1, height: 24, color: const Color(0xFFE5E7EB)),
                _buildCardStat(total, 'Total'),
                Container(width: 1, height: 24, color: const Color(0xFFE5E7EB)),
                _buildCardStat(revenue, 'Revenue', isGreen: true),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Fill rate
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Fill rate', style: TextStyle(fontSize: 10.5, color: Color(0xFF9CA3AF))),
              Text(
                fillRateText,
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: progressColor),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fillPercentage,
              minHeight: 6,
              backgroundColor: const Color(0xFFF3F4F6),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            remainingText,
            style: const TextStyle(fontSize: 10.5, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 10),

          // Tag Pills
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags,
          ),
        ],
      ),
    );
  }

  Widget _buildCardStat(String value, String label, {bool isGreen = false}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: isGreen ? const Color(0xFF059669) : AppColors.kTextDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
        ),
      ],
    );
  }

  static Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }
}