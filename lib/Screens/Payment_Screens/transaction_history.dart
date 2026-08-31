import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  int _selectedFilterIndex = 0; // 0: All, 1: Paid, 2: Payout

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Transaction History',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Track your earnings and payouts',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: AppColors.screenGradient,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Stat Cards (2x2 Grid)
              _buildTopStatGrid(),
              const SizedBox(height: 24),

              // 2. History Section Header & Filter Tabs
              const Text(
                'History',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildFilterTabs(),
              const SizedBox(height: 16),

              // 3. Transaction Cards List
              _buildTransactionCard(
                title: 'Arijit Singh Live Concert',
                subtitle: 'Fizmaa Organisation • 28 May 2026',
                status: 'PENDING',
                isPending: true,
                totalBooking: '₹50,000',
                platformFee: '₹5,000',
                yourEarnings: '₹45,000',
              ),
              const SizedBox(height: 12),

              _buildTransactionCard(
                title: 'FOOD CARNIVAL 2026',
                subtitle: 'Mumbai Events • 30 May 2026',
                status: 'PAID',
                isPending: false,
                totalBooking: '₹85,000',
                platformFee: '₹8,500',
                yourEarnings: '₹76,500',
              ),
              const SizedBox(height: 12),

              _buildTransactionCard(
                title: 'Tech Summit 2026',
                subtitle: 'Techverse Media • 30 May 2026',
                status: 'PENDING',
                isPending: true,
                totalBooking: '₹22,000',
                platformFee: '₹2,200',
                yourEarnings: '₹19,800',
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // --- Top Stats Grid ---
  Widget _buildTopStatGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                label: 'TOTAL EARNINGS',
                value: '₹2,40,000',
                valColor: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                label: 'COMMISSION',
                value: '₹24,000',
                valColor: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                label: 'PENDING PAYOUT',
                value: '₹35,000',
                valColor: AppColors.primaryRed,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                label: 'PAID AMOUNT',
                value: '₹1,81,000',
                valColor: AppColors.chipViewFg,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required String value,
    required Color valColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: valColor,
            ),
          ),
        ],
      ),
    );
  }

  // --- Filter Tabs ---
  Widget _buildFilterTabs() {
    final filters = ['All', 'Paid', 'Payout'];
    return Row(
      children: List.generate(filters.length, (index) {
        bool isSelected = _selectedFilterIndex == index;
        return Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryRed : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                filters[index],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.kWhite : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // --- Transaction Card ---
  Widget _buildTransactionCard({
    required String title,
    required String subtitle,
    required String status,
    required bool isPending,
    required String totalBooking,
    required String platformFee,
    required String yourEarnings,
  }) {
    final badgeBg = isPending ? AppColors.statOrangeBg : AppColors.chipViewBg;
    final badgeFg = isPending ? AppColors.statOrangeFg : AppColors.chipViewFg;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: badgeFg,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.cardBorder),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricColumn('TOTAL BOOKING', totalBooking),
              _buildMetricColumn('PLATFORM FEE', platformFee),
              _buildMetricColumn('YOUR EARNINGS', yourEarnings, isBold: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}