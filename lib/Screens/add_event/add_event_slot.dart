import 'package:fizma/Screens/add_event/event_slot.dart';
import 'package:fizma/utils/appcolors.dart';
import 'package:flutter/material.dart';

/// Bottom-sheet form for scheduling a new [EventSlot] against a venue.
/// Returns the created [EventSlot] via Navigator.pop when saved.
class AddEventSlotSheet extends StatefulWidget {
  final String venueName;
  final String venueCity;

  const AddEventSlotSheet({
    super.key,
    required this.venueName,
    required this.venueCity,
  });

  @override
  State<AddEventSlotSheet> createState() => _AddEventSlotSheetState();
}

class _AddEventSlotSheetState extends State<AddEventSlotSheet> {
  // ---------- Date range ----------
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now().add(const Duration(days: 1));

  // ---------- Time ----------
  int startHour = 9;
  int startMinute = 0;
  bool startIsAM = true;

  int endHour = 11;
  int endMinute = 45;
  bool endIsAM = false;

  bool allDay = false;

  // ---------- Repeat ----------
  bool repeatWeekly = false;
  final Set<int> repeatDays = {}; // 0=S,1=M,...6=S

  static const List<String> _dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  static const List<String> _weekdayNames = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];

  // ---------- Helpers ----------
  String get _durationLabel {
    final start = TimeOfDay(hour: _to24h(startHour, startIsAM), minute: startMinute);
    final end = TimeOfDay(hour: _to24h(endHour, endIsAM), minute: endMinute);
    int startMins = start.hour * 60 + start.minute;
    int endMins = end.hour * 60 + end.minute;
    int diff = endMins - startMins;
    if (diff < 0) diff += 24 * 60;
    final h = diff ~/ 60;
    final m = diff % 60;
    return '${h}h ${m}m duration';
  }

  int _to24h(int hour, bool isAM) {
    int h = hour % 12;
    if (!isAM) h += 12;
    return h;
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        selectedStartDate = picked;
        // If end date is before start date, adjust it
        if (selectedEndDate.isBefore(selectedStartDate)) {
          selectedEndDate = selectedStartDate.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: selectedStartDate, // cannot be before start
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        selectedEndDate = picked;
      });
    }
  }

  // Registration deadline – we keep it as a separate date picker
  DateTime selectedRegistrationDeadline = DateTime.now().add(const Duration(days: 5));

  Future<void> _pickRegistrationDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedRegistrationDeadline,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        selectedRegistrationDeadline = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final weekday = _weekdayNames[date.weekday - 1];
    return '${date.day} ${months[date.month - 1]} ${date.year}, $weekday';
  }

  void _save() {
    // Validate: end date must not be before start date
    if (selectedEndDate.isBefore(selectedStartDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date must be after start date.')),
      );
      return;
    }

    final start = '${_displayHour(startHour)}:${startMinute.toString().padLeft(2, '0')} ${startIsAM ? 'AM' : 'PM'}';
    final end = '${_displayHour(endHour)}:${endMinute.toString().padLeft(2, '0')} ${endIsAM ? 'PM' : 'AM'}';

    // NOTE: Update your EventSlot model to have both startDate and endDate.
    // For now, we keep the old 'date' field as startDate for compatibility.
    // In your parent screen, you'll need to use slot.startDate and slot.endDate.
    final slot = EventSlot(
      date: selectedStartDate,        // to be removed after migration
      startTime: start,
      endTime: end,
      capacity: 2500, title: '',
      // also pass registration deadline if needed
    );
    Navigator.pop(context, slot);
  }

  int _displayHour(int h) => h == 0 ? 12 : h;

  void _toggleAllDay(bool value) {
    setState(() {
      allDay = value;
      if (allDay) {
        startHour = 12;
        startMinute = 0;
        startIsAM = true;
        endHour = 11;
        endMinute = 59;
        endIsAM = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Header ----------
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Add Venue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kTextDark,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.kWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.kRed, width: 1.2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.add, size: 14, color: AppColors.kRed),
                      SizedBox(width: 4),
                      Text(
                        'Add Volunteer',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.kRed),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
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

            // ---------- Venue context card ----------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.kWhite,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.kBorder, width: 1.2),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.kRed, size: 18),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.venueName,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.kTextDark,
                        ),
                      ),
                      Text(
                        widget.venueCity,
                        style: TextStyle(fontSize: 11.5, color: AppColors.kTextDark.withOpacity(0.55)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ---------- Schedule card ----------
            Container(
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
                    'Venue Schedule',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.kTextDark),
                  ),
                  const SizedBox(height: 12),

                  // --- From Date ---
                  const Text('From Date', style: TextStyle(fontSize: 11.5, color: AppColors.kHint, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: _pickStartDate,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.kBorder, width: 1.2),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 15, color: AppColors.kRed),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _formatDate(selectedStartDate),
                              style: const TextStyle(fontSize: 13, color: AppColors.kTextDark),
                            ),
                          ),
                          const Icon(Icons.calendar_month_outlined, size: 16, color: AppColors.kHint),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // --- To Date ---
                  const Text('To Date', style: TextStyle(fontSize: 11.5, color: AppColors.kHint, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: _pickEndDate,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.kBorder, width: 1.2),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 15, color: AppColors.kRed),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _formatDate(selectedEndDate),
                              style: const TextStyle(fontSize: 13, color: AppColors.kTextDark),
                            ),
                          ),
                          const Icon(Icons.calendar_month_outlined, size: 16, color: AppColors.kHint),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // --- Registration Deadline ---
                  const Text('Registration Deadline', style: TextStyle(fontSize: 11.5, color: AppColors.kHint, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: _pickRegistrationDeadline,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.kBorder, width: 1.2),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 15, color: AppColors.kRed),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _formatDate(selectedRegistrationDeadline),
                              style: const TextStyle(fontSize: 13, color: AppColors.kTextDark),
                            ),
                          ),
                          const Icon(Icons.calendar_month_outlined, size: 16, color: AppColors.kHint),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ---------- Time row with All Day toggle ----------
                  Row(
                    children: [
                      const Text('Time Details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.kTextDark)),
                      const Spacer(),
                      Row(
                        children: [
                          const Text(
                            'All Day',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.kTextDark),
                          ),
                          const SizedBox(width: 4),
                          Switch(
                            value: allDay,
                            onChanged: _toggleAllDay,
                            activeColor: AppColors.kRed,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (!allDay)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1F8EA),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time, size: 12, color: Color(0xFF22C55E)),
                            const SizedBox(width: 4),
                            Text(
                              _durationLabel,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF22C55E), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),

                  // ---------- Time pickers ----------
                  Row(
                    children: [
                      Expanded(
                        child: _timePicker(
                          label: 'START TIME',
                          hour: startHour,
                          minute: startMinute,
                          isAM: startIsAM,
                          onHourChanged: (h) => setState(() => startHour = h),
                          onMinuteChanged: (m) => setState(() => startMinute = m),
                          onAmPmChanged: (am) => setState(() => startIsAM = am),
                          enabled: !allDay,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _timePicker(
                          label: 'END TIME',
                          hour: endHour,
                          minute: endMinute,
                          isAM: endIsAM,
                          onHourChanged: (h) => setState(() => endHour = h),
                          onMinuteChanged: (m) => setState(() => endMinute = m),
                          onAmPmChanged: (am) => setState(() => endIsAM = am),
                          enabled: !allDay,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ---------- Repeat week ----------
                  Row(
                    children: [
                      const Icon(Icons.event_repeat, size: 16, color: AppColors.kRed),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'Repeat every week on:',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.kTextDark),
                        ),
                      ),
                      Switch(
                        value: repeatWeekly,
                        onChanged: (v) => setState(() => repeatWeekly = v),
                        activeColor: AppColors.kRed,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      final selected = repeatDays.contains(index);
                      return InkWell(
                        onTap: repeatWeekly
                            ? () => setState(() {
                                  if (selected) {
                                    repeatDays.remove(index);
                                  } else {
                                    repeatDays.add(index);
                                  }
                                })
                            : null,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected ? AppColors.kRed : AppColors.kWhite,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected ? AppColors.kRed : AppColors.kBorder,
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            _dayLabels[index],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: selected ? AppColors.kWhite : AppColors.kTextDark.withOpacity(0.6),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ---------- Save button ----------
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _save,
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
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.kWhite),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Time picker widget ----------
  Widget _timePicker({
    required String label,
    required int hour,
    required int minute,
    required bool isAM,
    required ValueChanged<int> onHourChanged,
    required ValueChanged<int> onMinuteChanged,
    required ValueChanged<bool> onAmPmChanged,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.kHint, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: enabled ? AppColors.kWhite : AppColors.kChipBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.kBorder, width: 1.2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: enabled ? AppColors.kTextDark : AppColors.kTextDark.withOpacity(0.4),
                  ),
                ),
              ),
              _amPmToggle(isAM: isAM, onChanged: onAmPmChanged, enabled: enabled),
            ],
          ),
        ),
      ],
    );
  }

  Widget _amPmToggle({
    required bool isAM,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.kPinkLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _amPmButton('AM', isAM, () { if (enabled) onChanged(true); }, enabled: enabled),
          _amPmButton('PM', !isAM, () { if (enabled) onChanged(false); }, enabled: enabled),
        ],
      ),
    );
  }

  Widget _amPmButton(String label, bool selected, VoidCallback onTap, {bool enabled = true}) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.kRed : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: selected
                ? AppColors.kWhite
                : enabled
                    ? AppColors.kTextDark.withOpacity(0.5)
                    : AppColors.kTextDark.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}