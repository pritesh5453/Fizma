import 'package:fizma/Screens/add_event/add_event_slot.dart';
import 'package:fizma/Screens/add_event/create_ticket.dart';
import 'package:fizma/Screens/add_event/event_slot.dart';
import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';

class VenueOption {
  final String name;
  final String city;
  const VenueOption({required this.name, required this.city});
}

const List<VenueOption> _venueOptions = [
  VenueOption(name: 'Siddhivinayak Community Hall', city: 'Nashik'),
  VenueOption(name: 'Nazrul Mancha', city: 'Rabindra Sarobar, Nashik'),
  VenueOption(name: 'Kala Mandir', city: 'Shakespeare Sarani, Nashik'),
];

class AddVenueScreen extends StatefulWidget {
  const AddVenueScreen({super.key});

  @override
  State<AddVenueScreen> createState() => _AddVenueScreenState();
}

class _AddVenueScreenState extends State<AddVenueScreen> {
  VenueOption? selectedVenue;
  final List<EventSlot> eventSlots = [];

  Future<void> _openAddEventSlotSheet() async {
    if (selectedVenue == null) return;
    final result = await showModalBottomSheet<EventSlot>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEventSlotSheet(
        venueName: selectedVenue!.name,
        venueCity: selectedVenue!.city,
      ),
    );

    if (result != null) {
      setState(() {
        final index = eventSlots.length;
        eventSlots.add(EventSlot(
          title: 'Event ${index + 1}',
          date: result.date,
          startTime: result.startTime,
          endTime: result.endTime,
          capacity: result.capacity,
          actionLabel: index.isEven ? 'Create Ticket' : 'Create Table',
        ));
      });
    }
  }

  Future<void> _openVenueLocationSheet() async {
    final result = await showModalBottomSheet<VenueOption>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _VenueLocationSheet(initialSelection: selectedVenue),
    );

    if (result != null) {
      setState(() => selectedVenue = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: AppColors.screenGradient,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              _buildProgressBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _eventSummaryCard(),
                      const SizedBox(height: 20),

                      _label('Select Venue Location'),
                      const SizedBox(height: 10),
                      _outlinedActionButton(
                        icon: Icons.add,
                        label: 'Add New Venue',
                        onTap: _openVenueLocationSheet,
                      ),

                      if (selectedVenue != null) ...[
                        const SizedBox(height: 14),
                        _venueCard(selectedVenue!),
                      ],
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

  // ---------- Top App Bar ----------
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.kTextDark),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Venue',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kTextDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Add venues and create show slots',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.kTextDark.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Progress Bar (4 segments, step 3 mostly active) ----------
  Widget _buildProgressBar() {
    final fills = [1.0, 1.0, 0.15, 0.0];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: List.generate(4, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index == 3 ? 0 : 6),
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: fills[index],
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.kRed,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
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

  // ---------- Event summary card at top ----------
  Widget _eventSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorder, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.kChipBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.calendar_month, color: AppColors.kRed, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Flexible(
                      child: Text(
                        'Bhajan Concert 2026',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.kTextDark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF0C8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Draft',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFB8860B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'By Anup Jalota',
                  style: TextStyle(fontSize: 12, color: AppColors.kTextDark.withOpacity(0.6)),
                ),
                const SizedBox(height: 2),
                Text(
                  'Hindi, Marathi • ID: EVT-2026-001',
                  style: TextStyle(fontSize: 11, color: AppColors.kHint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Outlined pill-ish action button ("+ Add New Venue" / "+ Add Event Slot") ----------
  Widget _outlinedActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.kRed, width: 1.3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppColors.kRed),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kRed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Selected venue card with stats + Add Event Slot ----------
  Widget _venueCard(VenueOption venue) {
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
              const Icon(Icons.location_on, color: AppColors.kRed, size: 18),
              const SizedBox(width: 6),
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
                      venue.city,
                      style: TextStyle(fontSize: 12, color: AppColors.kTextDark.withOpacity(0.55)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _statChip(Icons.calendar_today_outlined, '${eventSlots.length} shows'),
              const SizedBox(width: 14),
              _statChip(Icons.groups_outlined, '${_totalCapacity()} capacity'),
              const SizedBox(width: 14),
              _statChip(Icons.grid_view_rounded, '${_typeCount()} types'),
            ],
          ),
          if (eventSlots.isNotEmpty) ...[
            const SizedBox(height: 14),
            ...eventSlots.map((slot) => EventSlotCard(
                  slot: slot,
                  onActiveChanged: (v) => setState(() => slot.isActive = v),
                  onActionTap: () {},
                  onEditTap: () {},
                  onDeleteTap: () => setState(() => eventSlots.remove(slot)),
                )),
          ],
          const SizedBox(height: 4),
          _outlinedActionButton(
            icon: Icons.add,
            label: 'Add Event Slot',
            onTap: _openAddEventSlotSheet,
          ),
        ],
      ),
    );
  }

  int _totalCapacity() =>
      eventSlots.fold(0, (sum, s) => sum + s.capacity);

  int _typeCount() =>
      eventSlots.map((s) => s.actionLabel).toSet().length;

  Widget _statChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.kHint),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11.5, color: AppColors.kHint)),
      ],
    );
  }

  // ---------- Bottom Back / Save & Proceed Buttons ----------
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
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.kWhite,
                  side: const BorderSide(color: AppColors.kRed, width: 1.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kRed,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => const CreateTicketsScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kRed,
                  foregroundColor: AppColors.kWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save & Proceed',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kWhite,
                  ),
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
// Bottom sheet: "Venue Location" search + results + Confirm Venue
// =====================================================================
class _VenueLocationSheet extends StatefulWidget {
  final VenueOption? initialSelection;
  const _VenueLocationSheet({this.initialSelection});

