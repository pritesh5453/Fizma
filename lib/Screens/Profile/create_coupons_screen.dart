import 'package:fizmaa/api_endpoints/api_endpoint.dart';
import 'package:fizmaa/models_n_services/coupons/coupons_model.dart';
import 'package:fizmaa/models_n_services/coupons/coupons_svc.dart';
import 'package:fizmaa/models_n_services/event_models/all_event_svc.dart';
import 'package:fizmaa/models_n_services/events/all_events_model.dart';
import 'package:fizmaa/utils/app_preference.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class CreateCouponBottomSheet extends StatefulWidget {
  const CreateCouponBottomSheet({Key? key}) : super(key: key);

  @override
  State<CreateCouponBottomSheet> createState() => _CreateCouponBottomSheetState();
}

class _CreateCouponBottomSheetState extends State<CreateCouponBottomSheet> {
  String _selectedDiscountType = 'Percentage';
  String _selectedApplicableType = 'all';
  EventData? _selectedEvent;

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _discountValController = TextEditingController();
  final TextEditingController _usageLimitController = TextEditingController();
  final TextEditingController _perUserController = TextEditingController(text: '1');
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingEvents = false;
  List<EventData> _events = [];

  late final CouponService _couponService;
  late final EventsService _eventsService;

  @override
  void initState() {
    super.initState();
    final dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    _couponService = CouponService(dio);
    _eventsService = EventsService();
    _fetchEvents();
  }

  // ---------- Fetch Events ----------
  Future<void> _fetchEvents() async {
    setState(() => _isLoadingEvents = true);
    try {
      final organiserId = await AppPreferences.getOrganiserId();
      if (organiserId == null) {
        _showSnackBar('Organiser ID not found. Please login again.');
        return;
      }
      final response = await _eventsService.getEvents(
        organiserId: organiserId,
        status: 'all',
        limit: 100,
      );
      setState(() {
        _events = response.data;
        _isLoadingEvents = false;
      });
    } catch (e) {
      setState(() => _isLoadingEvents = false);
      _showSnackBar('Failed to load events: ${e.toString()}');
    }
  }

