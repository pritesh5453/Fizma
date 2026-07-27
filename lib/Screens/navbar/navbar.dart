import 'package:fizma/Screens/Profile/profile_screen.dart';
import 'package:fizma/Screens/add_event/add_event_screen.dart';
import 'package:fizma/Screens/events/events.dart';
import 'package:fizma/Screens/home/homescreen.dart';
import 'package:fizma/utils/app_preference.dart';
import 'package:flutter/material.dart';

class EventsNavBar extends StatefulWidget {
  final int initialIndex;
  final int? organiserId; // optional now

  const EventsNavBar({
    super.key,
    this.initialIndex = 0,
    this.organiserId, // no 'required'
  });

  @override
  State<EventsNavBar> createState() => _EventsNavBarState();
}

class _EventsNavBarState extends State<EventsNavBar> {
  late int _selectedIndex;
  int? _organiserId;
  bool _isLoading = true;

  static const Color _selectedColor = Color(0xFFE94873);
  static const Color _unselectedColor = Colors.black54;

  // Dynamic screen list – uses loaded _organiserId
  List<Widget> get _screens => [
        const HomeScreen(),
        LiveEventsScreen(organiserId: _organiserId ?? 0), // fallback (shouldn't happen after load)
        const AddEventScreen(),
        const ProfileScreen(),
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

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _loadOrganiserId();
  }

  Future<void> _loadOrganiserId() async {
    // If already passed, use it directly
    if (widget.organiserId != null) {
      setState(() {
        _organiserId = widget.organiserId;
        _isLoading = false;
      });
      return;
    }

    // Otherwise fetch from SharedPreferences
    final id = await AppPreferences.getOrganiserId();
    setState(() {
      _organiserId = id;
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _screens[_selectedIndex],
      bottomNavigationBar: _isLoading
          ? null // hide bottom bar while loading
          : _buildBottomNav(),
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
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
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