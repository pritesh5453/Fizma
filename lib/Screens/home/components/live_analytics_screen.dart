import 'dart:math' as math;
import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';

class LiveAnalyticsScreen extends StatelessWidget {
  const LiveAnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppColors.screenGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.kTextDark, size: 18),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bhanjan Consert',
                style: TextStyle(
                  color: AppColors.kTextDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: const [
                  CircleAvatar(radius: 3, backgroundColor: Colors.red),
                  SizedBox(width: 4),
                  Text(
                    'Live Analytics',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              height: 38,
              width: 38,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEAEA),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.notifications_none_outlined, color: AppColors.kRed, size: 20),
                onPressed: () {},
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              // 4 Top Cards (Exact Match)
              _buildTopMetricsGrid(),
              const SizedBox(height: 16),

              // Revenue Trend
              _buildRevenueTrendCard(),
              const SizedBox(height: 16),

              // Ticket Breakdown
              _buildTicketBreakdownCard(),
              const SizedBox(height: 16),

              // Ticket Performance
              _buildTicketPerformanceCard(),
              const SizedBox(height: 16),

              // Hourly Check-ins
              _buildHourlyCheckInsCard(),
              const SizedBox(height: 16),

              // Export Report
              _buildExportReportCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- Exact Match Top 4 Cards Grid ---
  Widget _buildTopMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Card 1: Tickets Sold
        _metricCard(
          icon: Icons.confirmation_number_outlined,
          iconBgColor: const Color(0xFF6C5CE7),
          value: "624",
          subValue: "/ 800 cap",
          label: "Tickets Sold",
          percentage: "+18%",
          borderColor: const Color(0xFFD6D1FA),
          bgColor: const Color(0xFFF6F5FF),
          glowColor: const Color(0xFF6C5CE7).withOpacity(0.08),
        ),
        // Card 2: Total Revenue
        _metricCard(
          icon: Icons.attach_money_rounded,
          iconBgColor: const Color(0xFF10B981),
          value: "₹1,24,800",
          subValue: "",
          label: "Total Revenue",
          percentage: "+23%",
          borderColor: const Color(0xFFA7F3D0),
          bgColor: const Color(0xFFECFDF5),
          glowColor: const Color(0xFF10B981).withOpacity(0.08),
        ),
        // Card 3: Checked In
        _metricCard(
          icon: Icons.access_time_filled_rounded,
          iconBgColor: const Color(0xFFF97316),
          value: "387",
          subValue: "/ 624 sold",
          label: "Checked In",
          percentage: "+62%",
          borderColor: const Color(0xFFFDE68A),
          bgColor: const Color(0xFFFFFBEB),
          glowColor: const Color(0xFFF97316).withOpacity(0.08),
        ),
        // Card 4: Page Views
        _metricCard(
          icon: Icons.visibility_rounded,
          iconBgColor: const Color(0xFFEC4899),
          value: "12,840",
          subValue: "",
          label: "Page Views",
          percentage: "+41%",
          borderColor: const Color(0xFFFBCFE8),
          bgColor: const Color(0xFFFDF2F8),
          glowColor: const Color(0xFFEC4899).withOpacity(0.08),
        ),
      ],
    );
  }

  Widget _metricCard({
    required IconData icon,
    required Color iconBgColor,
    required String value,
    required String subValue,
    required String label,
    required String percentage,
    required Color borderColor,
    required Color bgColor,
    required Color glowColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: glowColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Icon & Percentage Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  percentage,
                  style: const TextStyle(
                    color: Color(0xFF15803D),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          // Bottom Content: Number, SubText & Label
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.kTextDark,
                  height: 1.1,
                ),
              ),
              if (subValue.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 1.0),
                  child: Text(
                    subValue,
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.textSecondary.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const SizedBox(height: 3),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Revenue Trend Card ---
  Widget _buildRevenueTrendCard() {
    final List<Map<String, dynamic>> barData = [
      {"day": "Mon", "height": 30.0, "type": "prev"},
      {"day": "Tue", "height": 40.0, "type": "prev"},
      {"day": "Wed", "height": 50.0, "type": "prev"},
      {"day": "Thu", "height": 35.0, "type": "prev"},
      {"day": "Fri", "height": 65.0, "type": "prev"},
      {"day": "Sat", "height": 90.0, "type": "peak"},
      {"day": "Sun", "height": 80.0, "type": "today"},
    ];

    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Revenue Trend",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.kTextDark,
                    ),
                  ),
                  Text(
                    "Last 7 days",
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const Text(
                "₹1,68,700",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Bar Chart
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
             crossAxisAlignment: CrossAxisAlignment.end,
              children: barData.map((data) {
                Color barColor = const Color(0xFFE2E8F0);
                if (data["type"] == "peak") {
                  barColor = const Color(0xFF6366F1);
                } else if (data["type"] == "today") {
                  barColor = AppColors.kRed;
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 30,
                      height: data["height"],
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data["day"],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: data["type"] != "prev" ? FontWeight.bold : FontWeight.normal,
                        color: data["type"] == "today"
                            ? AppColors.kRed
                            : (data["type"] == "peak" ? const Color(0xFF6366F1) : AppColors.textSecondary),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Legend
          Row(
            children: [
              _legendDot(AppColors.kRed, "Today"),
              const SizedBox(width: 12),
              _legendDot(const Color(0xFF6366F1), "Peak day"),
              const SizedBox(width: 12),
              _legendDot(const Color(0xFFE2E8F0), "Previous"),
            ],
          ),
        ],
      ),
    );
  }

  // --- Ticket Breakdown Card ---
  Widget _buildTicketBreakdownCard() {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ticket Breakdown",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.kTextDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Donut Chart
              SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(110, 110),
                      painter: DonutChartPainter(),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "624",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.kTextDark,
                          ),
                        ),
                        Text(
                          "tickets",
                          style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(width: 20),

              // Breakdown List
              Expanded(
                child: Column(
                  children: [
                    _breakdownRow(
                      color: const Color(0xFF6366F1),
                      title: "General",
                      subTitle: "380 tickets",
                      percentage: "61%",
                      price: "₹57,000",
                      priceColor: const Color(0xFF6366F1),
                    ),
                    const SizedBox(height: 12),
                    _breakdownRow(
                      color: const Color(0xFFEAB308),
                      title: "VIP",
                      subTitle: "180 tickets",
                      percentage: "29%",
                      price: "₹54,000",
                      priceColor: const Color(0xFFEAB308),
                    ),
                    const SizedBox(height: 12),
                    _breakdownRow(
                      color: AppColors.kRed,
                      title: "Platinum",
                      subTitle: "64 tickets",
                      percentage: "10%",
                      price: "₹13,800",
                      priceColor: AppColors.kRed,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _breakdownRow({
    required Color color,
    required String title,
    required String subTitle,
    required String percentage,
    required String price,
    required Color priceColor,
  }) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kTextDark,
                ),
              ),
              Text(
                subTitle,
                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              percentage,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.kTextDark,
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: priceColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- Ticket Performance Card ---
  Widget _buildTicketPerformanceCard() {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ticket Performance",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.kTextDark,
            ),
          ),
          const SizedBox(height: 16),
          _performanceProgressRow(
            title: "General",
            ratio: "380/500",
            percentage: "76%",
            color: const Color(0xFF6366F1),
            value: 0.76,
          ),
          const SizedBox(height: 14),
          _performanceProgressRow(
            title: "VIP",
            ratio: "180/200",
            percentage: "90%",
            color: const Color(0xFFF97316),
            value: 0.90,
          ),
          const SizedBox(height: 14),
          _performanceProgressRow(
            title: "Platinum",
            ratio: "64/100",
            percentage: "64%",
            color: AppColors.kRed,
            value: 0.64,
          ),
        ],
      ),
    );
  }

  Widget _performanceProgressRow({
    required String title,
    required String ratio,
    required String percentage,
    required Color color,
    required double value,
  }) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(radius: 4, backgroundColor: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.kTextDark,
              ),
            ),
            const Spacer(),
            Text(
              ratio,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                percentage,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: const Color(0xFFF1F5F9),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  // --- Hourly Check-ins Card ---
  Widget _buildHourlyCheckInsCard() {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Hourly Check-ins",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.kTextDark,
                    ),
                  ),
                  Text(
                    "Peak: 9 PM - 198 scans",
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEAEA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    CircleAvatar(radius: 3, backgroundColor: AppColors.kRed),
                    SizedBox(width: 4),
                    Text(
                      "Live",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kRed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Area Chart
          SizedBox(
            height: 110,
            width: double.infinity,
            child: Stack(
              children: [
                CustomPaint(
                  size: const Size(double.infinity, 90),
                  painter: AreaChartPainter(),
                ),
                Positioned(
                  top: 18,
                  left: 135,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.kRed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Peak 9 PM",
                      style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("6PM", style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
              Text("8PM", style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
              Text("10PM", style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
              Text("12AM", style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
              Text("2AM", style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
            ],
          )
        ],
      ),
    );
  }

  // --- Export Report Card ---
  Widget _buildExportReportCard() {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Export Report",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.kTextDark,
            ),
          ),
          const Text(
            "Download or share this event's analytics",
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _exportOptionButton(icon: Icons.picture_as_pdf_outlined, label: "PDF", color: AppColors.kRed),
              const SizedBox(width: 8),
              _exportOptionButton(icon: Icons.table_chart_outlined, label: "CSV", color: const Color(0xFF10B981)),
              const SizedBox(width: 8),
              _exportOptionButton(icon: Icons.share_outlined, label: "Share", color: const Color(0xFF6366F1)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kRed,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
              label: const Text(
                "Download Full Report",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _exportOptionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.kRed.withOpacity(0.3)),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.kTextDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// --- Custom Donut Chart Painter ---
class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 12.0;
    Rect rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Segment 1: General (Blue)
    paint.color = const Color(0xFF6366F1);
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * 0.61, false, paint);

    // Segment 2: VIP (Yellow)
    paint.color = const Color(0xFFEAB308);
    canvas.drawArc(rect, (-math.pi / 2) + (2 * math.pi * 0.61), 2 * math.pi * 0.29, false, paint);

    // Segment 3: Platinum (Red)
    paint.color = AppColors.kRed;
    canvas.drawArc(rect, (-math.pi / 2) + (2 * math.pi * 0.90), 2 * math.pi * 0.10, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- Custom Area Line Chart Painter ---
class AreaChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(0, size.height - 10);
    path.cubicTo(
      size.width * 0.25, size.height - 15,
      size.width * 0.35, 10,
      size.width * 0.5, 20,
    );
    path.cubicTo(
      size.width * 0.65, 30,
      size.width * 0.8, size.height - 20,
      size.width, size.height - 10,
    );

    Path fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.kRed.withOpacity(0.35),
          AppColors.kRed.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    Paint linePaint = Paint()
      ..color = AppColors.kRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(path, linePaint);

    Paint dotPaint = Paint()..color = AppColors.kRed;
    canvas.drawCircle(Offset(size.width * 0.5, 20), 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}