import 'package:fizma/Screens/events/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:fizma/utils/customappbar.dart';

class LiveEventsScreen extends StatefulWidget {
  const LiveEventsScreen({super.key});

  @override
  State<LiveEventsScreen> createState() => _LiveEventsScreenState();
}

class _LiveEventsScreenState extends State<LiveEventsScreen> {
  String selectedTab = 'Current Live';

  final Map<String, Map<String, String>> tabContentConfig = {
    'Current Live': {
      'title': 'All Live Events',
      'subtitle': 'Manage your hosted events',
    },
    'In Progress': {'title': 'Draft Events', 'subtitle': 'Manage your drafts'},
    'History': {
      'title': 'All Past Events',
      'subtitle': 'View your past analytics',
    },
  };

  final List<Map<String, dynamic>> events = [
    {
      'title': 'Bhajan concert',
      'location': 'Nashik - Jan 15',
      'sold': '624',
      'revenue': '₹1.24L',
      'progress': 0.78,
      'category': 'Music',
      'image':
          'https://images.unsplash.com/photo-1501386761578-eac5c94b800a?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Nashik wine festival',
      'location': 'Nashik - Jan 15',
      'sold': '489',
      'revenue': '₹97.8K',
      'progress': 0.62,
      'category': 'Food',
      'image':
          'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Sufi night concert',
      'location': 'Nashik - Jan 15',
      'sold': '731',
      'revenue': '₹1.46L',
      'progress': 0.91,
      'category': 'Music',
      'image':
          'https://images.unsplash.com/photo-1465847899084-d164df4dedc6?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Cultural fest 2026',
      'location': 'Nashik - Jan 15',
      'sold': '652',
      'revenue': '₹1.30L',
      'progress': 0.83,
      'category': 'Culture',
      'image':
          'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Sufi night concert',
      'location': 'Nashik - Jan 15',
      'sold': '731',
      'revenue': '₹1.46L',
      'progress': 0.91,
      'category': 'Music',
      'image':
          'https://images.unsplash.com/photo-1465847899084-d164df4dedc6?w=500&auto=format&fit=crop&q=60',
    },
    {
      'title': 'Cultural fest 2026',
      'location': 'Nashik - Jan 15',
      'sold': '652',
      'revenue': '₹1.30L',
      'progress': 0.83,
      'category': 'Culture',
      'image':
          'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=500&auto=format&fit=crop&q=60',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentAppBarConfig =
        tabContentConfig[selectedTab] ?? tabContentConfig['Current Live']!;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F3),
      appBar: CustomAppBar(
        title: currentAppBarConfig['title']!,
        subtitle: currentAppBarConfig['subtitle']!,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTabButton('Current Live', Icons.fiber_manual_record),
                const SizedBox(width: 10),
                _buildTabButton('In Progress', Icons.calendar_month_outlined),
                const SizedBox(width: 10),
                _buildTabButton('History', Icons.history),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.76,
                ),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final item = events[index];
                  return _buildEventCard(item, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMenuSelected(String action, int index) {
    final event = events[index];
    switch (action) {
      case 'preview':
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const EventDetailScreen(),
        ),
      );
      break;
      case 'edit':
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Edit: ${event['title']}')));
        break;
      case 'delete':
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Delete: ${event['title']}')));
        break;
    }
  }

  Widget _buildTabButton(String title, IconData icon) {
    final isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.redAccent : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.black87,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> item, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image section
            Expanded(
              flex: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(item['image'], fit: BoxFit.cover),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Live',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item['category'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content section
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10.0), // ✅ Original padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title + 3-dot menu - FIXED ALIGNMENT
                    // Title + 3-dot menu - PERFECT ALIGNMENT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item['title'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        // ✅ 3 dots EXACTLY right corner — no extra padding
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: PopupMenuButton<String>(
  padding: EdgeInsets.zero,
  child: const Icon(
    Icons.more_vert,
    size: 16,
    color: Colors.black54,
  ),
  onSelected: (value) => _onMenuSelected(value, index),
  itemBuilder: (context) => [
    const PopupMenuItem(
      value: 'preview',
      child: Row(
        children: [
          Icon(
            Icons.visibility_outlined,
            size: 18,
            color: Colors.blue,
          ),
          SizedBox(width: 8),
          Text('Preview'),
        ],
      ),
    ),
    const PopupMenuItem(
      value: 'edit',
      child: Row(
        children: [
          Icon(
            Icons.edit_outlined,
            size: 18,
            color: Colors.green,
          ),
          SizedBox(width: 8),
          Text('Edit'),
        ],
      ),
    ),
    const PopupMenuItem(
      value: 'delete',
      child: Row(
        children: [
          Icon(
            Icons.delete_outline,
            size: 18,
            color: Colors.red,
          ),
          SizedBox(width: 8),
          Text('Delete'),
        ],
      ),
    ),
  ],
  color: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: BorderSide(color: Colors.grey.shade200),
  ),
  elevation: 4,
),
                        ),
                      ],
                    ),
                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          item['location'],
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sold',
                              style: TextStyle(fontSize: 9, color: Colors.grey),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              item['sold'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Revenue',
                              style: TextStyle(fontSize: 9, color: Colors.grey),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              item['revenue'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: item['progress'],
                        backgroundColor: Colors.grey.shade200,
                        color: Colors.redAccent,
                        minHeight: 3.5,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '${(item['progress'] * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