  // ---------- Submit Coupon ----------
  Future<void> _submitCoupon() async {
    if (_codeController.text.trim().isEmpty) {
      _showSnackBar('Please enter Coupon Code');
      return;
    }
    if (_discountValController.text.trim().isEmpty) {
      _showSnackBar('Please enter Discount value');
      return;
    }
    if (_usageLimitController.text.trim().isEmpty) {
      _showSnackBar('Please enter Usage Limit');
      return;
    }
    if (_startDateController.text.trim().isEmpty) {
      _showSnackBar('Please select Start Date');
      return;
    }
    if (_expiryDateController.text.trim().isEmpty) {
      _showSnackBar('Please select Expiry Date');
      return;
    }
    if (_selectedApplicableType == 'specific' && _selectedEvent == null) {
      _showSnackBar('Please select an Event');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final discountType = _selectedDiscountType == 'Percentage' ? 'percentage' : 'flat';
      final discountValue = int.tryParse(_discountValController.text.trim()) ?? 0;
      final usageLimit = int.tryParse(_usageLimitController.text.trim()) ?? 0;
      final perUserLimit = int.tryParse(_perUserController.text.trim()) ?? 1;

      final applicableEventType = _selectedApplicableType;
      int? applicableEventId;
      if (_selectedApplicableType == 'specific' && _selectedEvent != null) {
        applicableEventId = _selectedEvent!.id;
      }

      final request = CouponRequest(
        couponCode: _codeController.text.trim(),
        couponName: 'Coupon - ${_codeController.text.trim()}',
        description: 'Discount coupon',
        discountType: discountType,
        discountValue: discountValue,
        usageLimit: usageLimit,
        perUserLimit: perUserLimit,
        applicableEventType: applicableEventType,
        applicableEventId: applicableEventId,
        startDate: _startDateController.text.trim(),
        expiryDate: _expiryDateController.text.trim(),
      );

      await _couponService.createCoupon(request: request);

      _showSnackBar('Coupon created successfully!', isError: false);
      Navigator.pop(context, true);
    } catch (e) {
      _showSnackBar(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ---------- Open Searchable Event Bottom Sheet ----------
  void _showEventSearchBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _EventSearchBottomSheet(
          events: _events,
          selectedEvent: _selectedEvent,
          onEventSelected: (event) {
            setState(() {
              _selectedEvent = event;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  // ---------- Build UI ----------
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Create Coupon', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                    child: const Icon(Icons.close, size: 18, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Coupon Code
            _buildLabel('Coupon Code'),
            const SizedBox(height: 6),
            _buildTextField(controller: _codeController, hintText: 'e.g. EARLYBIRD20'),
            const SizedBox(height: 14),

            // Discount Type Toggle
            _buildLabel('Discount Type'),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedDiscountType = 'Percentage'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedDiscountType == 'Percentage' ? const Color(0xFFFF3B30) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '% Percentage',
                            style: TextStyle(
                              color: _selectedDiscountType == 'Percentage' ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedDiscountType = 'Flat Amount'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedDiscountType == 'Flat Amount' ? const Color(0xFFFF3B30) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '₹ Flat Amount',
                            style: TextStyle(
                              color: _selectedDiscountType == 'Flat Amount' ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Discount Value
            _buildLabel(_selectedDiscountType == 'Percentage' ? 'Discount %' : 'Discount Amount (₹)'),
            const SizedBox(height: 6),
            _buildTextField(controller: _discountValController, hintText: 'e.g. 20', keyboardType: TextInputType.number),
            const SizedBox(height: 14),

            // Usage Limit & Per User
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Usage Limit'),
                      const SizedBox(height: 6),
                      _buildTextField(controller: _usageLimitController, hintText: 'e.g. 200', keyboardType: TextInputType.number),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Per User'),
                      const SizedBox(height: 6),
                      _buildTextField(controller: _perUserController, hintText: '1', keyboardType: TextInputType.number),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Start Date & Expiry Date
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Start Date'),
                      const SizedBox(height: 6),
                      _buildTextField(
                        controller: _startDateController,
                        readOnly: true,
                        onTap: () => _selectDate(context, _startDateController),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Expiry Date'),
                      const SizedBox(height: 6),
                      _buildTextField(
                        controller: _expiryDateController,
                        readOnly: true,
                        onTap: () => _selectDate(context, _expiryDateController),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ---------- Applicable Event Dropdown (Improved) ----------
            _buildLabel('Applicable Event'),
            const SizedBox(height: 6),
            _buildDropdownContainer(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedApplicableType,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
                  style: const TextStyle(color: Colors.black87, fontSize: 13),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Events')),
                    DropdownMenuItem(value: 'specific', child: Text('Specific Event')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedApplicableType = val;
                        if (val == 'all') _selectedEvent = null;
                      });
                    }
                  },
                ),
              ),
              prefixIcon: Icons.event,
            ),

            // ---------- Event Selector (Searchable) ----------
            if (_selectedApplicableType == 'specific') ...[
              const SizedBox(height: 12),
              _buildLabel('Select Event'),
              const SizedBox(height: 6),
              _isLoadingEvents
                  ? const Center(child: SizedBox(height: 40, child: CircularProgressIndicator()))
                  : _events.isEmpty
                      ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Center(
                            child: Text(
                              'No events found. Please create an event first.',
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ),
                        )
                      : _buildSearchableEventSelector(),
            ],

            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitCoupon,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3B30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Save & Review Details',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Searchable Event Selector Widget ----------
  Widget _buildSearchableEventSelector() {
    return GestureDetector(
      onTap: _showEventSearchBottomSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.event_note, size: 18, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _selectedEvent != null ? _selectedEvent!.title : 'Select an Event',
                style: TextStyle(
                  color: _selectedEvent != null ? Colors.black87 : Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ),
            const Icon(Icons.search, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ---------- UI Helpers ----------
  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  // ---------- Dropdown Container with Prefix Icon ----------
  Widget _buildDropdownContainer({
    required Widget child,
    required IconData prefixIcon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(prefixIcon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(child: child),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }
}

// ============================================================================
// Separate Widget for Searchable Event Bottom Sheet
// ============================================================================
class _EventSearchBottomSheet extends StatefulWidget {
  final List<EventData> events;
  final EventData? selectedEvent;
  final Function(EventData) onEventSelected;

  const _EventSearchBottomSheet({
    required this.events,
    this.selectedEvent,
    required this.onEventSelected,
  });

  @override
  State<_EventSearchBottomSheet> createState() => _EventSearchBottomSheetState();
}

class _EventSearchBottomSheetState extends State<_EventSearchBottomSheet> {
  String _searchQuery = '';
  List<EventData> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _filteredEvents = widget.events;
  }

  void _filterEvents(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredEvents = widget.events;
      } else {
        _filteredEvents = widget.events
            .where((event) =>
                event.title.toLowerCase().contains(query.toLowerCase()) ||
                event.id.toString().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Select an Event',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search events...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: _filterEvents,
            ),
          ),
          const SizedBox(height: 12),
          // List
          Expanded(
            child: _filteredEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off, size: 48, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No events available'
                              : 'No events found for "$_searchQuery"',
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = _filteredEvents[index];
                      final isSelected = widget.selectedEvent?.id == event.id;
                      return ListTile(
                        title: Text(
                          event.title,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? const Color(0xFFFF3B30) : Colors.black87,
                          ),
                        ),
                        subtitle: Text('ID: ${event.id}'),
                        leading: isSelected
                            ? const Icon(Icons.check_circle, color: Color(0xFFFF3B30))
                            : const Icon(Icons.event, color: Colors.grey),
                        onTap: () => widget.onEventSelected(event),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}