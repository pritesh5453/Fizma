import 'package:fizmaa/Screens/voluteer/add_voluteer.dart';
import 'package:fizmaa/models_n_services/event_volunteers/volunteers_list.dart';
import 'package:fizmaa/models_n_services/event_volunteers/volunteers_list_svc.dart';
import 'package:fizmaa/utils/app_preference.dart';
import 'package:flutter/material.dart';

class VolunteersScreen extends StatefulWidget {
  final int? organiserId; // now nullable
  const VolunteersScreen({super.key, this.organiserId});

  @override
  State<VolunteersScreen> createState() => _VolunteersScreenState();
}

class _VolunteersScreenState extends State<VolunteersScreen> {
  final VolunteerService _volunteerService = VolunteerService();

  int _selectedFilterIndex = 0; // 0: All, 1: Active, 2: Inactive
  List<Volunteer> _allVolunteers = [];
  List<Volunteer> _filteredVolunteers = [];
  bool _isLoading = true;
  String? _errorMessage;
  int? _organiserId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // If organiserId is passed, use it; else fetch from preferences
    if (widget.organiserId != null) {
      _organiserId = widget.organiserId;
      await _fetchVolunteers();
    } else {
      try {
        final id = await AppPreferences.getOrganiserId();
        if (id != null) {
          _organiserId = id;
          await _fetchVolunteers();
        } else {
          setState(() {
            _errorMessage = 'Organiser ID not found. Please log in again.';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error loading organiser ID: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchVolunteers() async {
    if (_organiserId == null) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await _volunteerService.getVolunteers(_organiserId!);
      setState(() {
        _allVolunteers = response.data;
        _applyFilter();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilter() {
    setState(() {
      if (_selectedFilterIndex == 0) {
        _filteredVolunteers = List.from(_allVolunteers);
      } else if (_selectedFilterIndex == 1) {
        _filteredVolunteers =
            _allVolunteers.where((v) => v.isActive == 1).toList();
      } else {
        _filteredVolunteers =
            _allVolunteers.where((v) => v.isActive == 0).toList();
      }
    });
  }

  int get _activeCount =>
      _allVolunteers.where((v) => v.isActive == 1).length;
  int get _inactiveCount =>
      _allVolunteers.where((v) => v.isActive == 0).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Volunteers',
              style: TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Manage your hosted events',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFFEF4444),
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // ---------- SEARCH BAR & ADD NEW ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF3F4F6)),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.search_rounded,
                            color: Color(0xFF9CA3AF),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search Volunteer...',
                                hintStyle: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 13,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddVolunteerScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add New'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- FILTER CHIPS ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip(
                    label: 'All   ${_allVolunteers.length}',
                    index: 0,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Active   $_activeCount',
                    index: 1,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Inactive   $_inactiveCount',
                    index: 2,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- VOLUNTEERS LIST ----------
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Error loading volunteers',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(_errorMessage!),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _initialize,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _filteredVolunteers.isEmpty
                          ? const Center(
                              child: Text('No volunteers found'),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _filteredVolunteers.length,
                              itemBuilder: (context, index) {
                                final volunteer = _filteredVolunteers[index];
                                return _buildVolunteerCard(volunteer);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required int index,
  }) {
    final bool isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
          _applyFilter();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEF4444) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFEF4444)
                : const Color(0xFFF3F4F6),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF4B5563),
          ),
        ),
      ),
    );
  }

  Widget _buildVolunteerCard(Volunteer volunteer) {
    final nameParts = volunteer.volunteerName.split(' ');
    final initials = nameParts.isNotEmpty
        ? (nameParts.length >= 2
            ? '${nameParts[0][0]}${nameParts[1][0]}'
            : nameParts[0][0])
        : '?';
    final List<Color> avatarColors = const [
      Color(0xFFEF4444),
      Color(0xFFF59E0B),
      Color(0xFF10B981),
      Color(0xFF3B82F6),
      Color(0xFF8B5CF6),
    ];
    final avatarBg = avatarColors[volunteer.id % avatarColors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: avatarBg,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              initials.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      volunteer.volunteerName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: volunteer.isActive == 1
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        volunteer.isActive == 1 ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: volunteer.isActive == 1
                              ? const Color(0xFF16A34A)
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  volunteer.access.isNotEmpty ? volunteer.access : 'No role',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  volunteer.email,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${volunteer.scanTickets} events scanned',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}