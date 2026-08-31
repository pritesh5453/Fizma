import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';

class CancellationRequestScreen extends StatefulWidget {
  const CancellationRequestScreen({Key? key}) : super(key: key);

  @override
  State<CancellationRequestScreen> createState() =>
      _CancellationRequestScreenState();
}

class _CancellationRequestScreenState
    extends State<CancellationRequestScreen> {
  int _selectedResponse = 0; // 0: No Dispute, 1: Dispute

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
        title: const Text(
          'Cancellation Request',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: AppColors.screenGradient,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Action Required Top Banner
              _buildActionRequiredBanner(),
              const SizedBox(height: 16),

              // 2. Cancellation Request Details Table Card
              _buildDetailsCard(),
              const SizedBox(height: 16),

              // 3. Customer's Reason Card
              _buildReasonCard(),
              const SizedBox(height: 12),

              // 4. Admin Info Note Banner
              _buildAdminNoteBanner(),
              const SizedBox(height: 16),

              // 5. Response Selection Options Card
              _buildResponseSelectionCard(),
              const SizedBox(height: 16),

              // 6. Attach Proof Box (Optional)
              _buildAttachProofCard(),
              const SizedBox(height: 16),

              // 7. Response Deadline Box
              _buildDeadlineCard(),
              const SizedBox(height: 20),

              // 8. Buttons (Submit & Draft)
              _buildActionButtons(),
              const SizedBox(height: 16),

              // 9. View Full Details Link
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View Full Booking Details ›',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // 10. Footer Disclaimer & Support Link
              _buildFooterDisclaimer(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- Top Banner ---
  Widget _buildActionRequiredBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.statOrangeBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.statOrangeFg.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.statOrangeFg, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Action Required',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.statOrangeFg,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'A customer has requested cancellation... Please share your response before Oct 20, 2024.',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Request Details Table Card ---
  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CANCELLATION REQUEST DETAILS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Customer Name', 'Dipika'),
          _buildDetailRow('Booking ID', '#BK-20241024', isBoldVal: true),
          _buildDetailRow('Event Name', 'Bhajan Concert', isBoldVal: true),
          _buildDetailRow('Ticket Type', 'VIP', isBoldVal: true),
          _buildDetailRow('No of Tickets', '2'),
          _buildDetailRow('Event Date', 'October 24, 2024', isBoldVal: true),
          _buildDetailRow('Event Time', '10:00 AM – 08:00 PM', isBoldVal: true),
          _buildDetailRow('Amount Paid', '₹798.00',
              valColor: AppColors.statGreenFg, isBoldVal: true),
          _buildDetailRow('Request Raised On', 'October 18, 2024 3:42 PM',
              isBoldVal: true, hideDivider: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? valColor,
    bool isBoldVal = false,
    bool hideDivider = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isBoldVal ? FontWeight.bold : FontWeight.normal,
                  color: valColor ?? AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (!hideDivider)
          const Divider(height: 1, color: AppColors.cardBorder),
      ],
    );
  }

  // --- Customer's Reason ---
  Widget _buildReasonCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "CUSTOMER'S REASON FOR CANCELLATION",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.actionRedBg.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  'Unable to attend the event due to a medical emergency. Requesting full refund.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.primaryRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Oct 18, 2024 – 3:42 PM',
                  style: TextStyle(
                    fontSize: 9,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Admin Note Banner ---
  Widget _buildAdminNoteBanner() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.chipViewBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.info_outline, color: AppColors.chipViewFg, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Note: Refund amount is managed and processed by Admin. Your response here is your official opinion only.',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.chipViewFg,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Response Selection Card ---
  Widget _buildResponseSelectionCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'YOUR RESPONSE TO THIS REQUEST',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          _buildResponseOption(
            index: 0,
            title: "I'm okay with the cancellation",
            subtitle:
                'I have no objection to a full refund based on the platform policy.',
            badgeText: 'NO DISPUTE',
            badgeBg: AppColors.statGreenBg,
            badgeFg: AppColors.statGreenFg,
            icon: Icons.check_circle,
            iconColor: AppColors.statGreenFg,
          ),
          const SizedBox(height: 10),
          _buildResponseOption(
            index: 1,
            title: 'I have a concern',
            subtitle:
                'I request consideration for losses incurred due to this cancellation.',
            badgeText: 'DISPUTE',
            badgeBg: AppColors.actionRedBg,
            badgeFg: AppColors.primaryRed,
            icon: Icons.cancel,
            iconColor: AppColors.primaryRed,
          ),
        ],
      ),
    );
  }

  Widget _buildResponseOption({
    required int index,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeBg,
    required Color badgeFg,
    required IconData icon,
    required Color iconColor,
  }) {
    bool isSelected = _selectedResponse == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedResponse = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? badgeBg.withOpacity(0.3) : AppColors.kWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? iconColor : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  size: 18,
                  color: isSelected ? iconColor : AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Icon(icon, color: iconColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: badgeFg,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 26.0),
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Attach Proof Box ---
  Widget _buildAttachProofCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ATTACH PROOF (OPTIONAL)',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.kBorder, style: BorderStyle.solid),
            ),
            child: Column(
              children: const [
                Icon(Icons.cloud_upload_outlined,
                    color: AppColors.primaryRed, size: 24),
                SizedBox(height: 6),
                Text(
                  'Tap to upload photos or receipts',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'JPG, PNG or PDF. Max 5MB per file.',
                  style: TextStyle(
                    fontSize: 9,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.cardBorder),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.article_outlined,
                color: AppColors.textSecondary, size: 20),
          ),
        ],
      ),
    );
  }

  // --- Response Deadline Card ---
  Widget _buildDeadlineCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'RESPONSE DEADLINE',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: AppColors.statOrangeFg,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Oct 20, 2024 by 11:59 PM',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Icon(Icons.access_time, color: AppColors.statOrangeFg, size: 16),
              SizedBox(width: 4),
              Text(
                '1d 22h remaining',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.statOrangeFg,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Action Buttons ---
  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.send_rounded, size: 16, color: AppColors.kWhite),
            label: const Text(
              'Submit My Response',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.kWhite,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryRed, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Save as Draft',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryRed,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Footer Disclaimer ---
  Widget _buildFooterDisclaimer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.lock_outline, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 9,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
              children: [
                const TextSpan(
                  text:
                      'Your response is confidential and will only be reviewed by Admin to mediate this cancellation. ',
                ),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Contact Support',
                      style: TextStyle(
                        fontSize: 9,
                        color: AppColors.primaryRed,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}