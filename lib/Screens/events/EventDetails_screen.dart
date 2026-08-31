import 'package:fizmaa/Screens/events/event_settings_tab.dart';
import 'package:fizmaa/Screens/events/event_voluteer_tab.dart';
import 'package:fizmaa/Screens/events/overview.dart';
import 'package:fizmaa/Screens/events/inventory.dart';
import 'package:fizmaa/Screens/events/venue_screen.dart';
import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';

class EventDetailsHostScreen extends StatefulWidget {
  const EventDetailsHostScreen({super.key});

  @override
  State<EventDetailsHostScreen> createState() => _EventDetailsHostScreenState();
}

class _EventDetailsHostScreenState extends State<EventDetailsHostScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          // ---------- TOP HERO IMAGE BANNER ----------
          Stack(
            children: [
              // Banner Image with proper height to fix badge clipping
              Image.network(
                'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?q=80&w=800&auto=format&fit=crop',
                height: 230,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              // Dark Gradient Overlay for readability
              Container(
                height: 230,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.35),
                      Colors.black.withOpacity(0.85),
                    ],
                  ),
                ),
              ),
              // Content Over Banner
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top Navigation Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildGlassIconButton(
                            icon: Icons.arrow_back_ios_new,
                            onTap: () => Navigator.pop(context),
                          ),
                          _buildGlassIconButton(
                            icon: Icons.share_outlined,
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // Event Title
                      const Text(
                        'Bhajan Concert 2026',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Metadata Row
                      Row(
                        children: const [
                          Icon(Icons.calendar_today_outlined, size: 12, color: Colors.white70),
                          SizedBox(width: 4),
                          Text('12 Sept 2025', style: TextStyle(fontSize: 11, color: Colors.white70)),
                          SizedBox(width: 12),
                          Icon(Icons.location_on_outlined, size: 12, color: Colors.white70),
                          SizedBox(width: 4),
                          Text('2 venues', style: TextStyle(fontSize: 11, color: Colors.white70)),
                          SizedBox(width: 12),
                          Icon(Icons.mic_none_rounded, size: 12, color: Colors.white70),
                          SizedBox(width: 4),
                          Text('3 artists', style: TextStyle(fontSize: 11, color: Colors.white70)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Badges Row
                      Row(
                        children: [
                          _buildHeaderBadge('Published', Colors.white, const Color(0xFF3730A3)),
                          const SizedBox(width: 6),
                          _buildHeaderBadge('🎟 Ticket-Based', Colors.white.withOpacity(0.25), Colors.white),
                          const SizedBox(width: 6),
                          _buildHeaderBadge('Conference', Colors.white.withOpacity(0.25), Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ---------- TOP TAB BAR ----------
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              labelColor: AppColors.kRed,
              unselectedLabelColor: const Color(0xFF9CA3AF),
              indicatorColor: AppColors.kRed,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Inventory'),
                Tab(text: 'Schedule'),
                Tab(text: 'Volunteers'),
                Tab(text: 'Settings'),
              ],
            ),
          ),

          // ---------- TAB VIEW CONTENT ----------
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const EventOverviewTab(),
                const EventInventoryTab(),
                const EventScheduleTab(),
                const EventVolunteersTab(),
                const EventSettingsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Circular Glass Button Helper
  Widget _buildGlassIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 15, color: Colors.white),
      ),
    );
  }

  // Badge Helper
  Widget _buildHeaderBadge(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }
}