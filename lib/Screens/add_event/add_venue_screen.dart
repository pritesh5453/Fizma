import 'package:fizmaa/Screens/add_event/add_event_slot.dart';
import 'package:fizmaa/Screens/add_event/add_venue_slot.dart' hide VenueOption;
import 'package:fizmaa/models_n_services/add_venue/add_venue_model.dart';
import 'package:fizmaa/models_n_services/venue_list/venue_list_svc.dart';
import 'package:fizmaa/models_n_services/venue_list/venue_list_model.dart';
import 'package:fizmaa/models_n_services/venue_submit/venue_request_model.dart';
import 'package:fizmaa/models_n_services/venue_submit/venue_request_svc.dart';
import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';

// ---------- Local Data Model for a Venue Entry (with controllers) ----------
class VenueEntry {
  final String id;
  VenueOption? selectedVenue;
  String capacity;
  String safetyCap;

  // Controllers – created lazily so they persist
  TextEditingController? _capacityController;
  TextEditingController? _safetyCapController;

  VenueEntry({
    required this.id,
    this.selectedVenue,
    this.capacity = '',
    this.safetyCap = '',
  });

  // Get or create capacity controller, synced with current value
  TextEditingController get capacityController {
    _capacityController ??= TextEditingController(text: capacity);
    return _capacityController!;
  }

  // Get or create safety cap controller, synced with current value
  TextEditingController get safetyCapController {
    _safetyCapController ??= TextEditingController(text: safetyCap);
    return _safetyCapController!;
  }

  // Update capacity and sync controller text
  void updateCapacity(String newValue) {
    capacity = newValue;
    if (_capacityController != null && _capacityController!.text != newValue) {
      _capacityController!.text = newValue;
    }
  }

  // Update safety cap and sync controller text
  void updateSafetyCap(String newValue) {
    safetyCap = newValue;
    if (_safetyCapController != null && _safetyCapController!.text != newValue) {
      _safetyCapController!.text = newValue;
    }
  }

  VenueEntry copyWith({
    String? id,
    VenueOption? selectedVenue,
    String? capacity,
    String? safetyCap,
  }) {
    final newEntry = VenueEntry(
      id: id ?? this.id,
      selectedVenue: selectedVenue ?? this.selectedVenue,
      capacity: capacity ?? this.capacity,
      safetyCap: safetyCap ?? this.safetyCap,
    );
    if (_capacityController != null) newEntry._capacityController = _capacityController;
    if (_safetyCapController != null) newEntry._safetyCapController = _safetyCapController;
    return newEntry;
  }

  void dispose() {
    _capacityController?.dispose();
    _safetyCapController?.dispose();
  }
}

// ---------- Main Screen ----------
class AddVenueScreen extends StatefulWidget {
  final String eventName;
  final String eventCategory;
  final String organiserName;
  final String languages;
  final String eventId;
  final String status;
  final int organiserId;

  const AddVenueScreen({
    super.key,
    required this.eventName,
    required this.eventCategory,
    required this.organiserName,
    required this.languages,
    required this.eventId,
    required this.status,
    required this.organiserId,
  });

  @override
  State<AddVenueScreen> createState() => _AddVenueScreenState();
}

class _AddVenueScreenState extends State<AddVenueScreen> {
  // ---------- Venue API Integration ----------
  final VenueService _venueService = VenueService();
  List<VenueOption> _apiVenues = [];
  bool _isLoadingVenues = false;
  String _venuesError = '';

  // ---------- Submit Service ----------
  final VenueSubmitService _submitService = VenueSubmitService();
  bool _isSubmitting = false;

  // ---------- Existing UI state ----------
  int _selectedTab = 0;
  bool _isVenueCardExpanded = true;
  bool _isDropdownOpen = false;

  // Tab 0 (Select Existing) Controllers & State
  List<VenueEntry> _venues = [];
  final TextEditingController _searchController = TextEditingController();

  // Tab 1 (Add New Venue) Controllers & State
  final TextEditingController _newVenueNameController = TextEditingController();
  final TextEditingController _newAddressController = TextEditingController();
  String _selectedVenueType = 'Indoor';
  final List<String> _venueTypeOptions = ['Indoor', 'Outdoor', 'Auditorium', 'Stadium', 'Hybrid'];

  bool _isSubmittingVenue = false;

  @override
  void initState() {
    super.initState();
    _venues.add(VenueEntry(id: DateTime.now().millisecondsSinceEpoch.toString()));
    _fetchVenues();
  }

