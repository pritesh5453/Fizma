import 'package:fizmaa/Screens/add_event/add_venue_slot.dart';
import 'package:fizmaa/Screens/add_event/event_publish.dart';
import 'package:fizmaa/Screens/navbar/navbar.dart';
import 'package:fizmaa/models_n_services/add_event/add_event_model.dart';
import 'package:fizmaa/models_n_services/add_event/add_event_svc.dart';
import 'package:fizmaa/models_n_services/assign_volunteers/assign_volunteers_model.dart';
import 'package:fizmaa/models_n_services/assign_volunteers/assign_volunteers_svc.dart';
import 'package:fizmaa/models_n_services/event_volunteers/volunteers_list.dart';
import 'package:fizmaa/models_n_services/event_volunteers/volunteers_list_svc.dart';
import 'package:fizmaa/models_n_services/publish_event/publish_event_model.dart';
import 'package:fizmaa/models_n_services/publish_event/publish_event_svc.dart';
import 'package:fizmaa/utils/app_preference.dart';
import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';

class AssignVolunteersScreen extends StatefulWidget {
  final int eventId;
  final int organiserId;
  final List<VenueWithSlots> venues;

  const AssignVolunteersScreen({
    super.key,
    required this.eventId,
    required this.organiserId,
    required this.venues,
  });

  @override
  State<AssignVolunteersScreen> createState() => _AssignVolunteersScreenState();
}

class _AssignVolunteersScreenState extends State<AssignVolunteersScreen> {
  final VolunteerService _volunteerService = VolunteerService();
  final AssignVolunteerService _assignService = AssignVolunteerService();
  final PublishEventService _publishService = PublishEventService();
  final EventService _eventService = EventService(); // for saving draft

  List<Volunteer> _volunteers = [];
  bool _isLoading = false;
  bool _isAssigning = false;
  bool _isPublishing = false;
  bool _isSavingDraft = false;
  String _errorMessage = '';

  // Selected but not yet assigned
  final Set<int> _selectedVolunteerIds = {};
  // Already assigned (persistent)
  final Set<int> _assignedVolunteerIds = {};

  @override
  void initState() {
    super.initState();
    _fetchVolunteers();
  }

