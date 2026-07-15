import 'package:fizma/utils/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:fizma/Screens/events/about_screen.dart';
import 'package:fizma/Screens/events/artist_screen.dart';
import 'package:fizma/Screens/events/venue_screen.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  String activeTab = 'About';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F3),
      // ✅ FIXED: Default AppBar (no CustomAppBar)
      appBar: CustomAppBar(
        title: 'Event Details',
        subtitle: 'Event Overview',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner
            Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1501386761578-eac5c94b800a?w=800&auto=format&fit=crop&q=80',
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Badges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickBadge(Icons.location_on_rounded, 'Panchavati, Nashik'),
                  _buildQuickBadge(Icons.calendar_month_rounded, '11 Apr, 6 PM'),
                  _buildQuickBadge(Icons.access_time_filled, '4 Hours'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTabHeaderButton('About'),
                    _buildTabHeaderButton('Artists'),
                    _buildTabHeaderButton('Venue'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _renderActiveTabContent(),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTabHeaderButton(String tabName) {
    final isSelected = activeTab == tabName;
    return GestureDetector(
      onTap: () {
        setState(() {
          activeTab = tabName;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tabName,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.redAccent : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: 70,
            color: isSelected ? Colors.redAccent : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _renderActiveTabContent() {
    switch (activeTab) {
      case 'Artists':
        return const ArtistsTab();
      case 'Venue':
        return const VenueTab();
      case 'About':
      default:
        return const AboutTab();
    }
  }

  Widget _buildQuickBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EE),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.amber.shade200, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.orange[800]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.brown[900],
            ),
          ),
        ],
      ),
    );
  }
}