// ✅ Remove self‑import
import 'package:fizma/Screens/add_event/add_event_slot.dart';
import 'package:fizma/Screens/add_event/add_venue_slot.dart' hide EventSlot, VenueOption;
import 'package:fizma/Screens/add_event/create_table_screen.dart';
import 'package:fizma/Screens/add_event/create_ticket/create_ticket.dart';
import 'package:fizma/Screens/add_event/create_ticket_n_tables_screen.dart' hide VenueOption;
import 'package:fizma/Screens/add_event/event_slot.dart' hide EventSlot;
import 'package:fizma/models_n_services/event_slot/event_slot_svc.dart';
import 'package:fizma/models_n_services/event_venue/event_venue_model.dart';
import 'package:fizma/models_n_services/event_venue/event_venue_svc.dart';
import 'package:fizma/models_n_services/event_slot/event_slot_model.dart';
import 'package:fizma/models_n_services/venue_list/venue_list_model.dart';
import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';

class VenueWithSlots {
  final VenueOption venue;
  final int capacity;
  final int safetyCap;
  final int? bufferCapacity;
  final List<EventSlot> slots;

  VenueWithSlots({
    required this.venue,
    required this.capacity,
    required this.safetyCap,
    this.bufferCapacity,
    List<EventSlot>? slots,
  }) : slots = slots ?? [];
}

class AddEventSlotScreen extends StatefulWidget {
  final int organiserId;
  final int eventId;

  const AddEventSlotScreen({
    super.key,
    required this.organiserId,
    required this.eventId,
  });

  @override
  State<AddEventSlotScreen> createState() => _AddEventSlotScreenState();
}

class _AddEventSlotScreenState extends State<AddEventSlotScreen> {
  final EventVenueService _venueService = EventVenueService();
  final EventSlotService _slotService = EventSlotService();
  List<VenueWithSlots> venueList = [];
  bool _isLoadingVenues = false;
  bool _isSubmitting = false;

  Future<void> _openAddEventSlotSheet(VenueWithSlots venueData) async {
    final result = await showModalBottomSheet<EventSlot>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEventSlotSheet(
        eventId: widget.eventId,
        venueId: venueData.venue.id,
        venueName: venueData.venue.name,
        venueCity: '',
        venueCapacity: venueData.capacity,
      ),
    );

