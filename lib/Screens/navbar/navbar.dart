import 'package:fizma/Screens/Profile/profile_screen.dart';
import 'package:fizma/Screens/add_event/add_event_screen.dart';
import 'package:fizma/Screens/events/events.dart';
import 'package:fizma/Screens/home/homescreen.dart';
import 'package:flutter/material.dart';

/// Bottom navigation bar with 4 tabs: Home, Events, Add Event, Profile.
///
/// Replace the placeholder `Text(...)` screens below with your real screen
/// widgets (same pattern as the main `Navbar`) once they're ready.
class EventsNavBar extends StatefulWidget {
  const EventsNavBar({super.key});

  @override
  State<EventsNavBar> createState() => _EventsNavBarState();
}

class _EventsNavBarState extends State<EventsNavBar> {
  int _selectedIndex = 0;

  static const Color _selectedColor = Color(0xFFE94873);
  static const Color _unselectedColor = Colors.black54;

  // TODO: swap these placeholders for the real screens.
  final _screens = const [
    HomeScreen(),
    LiveEventsScreen(),
    AddEventScreen(),
    ProfileScreen(),
  ];

  static const List<_NavItemData> _navItems = [
    _NavItemData(
      selectedIcon: Icons.home_rounded,
      unselectedIcon: Icons.home_outlined,
      label: 'Home',
    ),
    _NavItemData(
      selectedIcon: Icons.bookmark_rounded,
      unselectedIcon: Icons.bookmark_border_rounded,
      label: 'Events',
    ),
    _NavItemData(
      selectedIcon: Icons.edit_note_rounded,
      unselectedIcon: Icons.edit_note_rounded,
      label: 'Add Event',
    ),
    _NavItemData(
      selectedIcon: Icons.person_rounded,
      unselectedIcon: Icons.person_outline_rounded,
      label: 'Profile',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final selected = _selectedIndex == index;
              return Expanded(
                child: InkWell(
                  onTap: () => _onItemTapped(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        selected ? item.selectedIcon : item.unselectedIcon,
                        size: 24,
                        color: selected ? _selectedColor : _unselectedColor,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w400,
                          color: selected ? _selectedColor : _unselectedColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
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