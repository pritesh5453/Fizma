import 'package:fizma/Screens/add_event/add_event_slot.dart';
import 'package:fizma/Screens/add_event/create_table_screen.dart';
import 'package:fizma/Screens/add_event/create_ticket/create_ticket.dart';
import 'package:fizma/Screens/add_event/create_ticket_n_tables_screen.dart';
import 'package:fizma/Screens/add_event/event_slot.dart';
import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';

// ---------- Data Model for Venue & its Specific Slots ----------
class VenueWithSlots {
  final VenueOption venue;
  final int capacity;
  final int? bufferCapacity;
  final List<EventSlot> slots;

  VenueWithSlots({
    required this.venue,
    required this.capacity,
    this.bufferCapacity,
    List<EventSlot>? slots,
  }) : slots = slots ?? [];
}

class VenueOption {
  final String name;
  final String city;
  const VenueOption({required this.name, required this.city});
}

const List<VenueOption> _venueOptions = [
  VenueOption(name: 'Manohar Garden', city: 'San Francisco, CA'),
  VenueOption(name: 'Shankra Banquet', city: 'New York, NY'),
  VenueOption(name: 'Siddhivinayak Community Hall', city: 'Nashik'),
];

class AddEventSlotScreen extends StatefulWidget {
  const AddEventSlotScreen({super.key});

  @override
  State<AddEventSlotScreen> createState() => _AddEventSlotScreenState();
}

class _AddEventSlotScreenState extends State<AddEventSlotScreen> {
  // Multiple Venues List
  final List<VenueWithSlots> venueList = [];

  // Open Bottom Sheet to Add a New Slot for a Specific Venue
  Future<void> _openAddEventSlotSheet(VenueWithSlots venueData) async {
    final result = await showModalBottomSheet<EventSlot>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEventSlotSheet(
        venueName: venueData.venue.name,
        venueCity: venueData.venue.city,
      ),
    );

