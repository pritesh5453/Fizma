import 'package:fizma/Screens/navbar/navbar.dart';
import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';

class PreviewTicketScreen extends StatelessWidget {
  final String ticketName;
  final String eventTitle;
  final String eventSubtitle;
  final String dateTimeLabel;
  final String venue;
  final int seats;
  final double totalPrice;
  final String validityLabel;
  final int maxTicketsPerUser;
  final String refundPolicy;
  final bool earlyBirdEnabled;
  final String offerStartLabel;
  final String offerEndLabel;
  final String discountLabel;
  final String visibility;

  const PreviewTicketScreen({
    super.key,
    this.ticketName = 'TechTalk 2025',
    this.eventTitle = 'Bhanjan Concert',
    this.eventSubtitle = 'Exploring the Future of AI and Innovation',
    this.dateTimeLabel = '24 Jan 2025, 10:00 AM',
    this.venue = 'Innovation Hub, Bengaluru',
    this.seats = 100,
    this.totalPrice = 499,
    this.validityLabel = '24 Jan 2025, 10:00 AM to 24 Jan 2025, 5:00 PM',
    this.maxTicketsPerUser = 5,
    this.refundPolicy = 'Non-refundable',
    this.earlyBirdEnabled = true,
    this.offerStartLabel = '01 Jan 2025, 10:00 AM',
    this.offerEndLabel = '15 Jan 2025, 11:59 PM',
    this.discountLabel = 'Discount: 20%',
    this.visibility = 'Public',
  });

