import 'package:fizmaa/Screens/add_event/create_ticket/PreviewTicketScreen.dart';
import 'package:fizmaa/models_n_services/create_ticket_model.dart/create_ticket_model.dart';
import 'package:fizmaa/models_n_services/create_ticket_model.dart/create_ticket_svc.dart';
import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';

// ---------- Ticket Data Model ----------
class TicketTier {
  final String id;
  final String name;
  final int totalTickets;
  final double price;
  final int maxPerPerson;
  bool isActive;
  final bool isFree;
  final bool isDynamicPricing;
  final String ageRestriction;
  final int? minTickets;
  final int? maxTickets;

  TicketTier({
    required this.id,
    required this.name,
    required this.totalTickets,
    required this.price,
    required this.maxPerPerson,
    this.isActive = true,
    this.isFree = false,
    this.isDynamicPricing = false,
    this.ageRestriction = 'All Ages',
    this.minTickets,
    this.maxTickets,
  });
}

// Model for Additional Information field
class _AdditionalField {
  final TextEditingController fieldNameController = TextEditingController();
  final TextEditingController maxLengthController =
      TextEditingController(text: '1');
  bool mandatory = true;
  bool numbersOnly = false;
  bool lettersSigns = false;
  bool boolean = false;
  bool limitLength = false;
  static const int maxCharacterLimit = 500;
}

// ---------- Function to show bottom sheet (updated signature) ----------
Future<TicketTier?> showCreateTicketBottomSheet(
   BuildContext context, {
  required int eventId,
  required int venueId,
  required int slotId,   // non-nullable
  required int capacity,
}) {
  return showModalBottomSheet<TicketTier>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => CreateTicketBottomSheet(
      eventId: eventId,
      venueId: venueId,
      slotId: slotId,
      capacity: capacity,
    ),
  );
}

// ---------- Bottom Sheet Widget ----------
class CreateTicketBottomSheet extends StatefulWidget {
  final int eventId;
  final int venueId;
  final int slotId; 
  final int capacity;

  const CreateTicketBottomSheet({
    super.key,
    required this.eventId,
    required this.venueId,
    required this.slotId,
    required this.capacity,
  });

  @override
  State<CreateTicketBottomSheet> createState() =>
      _CreateTicketBottomSheetState();
}

class _CreateTicketBottomSheetState extends State<CreateTicketBottomSheet> {
  final TextEditingController ticketNameController =
      TextEditingController(text: 'VIP PASS');
  final TextEditingController totalTicketsController =
      TextEditingController(text: '1');
  final TextEditingController ticketPriceController =
      TextEditingController(text: '500');
  final TextEditingController maxPersonsController =
      TextEditingController(text: '1');
  late final TextEditingController eventCapacityController;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController belowThresholdController =
      TextEditingController(text: '10');
  final TextEditingController increaseByController =
      TextEditingController(text: '5');
  final TextEditingController advancePercentController =
      TextEditingController(text: '50');
  final TextEditingController eventStartController =
      TextEditingController(text: '2026-08-24 10:00:00');
  final TextEditingController eventEndController =
      TextEditingController(text: '2026-09-30 23:59:59');
  final TextEditingController minTicketsController =
      TextEditingController(text: '1');
  final TextEditingController maxTicketsController =
      TextEditingController(text: '200');

  final List<Map<String, TextEditingController>> guestControllers = [
    {
      'mobile': TextEditingController(text: '9876543210'),
      'name': TextEditingController(text: 'Guest 1'),
      'email': TextEditingController(text: 'guest1@gmail.com'),
    }
  ];

  bool maxPersonsToggle = false;
  bool dynamicPricing = true;
  bool advancePayment = true;
  bool ticketActive = true;
  bool freeTicket = false;

  bool additionalInfoToggle = false;
  final List<_AdditionalField> additionalFields = [_AdditionalField()];

  int maleCount = 0;
  int femaleCount = 0;
  int otherCount = 0;

  final List<Map<String, TextEditingController>> addOns = [
    {'title': TextEditingController(text: 'Food Coupon'), 'price': TextEditingController(text: '100')},
    {'title': TextEditingController(text: 'Parking Pass'), 'price': TextEditingController(text: '50')},
  ];

