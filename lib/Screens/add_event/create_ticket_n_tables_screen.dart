import 'package:fizmaa/Screens/add_event/add_venue_slot.dart' hide VenueOption;
import 'package:fizmaa/Screens/add_event/add_volunteer/voluteer_list_screen.dart';
import 'package:fizmaa/Screens/add_event/create_table_screen.dart';
import 'package:fizmaa/Screens/add_event/create_ticket/create_ticket.dart';
import 'package:fizmaa/Screens/add_event/event_slot.dart';
import 'package:fizmaa/models_n_services/venue_list/venue_list_model.dart';
import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';

class CreateTicketsScreen extends StatefulWidget {
  final int eventId;
  final int organiserId;
  final List<VenueWithSlots> venuesWithSlots;

  const CreateTicketsScreen({
    super.key,
    required this.eventId,
    required this.organiserId,
    required this.venuesWithSlots,
  });

  @override
  State<CreateTicketsScreen> createState() => _CreateTicketsScreenState();
}

class _CreateTicketsScreenState extends State<CreateTicketsScreen> {
  int _activeVenueIndex = 0;
  String _selectedSessionFilter = '';
  int _selectedSlotId = 0;
  int _selectedTabIndex = 0;

  // ✅ Returns only real slots (no "All Sessions")
  List<MapEntry<String, int>> get _slotFilters {
    if (widget.venuesWithSlots.isEmpty) return [];
    final slots = widget.venuesWithSlots[_activeVenueIndex].slots;
    // ✅ Only include slots with non-null id
    return slots.where((s) => s.id != null).map((s) => MapEntry(s.title, s.id!)).toList();
  }

  late List<List<TicketTier>> _venueTickets;
  late List<List<TableTier>> _venueTables;

  @override
  void initState() {
    super.initState();
    final venueCount = widget.venuesWithSlots.length;
    _venueTickets = List.generate(venueCount, (_) => []);
    _venueTables = List.generate(venueCount, (_) => []);
    // Default to first slot
    final filters = _slotFilters;
    if (filters.isNotEmpty) {
      _selectedSlotId = filters.first.value;
      _selectedSessionFilter = filters.first.key;
    }
  }

  void _addTicket(TicketTier ticket) {
    setState(() {
      _venueTickets[_activeVenueIndex].add(ticket);
    });
  }

  void _addTable(TableTier table) {
    setState(() {
      _venueTables[_activeVenueIndex].add(table);
    });
  }

  void _toggleTicketActive(int venueIndex, int ticketIndex) {
    setState(() {
      _venueTickets[venueIndex][ticketIndex].isActive =
          !_venueTickets[venueIndex][ticketIndex].isActive;
    });
  }

  void _toggleTableActive(int venueIndex, int tableIndex) {
    setState(() {
      _venueTables[venueIndex][tableIndex].isActive =
          !_venueTables[venueIndex][tableIndex].isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.venuesWithSlots.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('No venues selected. Please go back and add venues.'),
        ),
      );
    }

