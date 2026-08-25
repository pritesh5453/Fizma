import 'package:fizma/Screens/add_event/event_publish.dart';
import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';

// ---------- Data Model for Volunteer ----------
class VolunteerItem {
  final String id;
  final String name;
  final String initials;
  final String role;
  final int eventsCount;
  final bool isActive;
  final Color avatarBgColor;

  VolunteerItem({
    required this.id,
    required this.name,
    required this.initials,
    required this.role,
    required this.eventsCount,
    required this.isActive,
    required this.avatarBgColor,
  });
}

class AssignVolunteersScreen extends StatefulWidget {
  const AssignVolunteersScreen({super.key});

  @override
  State<AssignVolunteersScreen> createState() => _AssignVolunteersScreenState();
}

class _AssignVolunteersScreenState extends State<AssignVolunteersScreen> {
  // Mock Volunteers List
  final List<VolunteerItem> _volunteers = [
    VolunteerItem(
      id: '1',
      name: 'Aisha Mensah',
      initials: 'AM',
      role: 'Ticket Scanner',
      eventsCount: 14,
      isActive: true,
      avatarBgColor: const Color(0xFFE53935),
    ),
    VolunteerItem(
      id: '2',
      name: 'Carlos Rivera',
      initials: 'CR',
      role: 'Entry Manager',
      eventsCount: 9,
      isActive: true,
      avatarBgColor: const Color(0xFFFB8C00),
    ),
    VolunteerItem(
      id: '3',
      name: 'Priya Nair',
      initials: 'PN',
      role: 'VIP Coordinator',
      eventsCount: 22,
      isActive: true,
      avatarBgColor: const Color(0xFF00BFA5),
    ),
    VolunteerItem(
      id: '4',
      name: 'James Okonkwo',
      initials: 'JO',
      role: 'Ticket Scanner',
      eventsCount: 6,
      isActive: false,
      avatarBgColor: const Color(0xFF29B6F6),
    ),
    VolunteerItem(
      id: '5',
      name: 'Elena Vasquez',
      initials: 'EV',
      role: 'Floor Manager',
      eventsCount: 17,
      isActive: true,
      avatarBgColor: const Color(0xFF7E57C2),
    ),
    VolunteerItem(
      id: '6',
      name: 'Raj Patel',
      initials: 'RP',
      role: 'Ticket Scanner',
      eventsCount: 3,
      isActive: true,
      avatarBgColor: const Color(0xFFEC407A),
    ),
    VolunteerItem(
      id: '7',
      name: 'Sophie Chen',
      initials: 'SC',
      role: 'Entry Manager',
      eventsCount: 11,
      isActive: false,
      avatarBgColor: const Color(0xFF26A69A),
    ),
  ];

  // Track selected volunteer IDs
  final Set<String> _selectedVolunteerIds = {};

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedVolunteerIds.contains(id)) {
        _selectedVolunteerIds.remove(id);
      } else {
        _selectedVolunteerIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildProgressBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------- INFO NOTICE CARD ----------
                    _buildInfoNoticeCard(),
                    const SizedBox(height: 14),

                    // ---------- SELECTION COUNTER TEXT ----------
                    Text(
                      '${_selectedVolunteerIds.length} of ${_volunteers.length} volunteers assigned',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ---------- VOLUNTEERS LIST ----------
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _volunteers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = _volunteers[index];
                        final isSelected = _selectedVolunteerIds.contains(item.id);
                        return _buildVolunteerCard(item, isSelected);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ---------- BOTTOM ACTION BUTTONS ----------
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  // ---------- Header Top Bar ----------
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, size: 18, color: AppColors.kTextDark),
          ),
          const Text(
            'Add Event',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.kTextDark,
            ),
          ),
          const SizedBox(width: 18),
        ],
      ),
    );
  }

  // ---------- Step Progress Bar (Step 6 of 6) ----------
  Widget _buildProgressBar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(6, (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index == 5 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: AppColors.kRed,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Step 6 of 6',
                style: TextStyle(fontSize: 11, color: AppColors.kHint),
              ),
              Text(
                'Assign Volunteers',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.kRed),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- Yellow Notice Card ----------
  Widget _buildInfoNoticeCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF78716C),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.fast_forward_rounded, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'This step is optional',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF854D0E),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'You can publish the event now and assign volunteers later from the event detail page.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFFA16207),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Volunteer Card Item ----------
  Widget _buildVolunteerCard(VolunteerItem item, bool isSelected) {
    return GestureDetector(
      onTap: () => _toggleSelection(item.id),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.kRed : const Color(0xFFF0F0F0),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.015),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Circular Avatar with Initials
            CircleAvatar(
              radius: 22,
              backgroundColor: item.avatarBgColor,
              child: Text(
                item.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Volunteer Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kTextDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.role} · ${item.eventsCount} events',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Active / Inactive Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: item.isActive ? const Color(0xFFE8F8F0) : const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: item.isActive ? const Color(0xFF00A86B) : const Color(0xFF8E8E93),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Custom Checkbox Circle
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.kRed : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.kRed : const Color(0xFFD1D1D6),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Bottom Stacked Action Buttons ----------
  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Skip & Publish Button
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton(
              onPressed: () {
                // Handle Publish without Volunteers
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFFFEAEA),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Skip & Publish without Volunteers',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kRed,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Main Publish Event Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EventPublishedSuccessScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kRed,
                foregroundColor: AppColors.kWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Publish Event',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.rocket_launch_rounded, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}