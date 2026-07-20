import 'package:fizma/Screens/Payment_Screens/Payment_screen.dart';
import 'package:fizma/Screens/add_event/add_event_screen.dart';
import 'package:fizma/Screens/home/QuickActionCard.dart';
import 'package:fizma/Screens/home/components/recentevent_card.dart';
import 'package:fizma/Screens/home/components/stats_card.dart';
import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';

/// Host "My Events" home / dashboard screen.
///
/// The bottom nav bar is a fully separate widget class
/// (see widgets/custom_bottom_nav_bar.dart) wired in here via
/// `bottomNavigationBar`.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const _HeaderSection(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Expanded(
                        child: StatCard(
                          icon: Icons.bolt,
                          bg: AppColors.statPurpleBg,
                          fg: AppColors.statPurpleFg,
                          value: '12',
                          label: 'Active Events',
                          subtext: '+3 this week',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          icon: Icons.confirmation_number_outlined,
                          bg: AppColors.statOrangeBg,
                          fg: AppColors.statOrangeFg,
                          value: '3,847',
                          label: 'Tickets Sold',
                          subtext: '+284 today',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Expanded(
                        child: StatCard(
                          icon: Icons.currency_rupee,
                          bg: AppColors.statGreenBg,
                          fg: AppColors.statGreenFg,
                          value: '₹2,84,500',
                          label: 'Revenue',
                          subtext: '+18% this week',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          icon: Icons.event_available_outlined,
                          bg: AppColors.statPinkBg,
                          fg: AppColors.statPinkFg,
                          value: '8',
                          label: 'Upcoming',
                          subtext: 'Next: 3 days',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),

                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: QuickActionCard(
                          icon: Icons.add,
                          iconBg: AppColors.actionRedBg,
                          iconFg: AppColors.primaryRed,
                          label: 'New Event',
                          onTap: () {
                            Navigator.push(context, 
                            MaterialPageRoute(builder: (context) => AddEventScreen()));
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: QuickActionCard(
                          icon: Icons.attach_money_rounded,
                          iconBg: AppColors.actionGreenBg,
                          iconFg: AppColors.statGreenFg,
                          label: 'Payment',
                          onTap: () {
                            Navigator.push(context, 
                            MaterialPageRoute(builder: (context) => PaymentScreen()));
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: QuickActionCard(
                          icon: Icons.description_outlined,
                          iconBg: AppColors.actionOrangeBg,
                          iconFg: AppColors.statOrangeFg,
                          label: 'Reports',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const _PromoBanner(),
                  const SizedBox(height: 26),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Events',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryRed,
                            ),
                          ),
                          Icon(Icons.chevron_right, size: 16, color: AppColors.primaryRed),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        height: 6,
                        width: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Updated just now',
                        style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  RecentEventCard(
                    title: 'Bhajan Concert',
                    tag: 'Music',
                    isLive: true,
                    location: 'Mumbai, MH',
                    date: 'Jan 15, 2025',
                    sold: '624',
                    revenue: '₹1,24,800',
                    percentSold: 0.78,
                    thumbGradient: const [Color(0xFF7B1E3A), Color(0xFFB3182F)],
                    thumbIcon: Icons.mic_external_on_outlined,
                  ),
                  const SizedBox(height: 12),
                  RecentEventCard(
                    title: 'Nashik Vine Festival',
                    tag: 'Music',
                    isLive: false,
                    location: 'Nashik, MH',
                    date: 'Jan 18, 2025',
                    sold: '624',
                    revenue: '₹1,24,800',
                    percentSold: 0.65,
                    thumbGradient: const [Color(0xFF8B3A5C), Color(0xFFE0577F)],
                    thumbIcon: Icons.wine_bar_outlined,
                  ),
                  const SizedBox(height: 12),
                  RecentEventCard(
                    title: 'Bhajan Concert',
                    tag: 'Music',
                    isLive: true,
                    location: 'Mumbai, MH',
                    date: 'Jan 15, 2025',
                    sold: '624',
                    revenue: '₹1,24,800',
                    percentSold: 0.78,
                    thumbGradient: const [Color(0xFF7B1E3A), Color(0xFFB3182F)],
                    thumbIcon: Icons.mic_external_on_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    
    );
  }
}

// ---------------------------------------------------------------------------
// Header (gradient) section
// ---------------------------------------------------------------------------

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFFFF221A),
            Color(0xFFBE130D),
            Color(0xFF670606),
          ],
        ),
        // borderRadius: BorderRadius.only(
        //   bottomLeft: Radius.circular(26),
        //   bottomRight: Radius.circular(26),
        // ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
        child: Stack(
          children: [
            /// White diagonal highlight
            Positioned.fill(
              child: CustomPaint(
                painter: _WhitePainter(),
              ),
            ),

            /// Dark top shape
            Positioned.fill(
              child: CustomPaint(
                painter: _DarkPainter(),
              ),
            ),

            /// Header Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 26),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 18),

                        Text(
                          'Hello Pritesh, 👋',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'My Events',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top : 30),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.12),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withOpacity(.25),
                            ),
                          ),
                          child: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            height: 8,
                            width: 8,
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  Padding(
                    padding: const EdgeInsets.only(top : 30),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Image.network(
                              "https://i.pravatar.cc/150?img=5",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -1,
                          right: -1,
                          child: Container(
                            width: 13,
                            height: 13,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// White Cross Shape
class _WhitePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(.08);

    final path = Path();

    path.moveTo(0, 15);
    path.lineTo(size.width * .55, 70);
    path.lineTo(size.width, 38);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Dark Shape
class _DarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(.12);

    final path = Path();

    path.moveTo(size.width * .22, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, 60);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
// ---------------------------------------------------------------------------
// Promo banner ("You're doing great!")
// ---------------------------------------------------------------------------

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(18),
  gradient: const LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    transform: GradientRotation(210.35 * 3.1415926535 / 180),
    colors: [
      Color(0xFFFE4149),
      Color(0xFFFE4958),
      Color(0xFFFE4958),
      Color(0xFFFF2722),
    ],
    stops: [
      0.3908,
      0.4343,
      0.5212,
      0.6557,
    ],
  ),
),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "You're doing great! 🎉",
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                SizedBox(height: 3),
                Text(
                  '3 events this week • 96% tickets sold',
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryRed,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              'View Analytics',
              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}