    final activeVenueData = widget.venuesWithSlots[_activeVenueIndex];
    final activeVenue = activeVenueData.venue;
    final currentTickets = _venueTickets[_activeVenueIndex];
    final currentTables = _venueTables[_activeVenueIndex];

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
                    const Text(
                      'CONFIGURE TICKETS FOR VENUE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4A4A4A),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildVenueSelectorList(),
                    const SizedBox(height: 20),

                    const Text(
                      'SLOT / SESSION (OPTIONAL)',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4A4A4A),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildSessionFilterChips(),
                    const SizedBox(height: 12),

                    _buildVenueSessionBadge(activeVenue),
                    const SizedBox(height: 16),

                    _buildInventoryCard(
                      activeVenue,
                      currentTickets,
                      currentTables,
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  // ---------- Header ----------
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

  // ---------- Progress Bar ----------
  Widget _buildProgressBar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(6, (index) {
              bool isCompleted = index < 5;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index == 5 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.kRed : const Color(0xFFFFE0E0),
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
                'Step 5 of 6',
                style: TextStyle(fontSize: 11, color: AppColors.kHint),
              ),
              Text(
                'Inventory',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.kRed),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- Venue Selector ----------
  Widget _buildVenueSelectorList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.venuesWithSlots.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final venueData = widget.venuesWithSlots[index];
        final venue = venueData.venue;
        final isActive = _activeVenueIndex == index;
        final city = venue.city ?? 'Unknown Location';

        return GestureDetector(
          onTap: () {
            setState(() {
              _activeVenueIndex = index;
              final filters = _slotFilters;
              if (filters.isNotEmpty) {
                _selectedSlotId = filters.first.value;
                _selectedSessionFilter = filters.first.key;
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive ? AppColors.kRed : const Color(0xFFF0F0F0),
                width: isActive ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEAEA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.park, color: Color(0xFF558B2F), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        venue.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.kTextDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$city · Cap. ${venue.capacity}',
                        style: const TextStyle(fontSize: 11.5, color: AppColors.kHint),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          venue.type ?? 'Venue',
                          style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0084FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.check, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Active',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------- Session Filter Chips ----------
  Widget _buildSessionFilterChips() {
    final filters = _slotFilters;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((entry) {
          final filter = entry.key;
          final slotId = entry.value;
          final isSelected = _selectedSessionFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedSessionFilter = filter;
                  _selectedSlotId = slotId;
                });
              },
              selectedColor: AppColors.kRed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              pressElevation: 0,
              side: BorderSide.none,
              labelStyle: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF757575),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---------- Venue Session Badge ----------
  Widget _buildVenueSessionBadge(VenueOption venue) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF0084FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.location_on, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${venue.name} - $_selectedSessionFilter',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0066CC),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Main Inventory Card ----------
  Widget _buildInventoryCard(
    VenueOption activeVenue,
    List<TicketTier> tickets,
    List<TableTier> tables,
  ) {
    final isTicketTab = _selectedTabIndex == 0;
    final items = isTicketTab ? tickets : tables;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Segmented Control
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTabIndex = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedTabIndex == 0 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _selectedTabIndex == 0
                            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          'Tickets',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: _selectedTabIndex == 0 ? AppColors.kRed : const Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTabIndex = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedTabIndex == 1 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _selectedTabIndex == 1
                            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          'Tables',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: _selectedTabIndex == 1 ? AppColors.kRed : const Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isTicketTab ? 'Tickets' : 'Tables',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kTextDark,
                ),
              ),
              InkWell(
                onTap: () async {
                  if (isTicketTab) {
                    final ticket = await showCreateTicketBottomSheet(
                      context,
                      eventId: widget.eventId,
                      venueId: activeVenue.id,
                      slotId: _selectedSlotId,
                      capacity: activeVenue.capacity,
                    );
                    if (ticket != null) _addTicket(ticket);
                  } else {
                    final table = await showCreateTableBottomSheet(
                      context,
                      activeVenue.capacity,
                    );
                    if (table != null) _addTable(table);
                  }
                },
                child: Text(
                  isTicketTab ? '+ Add Ticket Tier' : '+ Add Table Tier',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (items.isEmpty)
            _buildEmptyState(activeVenue, isTicketTab)
          else
            Column(
              children: [
                ...items.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final item = entry.value;
                  if (isTicketTab) {
                    return _buildTicketCard(
                      item as TicketTier,
                      idx,
                      activeVenue,
                    );
                  } else {
                    return _buildTableCard(
                      item as TableTier,
                      idx,
                      activeVenue,
                    );
                  }
                }).toList(),
              ],
            ),
        ],
      ),
    );
  }

  // ---------- Empty State ----------
  Widget _buildEmptyState(VenueOption activeVenue, bool isTicket) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFC2C2), width: 1, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEAEA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isTicket ? Icons.confirmation_number_outlined : Icons.table_restaurant_outlined,
              color: AppColors.kRed,
              size: 24,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            isTicket ? 'No ticket tiers yet' : 'No table tiers yet',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.kTextDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Create your first ${isTicket ? "ticket" : "table"} tier for ${activeVenue.name}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: AppColors.kHint),
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: () async {
              if (isTicket) {
                final ticket = await showCreateTicketBottomSheet(
                  context,
                  eventId: widget.eventId,
                  venueId: activeVenue.id,
                  slotId: _selectedSlotId,
                  capacity: activeVenue.capacity,
                );
                if (ticket != null) _addTicket(ticket);
              } else {
                final table = await showCreateTableBottomSheet(
                  context,
                  activeVenue.capacity,
                );
                if (table != null) _addTable(table);
              }
            },
            child: Text(
              isTicket ? '+ Add Ticket Tier' : '+ Add Table Tier',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.kRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Ticket Card ----------
  Widget _buildTicketCard(TicketTier ticket, int index, VenueOption venue) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ticket.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kTextDark,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: ticket.isActive ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ticket.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: ticket.isActive ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _toggleTicketActive(_activeVenueIndex, index),
                    child: Icon(
                      ticket.isActive ? Icons.toggle_on : Icons.toggle_off,
                      color: ticket.isActive ? AppColors.kRed : Colors.grey,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _infoChip(
                icon: Icons.currency_rupee,
                label: 'Price',
                value: '${ticket.price}',
              ),
              const SizedBox(width: 12),
              _infoChip(
                icon: Icons.confirmation_number,
                label: 'Total',
                value: '${ticket.totalTickets}',
              ),
              const SizedBox(width: 12),
              _infoChip(
                icon: Icons.person,
                label: 'Max per Person',
                value: '${ticket.maxPerPerson}',
              ),
            ],
          ),
          if (ticket.isFree)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                'Free Ticket',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ),
          if (ticket.isDynamicPricing)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Dynamic Pricing Enabled',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.kHint,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------- Table Card ----------
  Widget _buildTableCard(TableTier table, int index, VenueOption venue) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                table.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kTextDark,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: table.isActive ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      table.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: table.isActive ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _toggleTableActive(_activeVenueIndex, index),
                    child: Icon(
                      table.isActive ? Icons.toggle_on : Icons.toggle_off,
                      color: table.isActive ? AppColors.kRed : Colors.grey,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _infoChip(
                icon: Icons.currency_rupee,
                label: 'Price',
                value: '${table.price}',
              ),
              const SizedBox(width: 12),
              _infoChip(
                icon: Icons.table_restaurant,
                label: 'Total',
                value: '${table.totalTables}',
              ),
              const SizedBox(width: 12),
              _infoChip(
                icon: Icons.person,
                label: 'Max per Person',
                value: '${table.maxPerPerson}',
              ),
            ],
          ),
          if (table.reservationEnabled)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Reservation Enabled',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.kHint,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------- Info Chip ----------
  Widget _infoChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.kHint),
          const SizedBox(width: 4),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.kHint,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.kTextDark,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Bottom Button ----------
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AssignVolunteersScreen(
                  eventId: widget.eventId,
                  organiserId: widget.organiserId,
                  venues: widget.venuesWithSlots,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.kRed,
            foregroundColor: AppColors.kWhite,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            'Save & Assign Volunteers',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}