import 'package:flutter/material.dart';

class EventVolunteersTab extends StatelessWidget {
  const EventVolunteersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ---------- TOP BANNER / BANNER CARD ----------
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0F2FE)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.people_alt_outlined,
                  color: Color(0xFF0284C7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '3 Volunteers Assigned',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0369A1),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Manage scanning staff for this event',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ---------- ASSIGNED SECTION ----------
        const Text(
          'ASSIGNED',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B7280),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),

        _buildAssignedVolunteerCard(
          initials: 'AM',
          avatarBg: const Color(0xFFEF4444),
          name: 'Aisha Mensah',
          roleAndEvents: 'Ticket Scanner · 14 events',
          email: 'aisha.m@email.com',
        ),
        const SizedBox(height: 10),

        _buildAssignedVolunteerCard(
          initials: 'CR',
          avatarBg: const Color(0xFFF59E0B),
          name: 'Carlos Rivera',
          roleAndEvents: 'Entry Manager · 9 events',
          email: 'c.rivera@email.com',
        ),
        const SizedBox(height: 10),

        _buildAssignedVolunteerCard(
          initials: 'PN',
          avatarBg: const Color(0xFF10B981),
          name: 'Priya Nair',
          roleAndEvents: 'VIP Coordinator · 22 events',
          email: 'priya.nair@email.com',
        ),

        const SizedBox(height: 24),

        // ---------- AVAILABLE TO ASSIGN SECTION ----------
        const Text(
          'AVAILABLE TO ASSIGN',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B7280),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),

        _buildAvailableVolunteerCard(
          initials: 'JO',
          avatarBg: const Color(0xFF60A5FA),
          name: 'James Okonkwo',
          roleAndEvents: 'Ticket Scanner · 6 events',
          statusType: VolunteerStatus.inactive,
        ),
        const SizedBox(height: 10),

        _buildAvailableVolunteerCard(
          initials: 'EV',
          avatarBg: const Color(0xFFA855F7),
          name: 'Elena Vasquez',
          roleAndEvents: 'Floor Manager · 17 events',
          statusType: VolunteerStatus.assign,
        ),
        const SizedBox(height: 10),

        _buildAvailableVolunteerCard(
          initials: 'RP',
          avatarBg: const Color(0xFFEC4899),
          name: 'Raj Patel',
          roleAndEvents: 'Ticket Scanner · 3 events',
          statusType: VolunteerStatus.assign,
        ),
        const SizedBox(height: 10),

        _buildAvailableVolunteerCard(
          initials: 'SC',
          avatarBg: const Color(0xFF2DD4BF),
          name: 'Sophie Chen',
          roleAndEvents: 'Entry Manager · 11 events',
          statusType: VolunteerStatus.inactive,
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  // Red/Pink Bordered Card for ASSIGNED Volunteers
  Widget _buildAssignedVolunteerCard({
    required String initials,
    required Color avatarBg,
    required String name,
    required String roleAndEvents,
    required String email,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCA5A5), width: 1.2),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: avatarBg,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
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
                  roleAndEvents,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF10B981),
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 13,
                  color: Color(0xFF10B981),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Standard Bordered Card for AVAILABLE Volunteers
  Widget _buildAvailableVolunteerCard({
    required String initials,
    required Color avatarBg,
    required String name,
    required String roleAndEvents,
    required VolunteerStatus statusType,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: avatarBg,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
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
                  roleAndEvents,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          if (statusType == VolunteerStatus.assign)
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                '+ Assign',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Inactive',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum VolunteerStatus { assign, inactive }