    if (result != null) {
      setState(() {
        venueData.slots.add(result);
      });
    }
  }

  Future<void> _openVenueLocationSheet() async {
    setState(() => _isLoadingVenues = true);

    try {
      final response = await _venueService.getVenuesForEvent(widget.eventId);
      print('📋 Venues for event ${widget.eventId}:');
      for (var v in response.venues) {
        print('   mapping id: ${v.id}, actual venueId: ${v.venueId}, name: ${v.venueName}');
      }

      if (!mounted) return;

      if (response.venues.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No venues found for this event.')),
        );
        setState(() => _isLoadingVenues = false);
        return;
      }

      final venueOptions = response.venues.map((venue) {
        return VenueOption(
          id: venue.venueId,
          name: venue.venueName,
          capacity: venue.capacity,
          safetyCap: venue.safetyCap,
        );
      }).toList();

      final result = await showModalBottomSheet<VenueWithSlots>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _VenueLocationSheet(
          venues: venueOptions,
        ),
      );

      setState(() => _isLoadingVenues = false);

      if (result != null) {
        final alreadyExists = venueList.any((v) => v.venue.id == result.venue.id);
        if (alreadyExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${result.venue.name} is already added.')),
          );
          return;
        }
        setState(() {
          venueList.add(result);
        });
      }
    } catch (e) {
      setState(() => _isLoadingVenues = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load venues: $e')),
      );
    }
  }

  Future<void> _submitSlots() async {
    final allSlots = venueList.expand((v) => v.slots).toList();

    if (allSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one slot.')),
      );
      return;
    }

    for (var slot in allSlots) {
      if (slot.registrationDeadline.isAfter(slot.fromDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Registration deadline must be before start date for slot: "${slot.title}"\nPlease delete and re-add this slot.',
            ),
          ),
        );
        return;
      }
    }

    setState(() => _isSubmitting = true);

    final slotItems = allSlots.map((slot) {
      return SlotItemRequest(
        slotTitle: slot.title,
        venueId: slot.venueId,
        fromDate: slot.formatDateForApi(slot.fromDate),
        toDate: slot.formatDateForApi(slot.toDate),
        registrationDeadline: slot.formatDateForApi(slot.registrationDeadline),
        allDay: slot.allDay,
        startTime: slot.formatTimeForApi(slot.startTime),
        endTime: slot.formatTimeForApi(slot.endTime),
        repeatWeekly: slot.repeatWeekly,
        repeatDays: slot.repeatDaysAsStrings,
        status: 'active',
      );
    }).toList();

    final request = AddEventSlotRequest(
      eventId: widget.eventId,
      step: 4,
      slots: slotItems,
    );

    try {
      final response = await _slotService.addEventSlots(request);
      if (!mounted) return;

      if (response.success) {
        final serverSlots = response.data;
        int serverIndex = 0;
        for (var venue in venueList) {
          for (int i = 0; i < venue.slots.length; i++) {
            if (serverIndex < serverSlots.length) {
              final serverSlot = serverSlots[serverIndex];
              final localSlot = venue.slots[i];
              final updatedSlot = EventSlot(
                id: serverSlot.id,
                title: localSlot.title,
                fromDate: localSlot.fromDate,
                toDate: localSlot.toDate,
                registrationDeadline: localSlot.registrationDeadline,
                allDay: localSlot.allDay,
                startTime: localSlot.startTime,
                endTime: localSlot.endTime,
                repeatWeekly: localSlot.repeatWeekly,
                repeatDays: localSlot.repeatDays,
                capacity: localSlot.capacity,
                venueId: localSlot.venueId,
              );
              venue.slots[i] = updatedSlot;
              serverIndex++;
            }
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CreateTicketsScreen(
              eventId: widget.eventId,
              organiserId: widget.organiserId,
              venuesWithSlots: venueList,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.message}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting slots: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
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
          const Text('Add Event', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.kTextDark)),
          const SizedBox(width: 18),
        ],
      ),
    );
  }

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
              Text('Step 4 of 6', style: TextStyle(fontSize: 11, color: AppColors.kHint)),
              Text('Sessions', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.kRed)),
            ],
          ),
        ),
      ],
    );
  }

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
              style: TextStyle(fontSize: 12, color: Color(0xFF1D61E0), height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddVenueButton() {
    return OutlinedButton.icon(
      onPressed: _isLoadingVenues ? null : _openVenueLocationSheet,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        side: const BorderSide(color: AppColors.kRed, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: _isLoadingVenues
          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.kRed))
          : const Icon(Icons.add, size: 18, color: AppColors.kRed),
      label: Text(
        _isLoadingVenues
            ? 'Loading Venues...'
            : venueList.isEmpty
                ? 'Add Venue Location'
                : 'Add Another Venue Location',
        style: const TextStyle(color: AppColors.kRed, fontWeight: FontWeight.w600),
      ),
    );
  }

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
                  Text(venueData.venue.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.kTextDark)),
                  const SizedBox(height: 2),
                  Text(
                    'Cap. ${venueData.capacity} • Safety Cap. ${venueData.safetyCap}',
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
            itemCount: venueData.slots.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final slot = venueData.slots[index];
              return _buildSlotItemCard(
                slotNumber: index + 1,
                slot: slot,
                venueCapacity: venueData.capacity,
                onDelete: () {
                  setState(() {
                    venueData.slots.removeAt(index);
                  });
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildSlotItemCard({
    required int slotNumber,
    required EventSlot slot,
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
              Expanded(
                child: Text(
                  slot.title.isEmpty ? 'Slot $slotNumber' : slot.title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.kTextDark),
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
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: AppColors.kHint),
              const SizedBox(width: 6),
              Text(
                '${_formatDate(slot.fromDate)} → ${_formatDate(slot.toDate)}',
                style: TextStyle(fontSize: 12, color: AppColors.kTextDark.withOpacity(0.7)),
              ),
            ],
          ),
          const SizedBox(height: 4),

          Row(
            children: [
              const Icon(Icons.event_available, size: 14, color: AppColors.kRed),
              const SizedBox(width: 6),
              Text(
                'Reg. Deadline: ${_formatDate(slot.registrationDeadline)}',
                style: TextStyle(fontSize: 12, color: AppColors.kRed.withOpacity(0.7)),
              ),
            ],
          ),
          const SizedBox(height: 4),

          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: AppColors.kHint),
              const SizedBox(width: 6),
              Text(
                slot.allDay ? 'All Day' : '${slot.startTime ?? '--'} → ${slot.endTime ?? '--'}',
                style: TextStyle(fontSize: 12, color: AppColors.kTextDark.withOpacity(0.7)),
              ),
            ],
          ),
          const SizedBox(height: 4),

          if (slot.repeatWeekly && slot.repeatDays.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.event_repeat, size: 14, color: AppColors.kHint),
                const SizedBox(width: 6),
                Text(
                  'Repeats on: ${slot.repeatDays.map((d) => const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][d]).join(', ')}',
                  style: TextStyle(fontSize: 12, color: AppColors.kTextDark.withOpacity(0.7)),
                ),
              ],
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

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
              onPressed: _isSubmitting
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateTicketsScreen(
                            eventId: widget.eventId,
                            organiserId: widget.organiserId,
                            venuesWithSlots: venueList,
                          ),
                        ),
                      );
                    },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFFFEAEA),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Skip Sessions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.kRed)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitSlots,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kRed,
                foregroundColor: AppColors.kWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: _isSubmitting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.kWhite))
                  : const Text('Save & Proceed to Tickets', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
  final List<VenueOption> venues;
  const _VenueLocationSheet({required this.venues});

  @override
  State<_VenueLocationSheet> createState() => _VenueLocationSheetState();
}