  // ---------- Helpers ----------
  String _formatDateForApi(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  String _formatTimeForApi(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _fetchVolunteers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await _volunteerService.getVolunteers(widget.organiserId);
      if (!mounted) return;
      setState(() {
        _volunteers = response.data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _toggleSelection(int id) {
    if (_assignedVolunteerIds.contains(id)) {
      _showSnackBar('This volunteer is already assigned.');
      return;
    }
    setState(() {
      if (_selectedVolunteerIds.contains(id)) {
        _selectedVolunteerIds.remove(id);
      } else {
        _selectedVolunteerIds.add(id);
      }
    });
  }

  // ---------- Save as Draft (with current date/time) ----------
  Future<void> _saveAsDraft() async {
    setState(() => _isSavingDraft = true);

    final organiserId = await AppPreferences.getOrganiserId() ?? widget.organiserId;

    // ✅ Use current date/time to satisfy NOT NULL constraint
    final now = DateTime.now();
    final eventDate = _formatDateForApi(now);
    final startTime = _formatTimeForApi(now);
    final endTime = _formatTimeForApi(now.add(const Duration(hours: 1)));

    final request = EventCreateRequest(
      eventName: '',
      eventCategory: '',
      artists: [],
      ageRestriction: '',
      languages: [],
      description: '',
      tags: [],
      termsConditions: '',
      facilities: [],
      status: 'draft',
      promotionalVideoUrl: '',
      organiserId: organiserId,
      eventDate: eventDate,
      startTime: startTime,
      endTime: endTime,
      step: 6,
      eventId: widget.eventId,
    );

    try {
      final response = await _eventService.createEvent(request);
      if (!mounted) return;

      _showSnackBar('Event saved as draft!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const EventsNavBar(initialIndex: 1),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Failed to save draft: $e');
    } finally {
      if (mounted) setState(() => _isSavingDraft = false);
    }
  }

  // ---------- Assign Volunteers ----------
  Future<void> _assignVolunteers() async {
    if (_selectedVolunteerIds.isEmpty) {
      _showSnackBar('Please select at least one volunteer.');
      return;
    }

    setState(() => _isAssigning = true);

    final request = AssignVolunteerRequest(
      eventId: widget.eventId,
      step: 6,
      volunteerIds: _selectedVolunteerIds.toList(),
    );

    try {
      final response = await _assignService.assignVolunteers(request);
      if (!mounted) return;

      if (response.success) {
        setState(() {
          _assignedVolunteerIds.addAll(_selectedVolunteerIds);
        });
        _showSnackBar(response.message);
      } else {
        _showSnackBar('Failed: ${response.message}');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Error: $e');
    } finally {
      if (mounted) setState(() => _isAssigning = false);
    }
  }

  // ---------- Publish Event ----------
  Future<void> _publishEvent() async {
    setState(() => _isPublishing = true);

    final request = PublishEventRequest(eventId: widget.eventId);

    try {
      final response = await _publishService.publishEvent(request);
      if (!mounted) return;

      if (response.success) {
        _showSnackBar(response.message);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EventPublishedSuccessScreen(
              eventData: response.event,
            ),
          ),
        );
      } else {
        _showSnackBar('Failed: ${response.message}');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Error: $e');
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }

  // ---------- UI Helpers ----------
  Color _getAvatarColor(String name) {
    final colors = [
      const Color(0xFFE53935),
      const Color(0xFFFB8C00),
      const Color(0xFF00BFA5),
      const Color(0xFF29B6F6),
      const Color(0xFF7E57C2),
      const Color(0xFFEC407A),
      const Color(0xFF26A69A),
    ];
    final index = name.hashCode % colors.length;
    return colors[index.abs()];
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
    }
    return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
  }

  String _getRoleDisplay(String access) {
    switch (access.toLowerCase()) {
      case 'password':
        return 'Ticket Scanner';
      case 'admin':
        return 'Admin';
      case 'view':
        return 'Viewer';
      case 'scan':
        return 'Scanner';
      default:
        return 'Volunteer';
    }
  }

  @override
  Widget build(BuildContext context) {
    final showSkip = _assignedVolunteerIds.isEmpty && _selectedVolunteerIds.isEmpty;
    final hasSelection = _selectedVolunteerIds.isNotEmpty;

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
                    _buildInfoNoticeCard(),
                    const SizedBox(height: 14),
                    Text(
                      '${_selectedVolunteerIds.length + _assignedVolunteerIds.length} of ${_volunteers.length} volunteers assigned',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (_isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (_errorMessage.isNotEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              const Icon(Icons.error_outline, color: AppColors.kRed, size: 40),
                              const SizedBox(height: 10),
                              Text(
                                'Failed to load volunteers',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _errorMessage,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchVolunteers,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.kRed,
                                  foregroundColor: AppColors.kWhite,
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (_volunteers.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text(
                            'No volunteers available for this organiser.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _volunteers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = _volunteers[index];
                          final isSelected = _selectedVolunteerIds.contains(item.id);
                          final isAssigned = _assignedVolunteerIds.contains(item.id);
                          return _buildVolunteerCard(item, isSelected, isAssigned);
                        },
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(hasSelection, showSkip),
          ],
        ),
      ),
    );
  }

  // ---------- Header Top Bar (with Save as Draft) ----------
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
          GestureDetector(
            onTap: _isSavingDraft ? null : _saveAsDraft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _isSavingDraft ? Colors.grey.shade300 : AppColors.kChipBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isSavingDraft ? Colors.grey.shade400 : AppColors.kRed,
                  width: 1.2,
                ),
              ),
              child: _isSavingDraft
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.grey,
                      ),
                    )
                  : const Text(
                      'Save as Draft',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.kRed,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Step Progress Bar ----------
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

  // ---------- Info Notice Card ----------
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

  // ---------- Volunteer Card ----------
  Widget _buildVolunteerCard(Volunteer item, bool isSelected, bool isAssigned) {
    final initials = _getInitials(item.volunteerName);
    final avatarColor = _getAvatarColor(item.volunteerName);
    final isActive = item.isActive == 1;
    final role = _getRoleDisplay(item.access);

    return GestureDetector(
      onTap: isAssigned ? null : () => _toggleSelection(item.id),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected || isAssigned ? AppColors.kRed : const Color(0xFFF0F0F0),
            width: isSelected || isAssigned ? 1.5 : 1,
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
            CircleAvatar(
              radius: 22,
              backgroundColor: avatarColor,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.volunteerName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kTextDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$role · ${item.viewTickets + item.scanTickets} events',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFFE8F8F0) : const Color(0xFFF2F2F7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isActive ? const Color(0xFF00A86B) : const Color(0xFF8E8E93),
                          ),
                        ),
                      ),
                      if (isAssigned) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Assigned',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isSelected || isAssigned) ? AppColors.kRed : Colors.transparent,
                border: Border.all(
                  color: (isSelected || isAssigned) ? AppColors.kRed : const Color(0xFFD1D1D6),
                  width: 1.5,
                ),
              ),
              child: (isSelected || isAssigned)
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Bottom Action Buttons ----------
  Widget _buildBottomButtons(bool hasSelection, bool showSkip) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showSkip) ...[
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton(
                onPressed: _isPublishing ? null : _publishEvent,
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFEAEA),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isPublishing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: AppColors.kRed,
                        ),
                      )
                    : const Text(
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
          ],
          if (hasSelection) ...[
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: _isAssigning ? null : _assignVolunteers,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kRed,
                  foregroundColor: AppColors.kWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isAssigning
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: AppColors.kWhite,
                        ),
                      )
                    : const Text(
                        'Assign Volunteers',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isPublishing ? null : _publishEvent,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kRed,
                foregroundColor: AppColors.kWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isPublishing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: AppColors.kWhite,
                      ),
                    )
                  : Row(
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
