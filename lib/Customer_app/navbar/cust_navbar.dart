import 'package:fizmaa/Customer_app/event_ticket/evnt_ticket_screen/event_ticket_screen.dart';
import 'package:fizmaa/Customer_app/homescreen.dart';
import 'package:flutter/material.dart';

class CustomerNavBar extends StatefulWidget {
  final int initialIndex;

  const CustomerNavBar({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<CustomerNavBar> createState() => _CustomerNavBarState();
}

class _CustomerNavBarState extends State<CustomerNavBar> {
  late int _selectedIndex;

  static const Color _selectedBg = Color(0xFFFF2B4A);
  static const Color _selectedColor = Color(0xFFFF2B4A);
  static const Color _unselectedColor = Color(0xFF6B6B6B);
  static const Color _navBorder = Color(0xFFDCE6F5);

  // ✅ Same flow pattern as before: a list of screens driven by _selectedIndex
  List<Widget> get _screens => const [
        EventHomeScreen(),
        _PlaceholderScreen(title: 'Categories'),
        EventTicketsScreen(),
        _PlaceholderScreen(title: 'Live Events'),
        _PlaceholderScreen(title: 'AI Magic'),
      ];

  static const List<_NavItemData> _navItems = [
    _NavItemData(
      icon: Icons.home_filled,
      label: 'Home',
    ),
    _NavItemData(
      icon: Icons.grid_view_rounded,
      label: 'Categories',
    ),
    _NavItemData(
      icon: Icons.confirmation_num_outlined,
      label: 'Tickets',
    ),
    _NavItemData(
      icon: Icons.location_on_outlined,
      label: 'Live Events',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
      child: Container(
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _navBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            for (int i = 0; i < _navItems.length; i++)
              Expanded(child: _buildNavItem(i)),
            _buildAiMagicItem(4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = _navItems[index];
    final selected = _selectedIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: selected ? _selectedBg : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item.icon,
              size: 18,
              color: selected ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              color: selected ? _selectedColor : _unselectedColor,
            ),
          ),
        ],
      ),
    );
  }

  // Last item: colorful gradient "AI Magic" sparkle icon, no label — matches the reference image.
  Widget _buildAiMagicItem(int index) {
    final selected = _selectedIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _onItemTapped(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFF6D5DF6),
              Color(0xFFB44BF7),
              Color(0xFFE94873),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Icon(
            Icons.auto_awesome,
            size: selected ? 30 : 26,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;

  const _NavItemData({
    required this.icon,
    required this.label,
  });
}

// Simple placeholder so this file compiles standalone.
// Swap this out for your real screens (HomeScreen, CategoriesScreen, etc.)
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}