class _VenueLocationSheetState extends State<_VenueLocationSheet> {
  VenueOption? _selected;

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
          const Text('Select Venue Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.kTextDark)),
          const SizedBox(height: 4),
          Text('${widget.venues.length} venues available', style: TextStyle(fontSize: 12, color: AppColors.kTextDark.withOpacity(0.5))),
          const SizedBox(height: 12),
          if (widget.venues.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No venues available for this event.')))
          else
            ListView.separated(
              shrinkWrap: true,
              itemCount: widget.venues.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final venue = widget.venues[index];
                final isSelected = _selected?.id == venue.id;
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: isSelected ? AppColors.kRed : const Color(0xFFE5E7EB), width: isSelected ? 2 : 1),
                  ),
                  title: Text(venue.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    'Cap. ${venue.capacity} • Safety Cap. ${venue.safetyCap}',
                    style: TextStyle(fontSize: 11, color: AppColors.kTextDark.withOpacity(0.6)),
                  ),
                  trailing: isSelected
                      ? Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(color: AppColors.kRed, shape: BoxShape.circle),
                          child: const Icon(Icons.check, size: 16, color: Colors.white),
                        )
                      : null,
                  onTap: () => setState(() => _selected = venue),
                );
              },
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kRed,
                foregroundColor: Colors.white,
              ),
              onPressed: _selected == null
                  ? null
                  : () {
                      Navigator.pop(
                        context,
                        VenueWithSlots(
                          venue: _selected!,
                          capacity: _selected!.capacity,
                          safetyCap: _selected!.safetyCap,
                        ),
                      );
                    },
              child: const Text('Add Venue'),
            ),
          ),
        ],
      ),
    );
  }
}