  // ---------- Helper: Show Snackbar ----------
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // ---------- Fetch Venues from API ----------
  Future<void> _fetchVenues() async {
    setState(() {
      _isLoadingVenues = true;
      _venuesError = '';
    });

    try {
      final venues = await _venueService.getVenueOptions(widget.organiserId);
      setState(() {
        _apiVenues = venues;
        _isLoadingVenues = false;
      });
    } catch (e) {
      setState(() {
        _venuesError = 'Failed to load venues: $e';
        _isLoadingVenues = false;
      });
      _showSnackBar('Could not fetch venues: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _newVenueNameController.dispose();
    _newAddressController.dispose();
    for (var entry in _venues) {
      entry.dispose();
    }
    super.dispose();
  }

  void _addVenue() {
    setState(() {
      _venues.add(VenueEntry(id: DateTime.now().millisecondsSinceEpoch.toString()));
    });
  }

  void _removeVenue(String id) {
    if (_venues.length <= 1) return;
    final index = _venues.indexWhere((v) => v.id == id);
    if (index != -1) {
      _venues[index].dispose();
      setState(() {
        _venues.removeAt(index);
        _isDropdownOpen = false;
      });
    }
  }

  void _updateVenue(String id, VenueEntry updated) {
    final index = _venues.indexWhere((v) => v.id == id);
    if (index != -1) {
      setState(() {
        _venues[index] = updated;
      });
    }
  }

  // ---------- Handle Save New Venue (API Call) ----------
  Future<void> _handleAddNewVenue() async {
    if (_newVenueNameController.text.trim().isEmpty) {
      _showSnackBar('Please enter venue name');
      return;
    }
    if (_newAddressController.text.trim().isEmpty) {
      _showSnackBar('Please enter address or Google Maps link');
      return;
    }

    setState(() => _isSubmittingVenue = true);

    final request = AddVenueRequest(
      organiserId: widget.organiserId,
      venueName: _newVenueNameController.text.trim(),
      exactAddress: _newAddressController.text.trim(),
      googleMapsLink: _newAddressController.text.trim(),
      latitude: 0.0,
      longitude: 0.0,
      venueType: _selectedVenueType,
    );

    try {
      final response = await _venueService.addVenue(request);
      if (!mounted) return;

      _showSnackBar('Venue added successfully!');
      _newVenueNameController.clear();
      _newAddressController.clear();
      await _fetchVenues();
      setState(() {
        _selectedTab = 0;
      });
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Failed to add venue: $e');
    } finally {
      if (mounted) setState(() => _isSubmittingVenue = false);
    }
  }

  // ---------- Submit selected venues for the event ----------
  Future<void> _handleSubmitVenues() async {
    // Validate each venue entry
    for (var entry in _venues) {
      if (entry.selectedVenue == null) {
        _showSnackBar('Please select a venue for all entries.');
        return;
      }
      if (entry.capacity.trim().isEmpty) {
        _showSnackBar('Please enter capacity for all venues.');
        return;
      }
      if (int.tryParse(entry.capacity.trim()) == null) {
        _showSnackBar('Capacity must be a valid number.');
        return;
      }
      // Safety cap optional – if provided, must be number
      if (entry.safetyCap.trim().isNotEmpty && int.tryParse(entry.safetyCap.trim()) == null) {
        _showSnackBar('Safety cap must be a valid number.');
        return;
      }
    }

    setState(() => _isSubmitting = true);

    // Build request
    final venueItems = _venues.map((entry) {
      final cap = int.parse(entry.capacity.trim());
      final safety = entry.safetyCap.trim().isEmpty
          ? 0
          : int.tryParse(entry.safetyCap.trim()) ?? 0;
      return VenueItemRequest(
        venueId: entry.selectedVenue!.id,
        venueName: entry.selectedVenue!.name,
        capacity: cap,
        safetyCap: safety,
      );
    }).toList();

    final request = VenueSubmitRequest(
      eventId: int.tryParse(widget.eventId) ?? 0,
      organiserId: widget.organiserId,
      step: 3,
      venues: venueItems,
    );

    try {
      final response = await _submitService.submitVenues(request);
      if (!mounted) return;

      if (response.success) {
        _showSnackBar(response.message);
        
        // ✅ Navigate to next screen – ONLY EVENT ID PASSED
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEventSlotScreen(
              eventId: int.tryParse(widget.eventId) ?? 0,
              organiserId: widget.organiserId,
            ),
          ),
        );
      } else {
        _showSnackBar('Failed: ${response.message}');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Error submitting venues: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            _buildProgressBar(),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (_isDropdownOpen) {
                    setState(() => _isDropdownOpen = false);
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _eventSummaryCard(),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Select one or more venues for this event.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.kTextDark.withOpacity(0.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTabSelector(),
                      const SizedBox(height: 16),
                      if (_selectedTab == 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Venues',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.kTextDark,
                              ),
                            ),
                            GestureDetector(
                              onTap: _addVenue,
                              child: const Text(
                                '+ Assign Venue',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.kRed,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ..._venues.map((entry) => _buildSelectExistingCard(entry)).toList(),
                      ] else ...[
                        _buildAddNewVenueCard(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  // ---------- Top Bar ----------
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.kTextDark),
          ),
          const Text(
            'Add Event',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.kTextDark),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  // ---------- Progress Bar ----------
  Widget _buildProgressBar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(6, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index == 5 ? 0 : 4),
                  height: 4,
                  decoration: BoxDecoration(
                    color: index < 3 ? AppColors.kRed : const Color(0xFFF0E0E0),
                    borderRadius: BorderRadius.circular(4),
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
            children: [
              Text('Step 3 of 6', style: TextStyle(fontSize: 10, color: AppColors.kTextDark.withOpacity(0.5))),
              const Text('Select Venue', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.kRed)),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- Event Summary Card ----------
  Widget _eventSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF3E8E8)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.calendar_month_outlined, color: AppColors.kRed, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.eventName,
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.kTextDark),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: widget.status == 'draft' ? const Color(0xFFFFF8E7) : const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.status,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: widget.status == 'draft' ? const Color(0xFFD97706) : const Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'By : ${widget.organiserName} | ${widget.languages} | ID : ${widget.eventId}',
                  style: TextStyle(fontSize: 10.5, color: AppColors.kTextDark.withOpacity(0.45)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Tab Selector ----------
  Widget _buildTabSelector() {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F1F1),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 0),
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedTab == 0 ? AppColors.kRed : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Select Existing',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: _selectedTab == 0 ? AppColors.kWhite : AppColors.kTextDark.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 1),
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedTab == 1 ? AppColors.kRed : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  '+ Add New Venue',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: _selectedTab == 1 ? AppColors.kWhite : AppColors.kTextDark.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- TAB 0: Select Existing Card ----------
  Widget _buildSelectExistingCard(VenueEntry entry) {
    final index = _venues.indexOf(entry);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF3E8E8)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isVenueCardExpanded = !_isVenueCardExpanded),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Venue ${index + 1}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.kTextDark),
                  ),
                  Row(
                    children: [
                      if (_venues.length > 1)
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.close, color: Colors.grey, size: 18),
                          onPressed: () => _removeVenue(entry.id),
                        ),
                      Icon(
                        _isVenueCardExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: AppColors.kTextDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isVenueCardExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('Select Venue'),
                  const SizedBox(height: 6),
                  _buildDropdownField(entry),
                  if (_isDropdownOpen && _venues.indexOf(entry) == _venues.length - 1)
                    _buildDropdownOverlay(entry),
                  const SizedBox(height: 12),
                  _fieldLabel('Max Capacity'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: entry.capacityController,
                    hint: 'Enter Venue Capacity',
                    keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                    onChanged: (val) => entry.updateCapacity(val),
                  ),
                  const SizedBox(height: 12),
                  _fieldLabel('Safety Cap (Optional)'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: entry.safetyCapController,
                    hint: 'e.g. 200',
                    keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                    onChanged: (val) => entry.updateSafetyCap(val),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ---------- TAB 1: Add New Venue Card ----------
  Widget _buildAddNewVenueCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Venue Name'),
          const SizedBox(height: 6),
          _buildTextField(controller: _newVenueNameController, hint: 'e.g. City Conference Hall'),
          const SizedBox(height: 14),
          _fieldLabel('Exact Address / Google Maps Link'),
          const SizedBox(height: 6),
          _buildTextField(controller: _newAddressController, hint: 'Enter address or paste google maps link'),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'or',
              style: TextStyle(fontSize: 12, color: AppColors.kTextDark.withOpacity(0.4)),
            ),
          ),
          const SizedBox(height: 12),
          _fieldLabel('Select Location'),
          const SizedBox(height: 6),
          _buildLocationPickerTile(),
          const SizedBox(height: 14),
          _fieldLabel('Venue Type'),
          const SizedBox(height: 6),
          _buildVenueTypeDropdown(),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: _isSubmittingVenue ? null : _handleAddNewVenue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kRed,
                foregroundColor: AppColors.kWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmittingVenue
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.kWhite),
                    )
                  : const Text(
                      'Save Venue',
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Dropdown Field ----------
  Widget _buildDropdownField(VenueEntry entry) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_isDropdownOpen) {
            _isDropdownOpen = false;
          } else {
            _isDropdownOpen = true;
          }
        });
      },
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _isDropdownOpen ? AppColors.kRed : const Color(0xFFFFCCCC),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              entry.selectedVenue != null ? entry.selectedVenue!.name : 'Search & Select Venue',
              style: TextStyle(
                fontSize: 12.5,
                color: entry.selectedVenue != null ? AppColors.kTextDark : AppColors.kTextDark.withOpacity(0.35),
              ),
            ),
            Icon(
              _isDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppColors.kTextDark.withOpacity(0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Dropdown Overlay ----------
  Widget _buildDropdownOverlay(VenueEntry entry) {
    List<VenueOption> sourceVenues = _apiVenues.isNotEmpty ? _apiVenues : [];

    final filteredVenues = sourceVenues
        .where((v) => v.name.toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();

    if (_isLoadingVenues && sourceVenues.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFF0E0E0)),
        ),
        child: const Center(
          child: SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      );
    }

    if (sourceVenues.isEmpty && !_isLoadingVenues) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFF0E0E0)),
        ),
        child: const Center(
          child: Text(
            'No venues found. Please add a new venue.',
            style: TextStyle(fontSize: 12, color: AppColors.kHint),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFF0E0E0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFFD1D1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, size: 18, color: AppColors.kRed),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Search Venue',
                      hintStyle: TextStyle(fontSize: 12, color: Color(0xFFB0A0A0)),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 12, color: AppColors.kTextDark),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.kRed,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.near_me, size: 12, color: AppColors.kWhite),
                    SizedBox(width: 4),
                    Text('Near Me', style: TextStyle(fontSize: 11, color: AppColors.kWhite, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Recent Searches',
                style: TextStyle(fontSize: 11, color: AppColors.kTextDark.withOpacity(0.4)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 220),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: filteredVenues.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final venue = filteredVenues[index];
                final isSelected = entry.selectedVenue?.name == venue.name;

                return GestureDetector(
                  onTap: () {
                    _updateVenue(entry.id, entry.copyWith(
                      selectedVenue: venue,
                      capacity: venue.capacity.toString(),
                    ));
                    setState(() => _isDropdownOpen = false);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFFF5F5) : AppColors.kWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.kRed : const Color(0xFFF0E0E0),
                        width: isSelected ? 1.2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5EAEA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.business, size: 16, color: Color(0xFF887070)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                venue.name,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.kTextDark),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${venue.city ?? ''} · Cap. ${venue.capacity}',
                                style: TextStyle(fontSize: 10, color: AppColors.kTextDark.withOpacity(0.45)),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F4FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  venue.type ?? '', // ✅ null safety fix
                                  style: const TextStyle(fontSize: 9, color: Color(0xFF3B82F6), fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: AppColors.kRed,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, size: 12, color: AppColors.kWhite),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Location Picker ----------
  Widget _buildLocationPickerTile() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFFFCCCC), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select on Map',
              style: TextStyle(fontSize: 12.5, color: AppColors.kTextDark.withOpacity(0.4)),
            ),
            Icon(
              Icons.location_on_outlined,
              color: AppColors.kTextDark.withOpacity(0.7),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Venue Type Dropdown ----------
  Widget _buildVenueTypeDropdown() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFCCCC), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedVenueType,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.kTextDark.withOpacity(0.7),
            size: 20,
          ),
          style: const TextStyle(fontSize: 12.5, color: AppColors.kTextDark),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedVenueType = newValue;
              });
            }
          },
          items: _venueTypeOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ---------- Helpers ----------
  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.kTextDark),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFCCCC), width: 1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 12.5, color: AppColors.kTextDark.withOpacity(0.35)),
          border: InputBorder.none,
          isDense: true,
        ),
        style: const TextStyle(fontSize: 12.5, color: AppColors.kTextDark),
      ),
    );
  }

  // ---------- Bottom Button ----------
  Widget _buildBottomButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: AppColors.kWhite,
      child: SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _handleSubmitVenues,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.kRed,
            foregroundColor: AppColors.kWhite,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.kWhite),
                )
              : const Text(
                  'Save & Proceed to Sessions',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }
}