  String _selectedAgeRestriction = 'All Ages';
  final List<String> _ageOptions = ['All Ages', '5+', '18+', '21+'];

  static const int _descriptionMaxLength = 300;
  int _descriptionLength = 0;

  // ---------- API Service ----------
  final CreateTicketService _ticketService = CreateTicketService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    eventCapacityController =
        TextEditingController(text: widget.capacity.toString());
    descriptionController.addListener(_updateDescriptionLength);
    _updateDescriptionLength();
  }

  void _updateDescriptionLength() {
    setState(() {
      _descriptionLength = descriptionController.text.length;
    });
  }

  @override
  void dispose() {
    ticketNameController.dispose();
    totalTicketsController.dispose();
    ticketPriceController.dispose();
    maxPersonsController.dispose();
    eventCapacityController.dispose();
    descriptionController.dispose();
    belowThresholdController.dispose();
    increaseByController.dispose();
    advancePercentController.dispose();
    eventStartController.dispose();
    eventEndController.dispose();
    minTicketsController.dispose();
    maxTicketsController.dispose();
    for (var guest in guestControllers) {
      guest['mobile']!.dispose();
      guest['name']!.dispose();
      guest['email']!.dispose();
    }
    for (final a in addOns) {
      a['title']!.dispose();
      a['price']!.dispose();
    }
    for (final f in additionalFields) {
      f.fieldNameController.dispose();
      f.maxLengthController.dispose();
    }
    super.dispose();
  }

  // ---------- Submit Ticket API Call ----------
  Future<void> _submitTicket() async {
    // Basic validations
    if (ticketNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter ticket name')),
      );
      return;
    }
    final totalTickets = int.tryParse(totalTicketsController.text.trim()) ?? 0;
    if (totalTickets <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Total tickets must be greater than 0')),
      );
      return;
    }
    final price = double.tryParse(ticketPriceController.text.trim()) ?? 0.0;
    if (!freeTicket && price < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Price cannot be negative')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Build guest list
    final guestList = guestControllers
        .where((g) => g['mobile']!.text.trim().isNotEmpty)
        .map((g) => Guest(
              mobile: g['mobile']!.text.trim(),
              name: g['name']!.text.trim(),
              email: g['email']!.text.trim(),
            ))
        .toList();

    // Build addons
    final addons = addOns
        .where((a) =>
            a['title']!.text.trim().isNotEmpty &&
            int.tryParse(a['price']!.text.trim()) != null)
        .map((a) => Addon(
              title: a['title']!.text.trim(),
              price: int.parse(a['price']!.text.trim()),
            ))
        .toList();

    // Build additional info fields
    final additionalInfo = additionalFields
        .where((f) => f.fieldNameController.text.trim().isNotEmpty)
        .map((f) => AdditionalInfo(
              fieldName: f.fieldNameController.text.trim(),
              mandatory: f.mandatory,
              numbersOnly: f.numbersOnly,
              lettersAndSigns: f.lettersSigns,
              boolean: f.boolean,
              limitLength: f.limitLength
                  ? int.tryParse(f.maxLengthController.text) ?? 1
                  : 0,
            ))
        .toList();

    final request = CreateTicketRequest(
      eventId: widget.eventId,
      venueId: widget.venueId,
      slotId: widget.slotId,
      ticketName: ticketNameController.text.trim(),
      freeTicket: freeTicket,
      totalTickets: totalTickets,
      ticketPrice: price.toInt(),
      maxPersonsEnabled: maxPersonsToggle,
      maxPersonsPerTicket: int.tryParse(maxPersonsController.text) ?? 1,
      eventCapacity: widget.capacity,
      ageRestriction: _selectedAgeRestriction,
      maleAllocation: maleCount,
      femaleAllocation: femaleCount,
      otherAllocation: otherCount,
      description: descriptionController.text.trim(),
      dynamicPricingEnabled: dynamicPricing,
      dynamicThreshold: int.tryParse(belowThresholdController.text) ?? 10,
      dynamicIncreasePercentage: int.tryParse(increaseByController.text) ?? 5,
      advancePaymentEnabled: advancePayment,
      advancePercentage: advancePayment
          ? int.tryParse(advancePercentController.text)
          : null,
      availabilityStart: eventStartController.text.trim(),
      availabilityEnd: eventEndController.text.trim(),
      minTickets: int.tryParse(minTicketsController.text) ?? 1,
      maxTickets: int.tryParse(maxTicketsController.text) ?? 200,
      guestListEnabled: guestList.isNotEmpty,
      guestList: guestList,
      addons: addons,
      additionalInfoEnabled: additionalInfo.isNotEmpty,
      additionalInfo: additionalInfo,
      isActive: ticketActive,
    );

    try {
      final response = await _ticketService.createTicket(request);
      if (!mounted) return;

      if (response.success) {
        // Create TicketTier object to return
        final ticket = TicketTier(
          id: response.data.ticketId.toString(),
          name: response.data.ticketName,
          totalTickets: response.data.totalTickets,
          price: response.data.ticketPrice.toDouble(),
          maxPerPerson: request.maxPersonsPerTicket,
          isActive: ticketActive,
          isFree: freeTicket,
          isDynamicPricing: dynamicPricing,
          ageRestriction: _selectedAgeRestriction,
          minTickets: request.minTickets,
          maxTickets: request.maxTickets,
        );
        Navigator.pop(context, ticket);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.message}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.80,
          decoration: AppColors.screenGradient,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              _buildTopBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(
                          Icons.confirmation_number_outlined, 'Ticket Details'),
                      const SizedBox(height: 14),

                      _label('Ticket Name'),
                      const SizedBox(height: 8),
                      _textField(
                        controller: ticketNameController,
                        trailingIcon: Icons.delete_outline,
                      ),
                      const SizedBox(height: 16),

                      _toggleRow(
                        label: 'Free Ticket',
                        value: freeTicket,
                        onChanged: (v) {
                          setState(() {
                            freeTicket = v;
                            if (freeTicket) ticketPriceController.text = '0';
                          });
                        },
                        subtitle: 'Make this ticket free of cost',
                      ),
                      const SizedBox(height: 8),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Total Tickets'),
                                const SizedBox(height: 8),
                                _textField(controller: totalTicketsController),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Ticket Price'),
                                const SizedBox(height: 8),
                                _textField(
                                  controller: ticketPriceController,
                                  prefixText: '₹ ',
                                  enabled: !freeTicket,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(Icons.warning_amber_rounded,
                              size: 14, color: AppColors.kRed),
                          SizedBox(width: 6),
                          Text(
                            'Maximum free ticket limit exceeded',
                            style: TextStyle(fontSize: 11.5, color: AppColors.kRed),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      Row(
                        children: const [
                          Icon(Icons.person_outline,
                              size: 16, color: AppColors.kTextDark),
                          SizedBox(width: 6),
                          Text(
                            'Event Capacity',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.kTextDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 46,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: AppColors.kChipBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.kBorder, width: 1.2),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          eventCapacityController.text,
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.kTextDark),
                        ),
                      ),
                      const SizedBox(height: 18),

                      _toggleRow(
                        icon: Icons.person_outline,
                        label: 'Max Persons per Ticket',
                        value: maxPersonsToggle,
                        onChanged: (v) => setState(() => maxPersonsToggle = v),
                      ),
                      const SizedBox(height: 8),
                      _textField(controller: maxPersonsController),
                      const SizedBox(height: 18),

                      _guestListCard(),
                      const SizedBox(height: 18),

                      _label('Age Restriction'),
                      const SizedBox(height: 8),
                      _ageRestrictionDropdown(),
                      const SizedBox(height: 18),

                      Center(child: _label('Gender Allocation(optional)')),
                      const SizedBox(height: 10),
                      _genderAllocationCard(),
                      const SizedBox(height: 18),

                      _label('Description'),
                      const SizedBox(height: 8),
                      _descriptionBox(),
                      const SizedBox(height: 20),

                      _toggleRow(
                        label: 'Dynamic Pricing',
                        value: dynamicPricing,
                        bold: true,
                        onChanged: (v) => setState(() => dynamicPricing = v),
                        subtitle:
                            'Automatically increase ticket price when availability becomes low.',
                      ),
                      const SizedBox(height: 14),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('When tickets left below'),
                                const SizedBox(height: 8),
                                _textField(controller: belowThresholdController),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Increase by'),
                                const SizedBox(height: 8),
                                _textField(
                                    controller: increaseByController,
                                    suffixText: '%'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _dynamicPricingSummaryCard(),
                      const SizedBox(height: 20),

                      _sectionHeader(Icons.event_available_outlined, 'Availability',
                          muted: true),
                      const SizedBox(height: 14),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Event Start'),
                                const SizedBox(height: 8),
                                _textField(
                                  controller: eventStartController,
                                  trailingIcon: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Event End'),
                                const SizedBox(height: 8),
                                _textField(
                                  controller: eventEndController,
                                  trailingIcon: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Min Tickets'),
                                const SizedBox(height: 8),
                                _textField(controller: minTicketsController),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Max Tickets'),
                                const SizedBox(height: 8),
                                _textField(controller: maxTicketsController),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      _addOnCard(),
                      const SizedBox(height: 18),

                      _additionalInfoSection(),
                      const SizedBox(height: 18),

                      const Divider(color: AppColors.kBorder, height: 1),
                      const SizedBox(height: 16),

                      _toggleRow(
                        label: 'Ticket Active',
                        value: ticketActive,
                        bold: true,
                        onChanged: (v) => setState(() => ticketActive = v),
                        subtitle: 'Visible to users for purchase',
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              _buildBottomButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Top Bar ----------
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            child: Text(
              'Create Tickets',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.kTextDark,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 3),
                Text(
                  'For Wed, 29 Jan 2025 | 03:58PM',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.kTextDark.withOpacity(0.45),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Close',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kTextDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Section header ----------
  Widget _sectionHeader(IconData icon, String text, {bool muted = false}) {
    final color = muted ? AppColors.kTextDark.withOpacity(0.55) : AppColors.kRed;
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: muted ? AppColors.kTextDark.withOpacity(0.7) : AppColors.kTextDark,
          ),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.kTextDark,
      ),
    );
  }

  // ---------- Generic text field ----------
  Widget _textField({
    required TextEditingController controller,
    String? prefixText,
    String? suffixText,
    IconData? trailingIcon,
    bool enabled = true,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: enabled ? AppColors.kWhite : AppColors.kChipBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          if (prefixText != null)
            Text(prefixText,
                style: const TextStyle(fontSize: 14, color: AppColors.kTextDark)),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              keyboardType: keyboardType,
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(fontSize: 14, color: AppColors.kTextDark),
            ),
          ),
          if (suffixText != null)
            Text(suffixText,
                style: const TextStyle(fontSize: 14, color: AppColors.kTextDark)),
          if (trailingIcon != null) ...[
            const SizedBox(width: 6),
            Icon(trailingIcon, size: 17, color: AppColors.kRed),
          ],
        ],
      ),
    );
  }

  // ---------- Age Restriction Dropdown ----------
  Widget _ageRestrictionDropdown() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedAgeRestriction,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.kHint),
          items: _ageOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value,
                  style: const TextStyle(fontSize: 14, color: AppColors.kTextDark)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedAgeRestriction = newValue!;
            });
          },
        ),
      ),
    );
  }

  // ---------- Toggle row ----------
  Widget _toggleRow({
    IconData? icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? subtitle,
    bool bold = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: AppColors.kTextDark),
              const SizedBox(width: 6),
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: bold ? 14.5 : 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kTextDark,
                ),
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.kRed,
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
                fontSize: 11.5, color: AppColors.kTextDark.withOpacity(0.5)),
          ),
        ],
      ],
    );
  }

  // ---------- Gender allocation card ----------
  Widget _genderAllocationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: Column(
        children: [
          _genderRow(
            icon: Icons.male,
            iconBg: const Color(0xFF4472D8),
            label: 'Male',
            count: maleCount,
            onDecrement: () =>
                setState(() => maleCount = (maleCount - 1).clamp(0, 999)),
            onIncrement: () => setState(() => maleCount++),
          ),
          const Divider(height: 1, color: AppColors.kBorder),
          _genderRow(
            icon: Icons.female,
            iconBg: AppColors.primaryRedDark,
            label: 'Female',
            count: femaleCount,
            onDecrement: () =>
                setState(() => femaleCount = (femaleCount - 1).clamp(0, 999)),
            onIncrement: () => setState(() => femaleCount++),
          ),
          const Divider(height: 1, color: AppColors.kBorder),
          _genderRow(
            icon: Icons.transgender,
            iconBg: const Color(0xFF3E8E5B),
            label: 'Other',
            count: otherCount,
            onDecrement: () =>
                setState(() => otherCount = (otherCount - 1).clamp(0, 999)),
            onIncrement: () => setState(() => otherCount++),
          ),
        ],
      ),
    );
  }

  Widget _genderRow({
    required IconData icon,
    required Color iconBg,
    required String label,
    required int count,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: AppColors.kWhite),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kTextDark),
            ),
          ),
          _counterButton(icon: Icons.remove, onTap: onDecrement),
          SizedBox(
            width: 28,
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kTextDark),
            ),
          ),
          _counterButton(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }

  Widget _counterButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.kBorder, width: 1.2),
        ),
        child: Icon(icon, size: 14, color: AppColors.kTextDark.withOpacity(0.6)),
      ),
    );
  }

  // ---------- Description box ----------
  Widget _descriptionBox() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: descriptionController,
            maxLines: 3,
            maxLength: _descriptionMaxLength,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: "What's included in this ticket...",
              hintStyle: TextStyle(color: AppColors.kHint, fontSize: 13.5),
              counterText: '',
            ),
            style: const TextStyle(fontSize: 13.5, color: AppColors.kTextDark),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '$_descriptionLength / $_descriptionMaxLength',
              style: TextStyle(
                fontSize: 12,
                color: _descriptionLength > _descriptionMaxLength
                    ? AppColors.kRed
                    : AppColors.kHint,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Dynamic pricing summary ----------
  Widget _dynamicPricingSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kPinkLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Price:',
                    style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.kTextDark.withOpacity(0.6))),
                const SizedBox(height: 4),
                Text(
                  '₹ ${ticketPriceController.text.isEmpty ? '0' : ticketPriceController.text}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.kRed),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward, color: AppColors.kRed, size: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Triggered Price:',
                    style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.kTextDark.withOpacity(0.6))),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      '₹ 525',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.kRed),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.kRed,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Auto Applied',
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.kWhite),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Guest List Card ----------
  Widget _guestListCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Guest List',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.kTextDark),
          ),
          const SizedBox(height: 14),
          ...guestControllers.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, TextEditingController> guest = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.kChipBg.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.kBorder, width: 0.5),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Mobile Number'),
                  const SizedBox(height: 6),
                  _textField(
                    controller: guest['mobile']!,
                    keyboardType: TextInputType.phone,
                    prefixText: '+91 ',
                  ),
                  const SizedBox(height: 12),
                  _label('Guest Name'),
                  const SizedBox(height: 6),
                  _textField(
                    controller: guest['name']!,
                  ),
                  const SizedBox(height: 12),
                  _label('Email (optional)'),
                  const SizedBox(height: 6),
                  _textField(
                    controller: guest['email']!,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        if (guestControllers.length > 1) {
                          setState(() {
                            guest['mobile']!.dispose();
                            guest['name']!.dispose();
                            guest['email']!.dispose();
                            guestControllers.removeAt(index);
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.kRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.delete_outline,
                                color: AppColors.kRed, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Remove',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.kRed),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  int next = guestControllers.length + 1;
                  guestControllers.add({
                    'mobile': TextEditingController(text: ''),
                    'name': TextEditingController(text: 'Guest $next'),
                    'email': TextEditingController(text: ''),
                  });
                });
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.kWhite,
                side: const BorderSide(color: AppColors.kRed, width: 1.3),
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.add, size: 16, color: AppColors.kRed),
              label: const Text(
                'Add Guest',
                style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kRed),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Add-on card ----------
  Widget _addOnCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add-on',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.kTextDark),
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(
                child: Text('Title',
                    style: TextStyle(fontSize: 12, color: AppColors.kHint)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text('Price (₹)',
                    style: TextStyle(fontSize: 12, color: AppColors.kHint)),
              ),
              SizedBox(width: 38),
            ],
          ),
          const SizedBox(height: 8),
          ...addOns.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: _textField(controller: a['title']!),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _textField(controller: a['price']!),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        if (addOns.length > 1) {
                          setState(() => addOns.remove(a));
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.delete_outline,
                            color: AppColors.kRed, size: 20),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  addOns.add({
                    'title': TextEditingController(),
                    'price': TextEditingController(),
                  });
                });
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.kWhite,
                side: const BorderSide(color: AppColors.kRed, width: 1.3),
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.add, size: 16, color: AppColors.kRed),
              label: const Text(
                'Add More',
                style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kRed),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Additional Information ----------
  Widget _additionalInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Additional information',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.kTextDark),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Ask custom questions when a buyer selects this ticket type.',
                      style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.kTextDark.withOpacity(0.5)),
                    ),
                  ],
                ),
              ),
              Switch(
                value: additionalInfoToggle,
                onChanged: (v) => setState(() => additionalInfoToggle = v),
                activeColor: AppColors.kRed,
              ),
            ],
          ),
          if (additionalInfoToggle) ...[
            const SizedBox(height: 14),
            ...additionalFields.asMap().entries.map((entry) {
              return _additionalFieldCard(entry.key, entry.value);
            }).toList(),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    additionalFields.add(_AdditionalField());
                  });
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.kWhite,
                  side: const BorderSide(color: AppColors.kRed, width: 1.3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.add, size: 16, color: AppColors.kRed),
                label: const Text(
                  'Add field',
                  style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kRed),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _additionalFieldCard(int index, _AdditionalField field) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.kChipBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.kBorder, width: 0.5),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _label('Field name')),
              InkWell(
                onTap: () {
                  if (additionalFields.length > 1) {
                    setState(() {
                      field.fieldNameController.dispose();
                      additionalFields.removeAt(index);
                    });
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.delete_outline,
                      color: AppColors.kRed, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _textField(
            controller: field.fieldNameController,
          ),
          const SizedBox(height: 12),
          _toggleRow(
            label: 'Mandatory',
            value: field.mandatory,
            onChanged: (v) => setState(() => field.mandatory = v),
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _miniToggleChip(
                    label: 'Numbers only',
                    value: field.numbersOnly,
                    onChanged: (v) => setState(() => field.numbersOnly = v),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _miniToggleChip(
                    label: 'Letters & signs',
                    value: field.lettersSigns,
                    onChanged: (v) => setState(() => field.lettersSigns = v),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _miniToggleChip(
                    label: 'Boolean',
                    value: field.boolean,
                    onChanged: (v) => setState(() => field.boolean = v),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _miniToggleChip(
                    label: 'Limit length',
                    value: field.limitLength,
                    onChanged: (v) => setState(() => field.limitLength = v),
                  ),
                ),
              ],
            ),
          ),
          if (field.limitLength) ...[
            const SizedBox(height: 12),
            _textField(
              controller: field.maxLengthController,
              keyboardType: TextInputType.number,
              onChanged: (val) {
                final parsed = int.tryParse(val);
                if (parsed != null && parsed > _AdditionalField.maxCharacterLimit) {
                  final capped = _AdditionalField.maxCharacterLimit.toString();
                  field.maxLengthController.value = TextEditingValue(
                    text: capped,
                    selection: TextSelection.collapsed(offset: capped.length),
                  );
                }
              },
            ),
            const SizedBox(height: 4),
            Text(
              'Max characters',
              style: TextStyle(
                  fontSize: 11.5, color: AppColors.kTextDark.withOpacity(0.5)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _miniToggleChip({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            maxLines: 2,
            style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.kTextDark),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Transform.scale(
              scale: 0.8,
              alignment: Alignment.centerLeft,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.kRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Bottom Buttons (with API integration) ----------
  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.kWhite,
                  side: const BorderSide(color: AppColors.kRed, width: 1.4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.kRed),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitTicket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kRed,
                  foregroundColor: AppColors.kWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: AppColors.kWhite,
                        ),
                      )
                    : const Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.kWhite),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}