  @override
  State<_VenueLocationSheet> createState() => _VenueLocationSheetState();
}

class _VenueLocationSheetState extends State<_VenueLocationSheet> {
  late VenueOption? _selected = widget.initialSelection;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _venueOptions
        .where((v) => v.name.toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Venue Location',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kTextDark,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: AppColors.kChipBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 16, color: AppColors.kRed),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Search field
            Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.kWhite,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.kBorder, width: 1.2),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 18, color: AppColors.kHint),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: 'Search venues, areas, or cities...',
                        hintStyle: TextStyle(color: AppColors.kHint, fontSize: 13.5),
                      ),
                      style: const TextStyle(fontSize: 13.5, color: AppColors.kTextDark),
                    ),
                  ),
                  const Icon(Icons.tune, size: 18, color: AppColors.kHint),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Near Me / Recent Searches chips
            Row(
              children: [
                _pillChip(
                  icon: Icons.my_location,
                  label: 'Near Me',
                  filled: true,
                ),
                const SizedBox(width: 8),
                _pillChip(
                  icon: Icons.history,
                  label: 'Recent Searches',
                  filled: false,
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Results list
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.32),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final venue = filtered[index];
                  final isSelected = _selected?.name == venue.name;
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _selected = venue),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.kRed : AppColors.kBorder,
                          width: isSelected ? 1.6 : 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(
                              color: AppColors.kChipBg,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.location_on, size: 16, color: AppColors.kRed),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  venue.name,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.kTextDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  venue.city,
                                  style: TextStyle(fontSize: 11.5, color: AppColors.kTextDark.withOpacity(0.55)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _selected == null ? null : () => Navigator.pop(context, _selected),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kRed,
                  disabledBackgroundColor: AppColors.kRed.withOpacity(0.4),
                  foregroundColor: AppColors.kWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirm Venue',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pillChip({required IconData icon, required String label, required bool filled}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: filled ? AppColors.kRed : AppColors.kChipBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: filled ? AppColors.kWhite : AppColors.kTextDark.withOpacity(0.6)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: filled ? AppColors.kWhite : AppColors.kTextDark.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}