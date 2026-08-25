import 'package:flutter/material.dart';

class EventScheduleTab extends StatelessWidget {
  const EventScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ---------- DAY 1: FRIDAY, 12 SEPT ----------
        _buildDateHeader(
          dayNumber: '12',
          dateText: 'Friday, 12 Sept',
          sessionsCount: '2 sessions',
          color: const Color(0xFFEF4444),
        ),
        const SizedBox(height: 12),
        _buildTimelineCard(
          dotColor: const Color(0xFFEF4444),
          title: 'Opening Keynote',
          time: '09:00 - 11:00',
          duration: '2h',
          location: 'Grand Convention Center · San Francisco, CA',
        ),
        const SizedBox(height: 12),
        _buildTimelineCard(
          dotColor: const Color(0xFFEF4444),
          title: 'AI & The Future',
          time: '13:00 - 15:30',
          duration: '2h 30m',
          location: 'Grand Convention Center · San Francisco, CA',
        ),

        const SizedBox(height: 24),

        // ---------- DAY 2: SATURDAY, 13 SEPT ----------
        _buildDateHeader(
          dayNumber: '13',
          dateText: 'Saturday, 13 Sept',
          sessionsCount: '1 session',
          color: const Color(0xFF6366F1),
        ),
        const SizedBox(height: 12),
        _buildTimelineCard(
          dotColor: const Color(0xFF6366F1),
          title: 'Day 2 Workshop',
          time: '10:00 - 16:00',
          duration: '6h',
          location: 'Tech Hub Arena · Austin, TX',
        ),

        const SizedBox(height: 24),

        // ---------- DAY 3: SUNDAY, 14 SEPT ----------
        _buildDateHeader(
          dayNumber: '14',
          dateText: 'Sunday, 14 Sept',
          sessionsCount: '1 session',
          color: const Color(0xFF10B981),
        ),
        const SizedBox(height: 12),
        _buildTimelineCard(
          dotColor: const Color(0xFF10B981),
          title: 'Closing Panel',
          time: '16:00 - 18:00',
          duration: '2h',
          location: 'Grand Convention Center · San Francisco, CA',
        ),

        const SizedBox(height: 24),

        // ---------- VENUE DETAILS SECTION ----------
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
                'Venue Details',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 14),
              _buildVenueCard(
                name: 'Grand Convention Center',
                address: '123 Harbor Blvd, San Francisco, CA',
                capacity: '2,500 cap',
              ),
              const SizedBox(height: 12),
              _buildVenueCard(
                name: 'Tech Hub Arena',
                address: '999 Innovation Dr, Austin, TX',
                capacity: '800 cap',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Header with Date Circle & Session count
  Widget _buildDateHeader({
    required String dayNumber,
    required String dateText,
    required String sessionsCount,
    required Color color,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: color,
          child: Text(
            dayNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            Text(
              sessionsCount,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Session Card with left indicator dot
  Widget _buildTimelineCard({
    required Color dotColor,
    required String title,
    required String time,
    required String duration,
    required String location,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Colored Dot
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(left: 13, right: 13),
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        // Main Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 13, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        duration,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 13, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Venue Card Widget
  Widget _buildVenueCard({
    required String name,
    required String address,
    required String capacity,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Building Placeholder Icon/Image
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.location_city, color: Color(0xFF3B82F6), size: 20),
          ),
          const SizedBox(width: 10),
          // Text Info
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
                  address,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Indoor',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.people_alt_outlined, size: 12, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 3),
                    Text(
                      capacity,
                      style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // Get Directions Button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Get Directions',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}