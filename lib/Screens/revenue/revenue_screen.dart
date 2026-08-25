import 'package:flutter/material.dart';

class RevenueFinanceScreen extends StatefulWidget {
  const RevenueFinanceScreen({super.key});

  @override
  State<RevenueFinanceScreen> createState() => _RevenueFinanceScreenState();
}

class _RevenueFinanceScreenState extends State<RevenueFinanceScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Revenue & Finance',
              style: TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Track your revenue easily',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFFEF4444),
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Custom Segmented Tab Controller Switcher
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFF3F4F6)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTabIndex = 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == 0
                                ? const Color(0xFFEF4444)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Overview',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _selectedTabIndex == 0
                                  ? Colors.white
                                  : const Color(0xFF4B5563),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTabIndex = 1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == 1
                                ? const Color(0xFFEF4444)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Transactions',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _selectedTabIndex == 1
                                  ? Colors.white
                                  : const Color(0xFF4B5563),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Tab Body View
            Expanded(
              child: _selectedTabIndex == 0
                  ? const RevenueOverviewTab()
                  : const RevenueTransactionsTab(),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 1. OVERVIEW TAB
// ==========================================
class RevenueOverviewTab extends StatelessWidget {
  const RevenueOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Grid Cards (2x2)
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                iconBg: const Color(0xFFFEE2E2),
                icon: const Text('\$', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 16)),
                value: '₹495k',
                label: 'Gross Revenue',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                iconBg: const Color(0xFFDCFCE7),
                icon: const Icon(Icons.trending_up, color: Color(0xFF16A34A), size: 18),
                value: '₹430k',
                label: 'Net Revenue',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                iconBg: const Color(0xFFEEF2FF),
                icon: const Icon(Icons.confirmation_number_outlined, color: Color(0xFF6366F1), size: 18),
                value: '3,420',
                label: 'Tickets Sold',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                iconBg: const Color(0xFFFEF3C7),
                icon: const Icon(Icons.north_east, color: Color(0xFFD97706), size: 18),
                value: '₹145',
                label: 'Avg. Ticket Value',
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Revenue Trend Chart Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Revenue Trend',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Last 6 months',
                style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                width: double.infinity,
                child: CustomPaint(
                  painter: _RevenueChartPainter(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Sales by Tier Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sales by Tier',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: CustomPaint(
                      painter: _DonutChartPainter(),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTierLegend(
                          color: const Color(0xFFEF4444),
                          label: 'General',
                          percentage: '62%',
                        ),
                        const SizedBox(height: 10),
                        _buildTierLegend(
                          color: const Color(0xFFFCA5A5),
                          label: 'Pro / Classic',
                          percentage: '24%',
                        ),
                        const SizedBox(height: 10),
                        _buildTierLegend(
                          color: const Color(0xFFFEE2E2),
                          label: 'VIP / Premium',
                          percentage: '14%',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMetricCard({
    required Color iconBg,
    required Widget icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: icon,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierLegend({
    required Color color,
    required String label,
    required String percentage,
  }) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4B5563),
            ),
          ),
        ),
        Text(
          percentage,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }
}

// Custom Painter for Revenue Line Chart
class _RevenueChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = const Color(0xFFEF4444)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final Paint pointPaint = Paint()
      ..color = const Color(0xFFEF4444)
      ..style = PaintingStyle.fill;

    final Paint gridPaint = Paint()
      ..color = const Color(0xFFF3F4F6)
      ..strokeWidth = 1.0;

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Draw horizontal grid lines & labels
    const yLabels = ['\$180k', '\$108k', '\$35k'];
    final yPositions = [0.1, 0.5, 0.9];

    for (int i = 0; i < yLabels.length; i++) {
      final y = size.height * yPositions[i];
      canvas.drawLine(Offset(35, y), Offset(size.width, y), gridPaint);

      textPainter.text = TextSpan(
        text: yLabels[i],
        style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF)),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - 5));
    }

    // Chart Points
    final xMonths = ['Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'];
    final double stepX = (size.width - 40) / (xMonths.length - 1);
    final points = <Offset>[
      Offset(40 + 0 * stepX, size.height * 0.85),
      Offset(40 + 1 * stepX, size.height * 0.80),
      Offset(40 + 2 * stepX, size.height * 0.88),
      Offset(40 + 3 * stepX, size.height * 0.65),
      Offset(40 + 4 * stepX, size.height * 0.20),
      Offset(40 + 5 * stepX, size.height * 0.82),
    ];

    // Draw Fill gradient under chart line
    final Path fillPath = Path()..moveTo(points.first.dx, size.height * 0.95);
    for (var point in points) {
      fillPath.lineTo(point.dx, point.dy);
    }
    fillPath.lineTo(points.last.dx, size.height * 0.95);
    fillPath.close();

    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFEF4444).withOpacity(0.2),
          const Color(0xFFEF4444).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Draw Line
    final Path path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    // Draw Dots & Month Labels
    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 3, pointPaint);

      textPainter.text = TextSpan(
        text: xMonths[i],
        style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF)),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(points[i].dx - (textPainter.width / 2), size.height - 10),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Painter for Donut Chart