  String get _priceLabel => '₹ ${totalPrice.toStringAsFixed(0)}';

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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _successCard(),
                      const SizedBox(height: 16),
                      _detailsCard(),
                      const SizedBox(height: 16),
                      _liveInfoBanner(),
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
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.kTextDark),
          ),
          const Text(
            'Preview Ticket',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.kTextDark,
            ),
          ),
          const Spacer(),
          _circleIconButton(Icons.notifications_none_rounded),
          const SizedBox(width: 8),
          _circleIconButton(Icons.search),
        ],
      ),
    );
  }

  Widget _circleIconButton(IconData icon) {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        color: AppColors.kChipBg,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 17, color: AppColors.kRed),
    );
  }

  // ---------- Success card with ticket preview ----------
  Widget _successCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle),
            child: const Icon(Icons.check, color: AppColors.kWhite, size: 24),
          ),
          const SizedBox(height: 12),
          const Text(
            'Ticket Created Successfully!',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.kTextDark),
          ),
          const SizedBox(height: 4),
          Text(
            'Your event ticket has been created.',
            style: TextStyle(fontSize: 12.5, color: AppColors.kTextDark.withOpacity(0.55)),
          ),
          const SizedBox(height: 18),
          _ticketPreviewMiniCard(),
        ],
      ),
    );
  }

  Widget _ticketPreviewMiniCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kPinkLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.confirmation_number_outlined, size: 13, color: AppColors.kRed),
                        SizedBox(width: 5),
                        Text(
                          'EVENT TICKET',
                          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.kRed, letterSpacing: 0.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      eventTitle,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.kTextDark),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      eventSubtitle,
                      style: TextStyle(fontSize: 11.5, color: AppColors.kTextDark.withOpacity(0.55)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.kWhite,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.kBorder, width: 1),
                ),
                child: CustomPaint(painter: _QrPlaceholderPainter()),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _iconTextRow(Icons.calendar_today_outlined, dateTimeLabel),
          const SizedBox(height: 5),
          _iconTextRow(Icons.location_on_outlined, venue),
          const SizedBox(height: 5),
          _iconTextRow(Icons.groups_outlined, '$seats Seats'),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.kBorder),
          const SizedBox(height: 10),
          Text(
            'Total Ticket Price',
            style: TextStyle(fontSize: 11.5, color: AppColors.kTextDark.withOpacity(0.55)),
          ),
          const SizedBox(height: 3),
          Text(
            _priceLabel,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.kRed),
          ),
        ],
      ),
    );
  }

  Widget _iconTextRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.kHint),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.kTextDark)),
        ),
      ],
    );
  }

  // ---------- Details card ----------
  Widget _detailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailRow(
            icon: Icons.confirmation_number,
            iconBg: const Color(0xFF4472D8),
            label: 'Ticket Name',
            value: ticketName,
          ),
          const SizedBox(height: 14),
          _detailRow(
            icon: Icons.groups,
            iconBg: AppColors.primaryRedDark,
            label: 'Total Seats',
            value: '$seats',
          ),
          const SizedBox(height: 14),
          _detailRow(
            icon: Icons.currency_rupee,
            iconBg: const Color(0xFF22C55E),
            label: 'Total Price',
            value: _priceLabel,
          ),
          const SizedBox(height: 18),
          const Divider(height: 1, color: AppColors.kBorder),
          const SizedBox(height: 14),

          const Text(
            'Ticket Validity',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.kTextDark),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.kHint),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  validityLabel,
                  style: const TextStyle(fontSize: 12.5, color: AppColors.kTextDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _plainRow('Max Tickets Per User', '$maxTicketsPerUser', icon: Icons.confirmation_number_outlined),
          const SizedBox(height: 14),
          _plainRow('Ticket Refund', refundPolicy, icon: Icons.replay_outlined),
          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(Icons.local_offer_outlined, size: 15, color: AppColors.kTextDark),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Early Bird Offer', style: TextStyle(fontSize: 13, color: AppColors.kTextDark)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1F8EA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  earlyBirdEnabled ? 'Enabled' : 'Disabled',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF22C55E)),
                ),
              ),
            ],
          ),
          if (earlyBirdEnabled) ...[
            const SizedBox(height: 10),
            _earlyBirdBox(),
          ],
          const SizedBox(height: 14),

          _plainRow('Ticket Visibility', visibility, icon: Icons.visibility_outlined),
        ],
      ),
    );
  }

  Widget _detailRow({
    required IconData icon,
    required Color iconBg,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, size: 15, color: AppColors.kWhite),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 13.5, color: AppColors.kTextDark)),
        ),
        Text(value, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.kTextDark)),
      ],
    );
  }

  Widget _plainRow(String label, String value, {required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.kTextDark),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.kTextDark)),
        ),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.kTextDark)),
      ],
    );
  }

  Widget _earlyBirdBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FBF3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCDEFDB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Offer Starts', style: TextStyle(fontSize: 10.5, color: AppColors.kTextDark.withOpacity(0.5))),
                    const SizedBox(height: 3),
                    Text(offerStartLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.kTextDark)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Offer Ends', style: TextStyle(fontSize: 10.5, color: AppColors.kTextDark.withOpacity(0.5))),
                    const SizedBox(height: 3),
                    Text(offerEndLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.kTextDark)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFCDEFDB)),
          const SizedBox(height: 8),
          Text(
            discountLabel,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF22C55E)),
          ),
        ],
      ),
    );
  }

  // ---------- "Live" info banner ----------
  Widget _liveInfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kPinkLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder, width: 1.1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 16, color: AppColors.kRed),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'This ticket is now live and visible to users. You can manage it from the My Tickets section.',
              style: TextStyle(fontSize: 12, color: AppColors.kTextDark.withOpacity(0.7), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Bottom buttons ----------
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Create Another Ticket',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.kRed),
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
                  Navigator.pushReplacement(context, 
                  MaterialPageRoute(builder: (context) => const EventsNavBar()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kRed,
                  foregroundColor: AppColors.kWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.kWhite),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lightweight painter that draws a QR-code-like pattern without
/// needing an external qr package or network image.
class _QrPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.kTextDark;
    const cells = 7;
    final cellSize = size.width / cells;
    final rnd = [
      1, 1, 1, 0, 1, 0, 1,
      1, 0, 1, 0, 1, 0, 1,
      1, 1, 1, 0, 1, 1, 0,
      0, 0, 1, 1, 0, 1, 1,
      1, 0, 1, 0, 1, 0, 1,
      0, 1, 0, 1, 1, 0, 1,
      1, 0, 1, 1, 0, 1, 1,
    ];
    for (int row = 0; row < cells; row++) {
      for (int col = 0; col < cells; col++) {
        if (rnd[row * cells + col] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(col * cellSize, row * cellSize, cellSize, cellSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}