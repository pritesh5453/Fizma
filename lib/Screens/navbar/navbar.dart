import 'package:fizmaa/Screens/Profile/profile_screen.dart';
import 'package:fizmaa/Screens/add_event/add_event_screen.dart';
import 'package:fizmaa/Screens/events/events.dart';
import 'package:fizmaa/Screens/home/homescreen.dart';
import 'package:fizmaa/Screens/revenue/revenue_screen.dart';
import 'package:fizmaa/utils/app_preference.dart';
import 'package:flutter/material.dart';

class EventsNavBar extends StatefulWidget {
  final int initialIndex;
  final int? organiserId;

  const EventsNavBar({
    super.key,
    this.initialIndex = 0,
    this.organiserId,
  });

  @override
  State<EventsNavBar> createState() => _EventsNavBarState();
}

class _EventsNavBarState extends State<EventsNavBar> {
  late int _selectedIndex;
  int? _organiserId;
  bool _isLoading = true;

  static const Color _navBg = Color(0xFF1E1E1E);
  static const Color _selectedColor = Colors.white;
  static const Color _unselectedColor = Colors.white54;
  static const Color _fabColor = Color(0xFFE94873);

  List<Widget> get _screens => [
        const HomeScreen(),
        MyEventsScreen(),
        const AddEventScreen(),
        const RevenueFinanceScreen(), // Revenue
        const ProfileManagementScreen(), // More
      ];

  static const List<_NavItemData> _navItems = [
    _NavItemData(
      selectedIcon: Icons.home_rounded,
      unselectedIcon: Icons.home_outlined,
      label: 'Home',
    ),
    _NavItemData(
      selectedIcon: Icons.event_rounded,
      unselectedIcon: Icons.event_outlined,
      label: 'Events',
    ),
    _NavItemData(
      selectedIcon: Icons.currency_rupee_rounded,
      unselectedIcon: Icons.currency_rupee_rounded,
      label: 'Revenue',
    ),
    _NavItemData(
      selectedIcon: Icons.grid_view_rounded,
      unselectedIcon: Icons.grid_view_outlined,
      label: 'More',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _loadOrganiserId();
  }

  Future<void> _loadOrganiserId() async {
    if (widget.organiserId != null) {
      setState(() {
        _organiserId = widget.organiserId;
        _isLoading = false;
      });
      return;
    }
    final id = await AppPreferences.getOrganiserId();
    setState(() {
      _organiserId = id;
      _isLoading = false;
    });
  }

  int _screenIndexFor(int navItemIndex) {
    switch (navItemIndex) {
      case 0:
        return 0; // Home
      case 1:
        return 1; // Events
      case 2:
        return 3; // Revenue
      case 3:
        return 4; // More/Profile
      default:
        return 0;
    }
  }

  void _onItemTapped(int navItemIndex) {
    setState(() {
      _selectedIndex = _screenIndexFor(navItemIndex);
    });
  }

  void _onAddTapped() {
    setState(() {
      _selectedIndex = 2; // AddEventScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Extend body only when navbar is shown
      extendBody: _selectedIndex != 2,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _screens[_selectedIndex],
      // ✅ Hide navbar when on AddEventScreen (index 2)
      bottomNavigationBar: _isLoading || _selectedIndex == 2
          ? null
          : _buildFloatingNavBar(),
    );
  }

  Widget _buildFloatingNavBar() {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      child: SizedBox(
        height: 90,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _NavBarShapePainter(
                  color: _navBg,
                  barHeight: 62,
                  bumpRadius: 40,
                  bumpProtrusion: 20,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 62,
              child: Row(
                children: [
                  _buildNavItem(0),
                  _buildNavItem(1),
                  const SizedBox(width: 64),
                  _buildNavItem(2),
                  _buildNavItem(3),
                ],
              ),
            ),
            Positioned(
              top: 15,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _onAddTapped,
                  child: Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: _fabColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _fabColor.withOpacity(0.45),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int navItemIndex) {
    final item = _navItems[navItemIndex];
    final selected = _selectedIndex == _screenIndexFor(navItemIndex);

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: () => _onItemTapped(navItemIndex),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? item.selectedIcon : item.unselectedIcon,
              size: 22,
              color: selected ? _selectedColor : _unselectedColor,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? _selectedColor : _unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarShapePainter extends CustomPainter {
  final Color color;
  final double barHeight;
  final double bumpRadius;
  final double bumpProtrusion;

  _NavBarShapePainter({
    required this.color,
    required this.barHeight,
    required this.bumpRadius,
    required this.bumpProtrusion,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.22)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final path = _buildPath(size);

    canvas.drawPath(path.shift(const Offset(0, 4)), shadowPaint);
    canvas.drawPath(path, paint);
  }

  Path _buildPath(Size size) {
    final double barTop = size.height - barHeight;
    final double barRadius = barHeight / 2;
    final double centerX = size.width / 2;

    final barPath = Path()
      ..addRRect(
        RRect.fromLTRBR(0, barTop, size.width, size.height, Radius.circular(barRadius)),
      );

    final double bumpCenterY = barTop - bumpProtrusion + bumpRadius;
    final bumpPath = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(centerX, bumpCenterY), radius: bumpRadius),
      );

    return Path.combine(PathOperation.union, barPath, bumpPath);
  }

  @override
  bool shouldRepaint(covariant _NavBarShapePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.barHeight != barHeight ||
      oldDelegate.bumpRadius != bumpRadius ||
      oldDelegate.bumpProtrusion != bumpProtrusion;
}

class _NavItemData {
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final String label;

  const _NavItemData({
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.label,
  });
}