class _DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    // Segment 1 (General - 62%)
    paint.color = const Color(0xFFEF4444);
    canvas.drawArc(rect, -1.57, 3.89, false, paint);

    // Segment 2 (Pro - 24%)
    paint.color = const Color(0xFFFCA5A5);
    canvas.drawArc(rect, 2.38, 1.50, false, paint);

    // Segment 3 (VIP - 14%)
    paint.color = const Color(0xFFFEE2E2);
    canvas.drawArc(rect, 3.94, 0.88, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// 2. TRANSACTIONS TAB
// ==========================================
class RevenueTransactionsTab extends StatelessWidget {
  const RevenueTransactionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildTransactionCard(
          name: 'Megan Taylor',
          event: 'Web Summit 2025 · Pro',
          txnId: 'txn001 · 2025-08-01',
          amount: '₹199',
          status: 'Paid',
          statusColor: const Color(0xFF10B981),
          statusBg: const Color(0xFFECFDF5),
        ),
        const SizedBox(height: 10),
        _buildTransactionCard(
          name: 'Arjun Sharma',
          event: 'Jazz Under the Stars · Premium',
          txnId: 'txn002 · 2025-08-01',
          amount: '₹120',
          status: 'Paid',
          statusColor: const Color(0xFF10B981),
          statusBg: const Color(0xFFECFDF5),
        ),
        const SizedBox(height: 10),
        _buildTransactionCard(
          name: 'Lucia Fernandez',
          event: 'Web Summit 2025 · VIP',
          txnId: 'txn003 · 2025-07-31',
          amount: '₹499',
          status: 'Paid',
          statusColor: const Color(0xFF10B981),
          statusBg: const Color(0xFFECFDF5),
        ),
        const SizedBox(height: 10),
        _buildTransactionCard(
          name: 'Daniel Kim',
          event: 'Founders Dinner · Table for 2',
          txnId: 'txn004 · 2025-07-31',
          amount: '\$200',
          status: 'Paid',
          statusColor: const Color(0xFF10B981),
          statusBg: const Color(0xFFECFDF5),
        ),
        const SizedBox(height: 10),
        _buildTransactionCard(
          name: 'Nadia Osei',
          event: 'Web Summit 2025 · General',
          txnId: 'txn005 · 2025-07-30',
          amount: '₹99',
          status: 'Refunded',
          statusColor: const Color(0xFF6366F1),
          statusBg: const Color(0xFFEEF2FF),
        ),
        const SizedBox(height: 10),
        _buildTransactionCard(
          name: 'Tom Whitfield',
          event: 'Jazz Under the Stars · Standard',
          txnId: 'txn006 · 2025-07-29',
          amount: '₹65',
          status: 'Paid',
          statusColor: const Color(0xFF10B981),
          statusBg: const Color(0xFFECFDF5),
        ),
        const SizedBox(height: 10),
        _buildTransactionCard(
          name: 'Yuki Tanaka',
          event: 'Web Summit 2025 · Pro',
          txnId: 'txn007 · 2025-07-29',
          amount: '₹199',
          status: 'Pending',
          statusColor: const Color(0xFFD97706),
          statusBg: const Color(0xFFFEF3C7),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTransactionCard({
    required String name,
    required String event,
    required String txnId,
    required String amount,
    required String status,
    required Color statusColor,
    required Color statusBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  event,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  txnId,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}