    if (result != null) {
      setState(() {
        int pairNumber = (venueData.slots.length ~/ 2) + 1;
        venueData.slots.add(EventSlot(
          title: 'Event $pairNumber (Ticket)',
          date: result.date,
          startTime: result.startTime,
          endTime: result.endTime,
          capacity: result.capacity,
          actionLabel: 'Create Ticket',
        ));
        venueData.slots.add(EventSlot(
          title: 'Event $pairNumber (Table)',
          date: result.date,
          startTime: result.startTime,
          endTime: result.endTime,
          capacity: result.capacity,
          actionLabel: 'Create Table',
        ));
      });
    }
  }

  // Open Bottom Sheet to Select/Add a New Venue
  Future<void> _openVenueLocationSheet() async {
    final result = await showModalBottomSheet<VenueWithSlots>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _VenueLocationSheet(),
    );

    if (result != null) {
      setState(() {
        venueList.add(result);
      });
    }
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
                    _buildInfoNoticeCard(),
                    const SizedBox(height: 16),
                    
                    // Render list of all selected venues and their slots
                    if (venueList.isNotEmpty) ...[
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: venueList.length,
                        separatorBuilder: (_, __) => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(color: Color(0xFFFFD6D6), thickness: 1),
                        ),
                        itemBuilder: (context, index) {
                          return _buildVenueSection(venueList[index], index);
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Button to Add another Venue Location
                    _buildAddVenueButton(),
                  ],
                ),
              ),
            ),
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

  // ---------- Step Progress Bar ----------
  Widget _buildProgressBar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(6, (index) {
              bool isCompleted = index < 4;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index == 5 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.kRed : const Color(0xFFE5E7EB),
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
                'Step 4 of 6',
                style: TextStyle(fontSize: 11, color: AppColors.kHint),
              ),
              Text(
                'Sessions',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.kRed),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- Info Box ----------
  Widget _buildInfoNoticeCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF3FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.info, color: Color(0xFF1D61E0), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Sessions are optional. You can skip this step and create tickets directly without scheduling slots.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF1D61E0),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Add Venue Trigger Button ----------
  Widget _buildAddVenueButton() {
    return OutlinedButton.icon(
      onPressed: _openVenueLocationSheet,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        side: const BorderSide(color: AppColors.kRed, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: const Icon(Icons.add, size: 18, color: AppColors.kRed),
      label: Text(
        venueList.isEmpty ? 'Add Venue Location' : 'Add Another Venue Location',
        style: const TextStyle(color: AppColors.kRed, fontWeight: FontWeight.w600),
      ),
    );
  }

  // ---------- Venue Block & Slots Listing ----------
  Widget _buildVenueSection(VenueWithSlots venueData, int venueIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venueData.venue.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kTextDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${venueData.venue.city} • Cap. ${venueData.capacity}',
                    style: TextStyle(fontSize: 12, color: AppColors.kTextDark.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      venueList.removeAt(venueIndex);
                    });
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                ),
                ElevatedButton.icon(
                  onPressed: () => _openAddEventSlotSheet(venueData),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  icon: const Icon(Icons.add, size: 14),
                  label: const Text('Add Slot', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),

        if (venueData.slots.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF3E8E8)),
            ),
            child: Center(
              child: Text(
                'No slots added for this venue yet.',
                style: TextStyle(fontSize: 12, color: AppColors.kTextDark.withOpacity(0.4)),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (venueData.slots.length / 2).ceil(),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              int ticketIndex = index * 2;
              int tableIndex = ticketIndex + 1;

              EventSlot ticketSlot = venueData.slots[ticketIndex];
              EventSlot? tableSlot = tableIndex < venueData.slots.length ? venueData.slots[tableIndex] : null;

              return _buildSlotItemCard(
                slotNumber: index + 1,
                ticketSlot: ticketSlot,
                tableSlot: tableSlot,
                venueCapacity: venueData.capacity,
                onDelete: () {
                  setState(() {
                    venueData.slots.remove(ticketSlot);
                    if (tableSlot != null) venueData.slots.remove(tableSlot);
                  });
                },
              );
            },
          ),
      ],
    );
  }

  // ---------- Slot Form Card UI ----------
  Widget _buildSlotItemCard({
    required int slotNumber,
    required EventSlot ticketSlot,
    EventSlot? tableSlot,
    required int venueCapacity,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFD6D6), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Slot $slotNumber',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kTextDark,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: AppColors.kRed, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInputLabel('Slot Title'),
          const SizedBox(height: 4),
          _buildMockTextField(hint: 'e.g. Music Concert'),
          const SizedBox(height: 10),

          _buildInputLabel('From Date'),
          const SizedBox(height: 4),
          _buildMockTextField(
            hint: '${ticketSlot.date.day}/${ticketSlot.date.month}/${ticketSlot.date.year}',
            suffixIcon: Icons.calendar_today_outlined,
          ),
          const SizedBox(height: 10),

          _buildInputLabel('To Date'),
          const SizedBox(height: 4),
          _buildMockTextField(
            hint: '${ticketSlot.date.day}/${ticketSlot.date.month}/${ticketSlot.date.year}',
            suffixIcon: Icons.calendar_today_outlined,
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel('Start Time'),
                    const SizedBox(height: 4),
                    _buildMockTextField(hint: ticketSlot.startTime, suffixIcon: Icons.access_time),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel('End Time'),
                    const SizedBox(height: 4),
                    _buildMockTextField(hint: ticketSlot.endTime, suffixIcon: Icons.access_time),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateTicketBottomSheet(capacity: venueCapacity),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.kRed, width: 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Create Ticket', style: TextStyle(fontSize: 12, color: AppColors.kRed)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateTableBottomSheet(capacity: venueCapacity),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.kRed, width: 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Create Table', style: TextStyle(fontSize: 12, color: AppColors.kRed)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: AppColors.kTextDark),
    );
  }

  Widget _buildMockTextField({required String hint, IconData? suffixIcon}) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFD1D1), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hint,
            style: const TextStyle(fontSize: 12.5, color: AppColors.kHint),
          ),
          if (suffixIcon != null)
            Icon(suffixIcon, size: 16, color: AppColors.kHint),
        ],
      ),
    );
  }

  // ---------- Bottom Stacked Actions ----------
  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateTicketsScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFFFEAEA),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Skip Sessions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kRed,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateTicketsScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kRed,
                foregroundColor: AppColors.kWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Save & Proceed to Tickets',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Bottom sheet: Venue Location Selector
// =====================================================================
class _VenueLocationSheet extends StatefulWidget {
  const _VenueLocationSheet();

  @override
  State<_VenueLocationSheet> createState() => _VenueLocationSheetState();
}

class _VenueLocationSheetState extends State<_VenueLocationSheet> {
  VenueOption? _selected;
  final TextEditingController _capacityController = TextEditingController(text: '2500');

  @override
  void dispose() {
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(18, 12, 18, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Select Venue Location',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.kTextDark),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            itemCount: _venueOptions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final venue = _venueOptions[index];
              final isSelected = _selected?.name == venue.name;
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: isSelected ? AppColors.kRed : const Color(0xFFE5E7EB)),
                ),
                title: Text(venue.name, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                subtitle: Text(venue.city, style: const TextStyle(fontSize: 11.5)),
                onTap: () => setState(() => _selected = venue),
              );
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.kRed),
              onPressed: _selected == null
                  ? null
                  : () {
                      Navigator.pop(
                        context,
                        VenueWithSlots(
                          venue: _selected!,
                          capacity: int.tryParse(_capacityController.text) ?? 2500,
                        ),
                      );
                    },
              child: const Text('Add Venue', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}