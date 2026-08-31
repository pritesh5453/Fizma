import 'package:fizmaa/utils/appcolors.dart';
import 'package:flutter/material.dart';

/// Simple data model representing one scheduled show/slot for a venue.
class EventSlot {
  final String title;
  final DateTime date;
  final String startTime; // e.g. "8:00 PM"
  final String endTime; // e.g. "11:00 PM"
  final int capacity;
  final String actionLabel; // "Create Ticket" / "Create Table"
  bool isActive;

  EventSlot({
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    this.actionLabel = 'Create Ticket',
    this.isActive = true,
  });
}

/// Card used inside the venue section to display a single [EventSlot],
/// matching the "Event 1 / Event 2" cards in the design.
class EventSlotCard extends StatelessWidget {
  final EventSlot slot;
  final ValueChanged<bool>? onActiveChanged;
  final VoidCallback? onActionTap;
  final VoidCallback? onEditTap;
  final VoidCallback? onDeleteTap;

  const EventSlotCard({
    super.key,
    required this.slot,
    this.onActiveChanged,
    this.onActionTap,
    this.onEditTap,
    this.onDeleteTap,
  });

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
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
              // date badge
              Container(
                width: 44,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.kPinkLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.kBorder, width: 1),
                ),
                child: Column(
                  children: [
                    Text(
                      '${slot.date.day}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.kTextDark,
                      ),
                    ),
                    Text(
                      _months[slot.date.month - 1],
                      style: const TextStyle(fontSize: 10, color: AppColors.kHint),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      slot.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.kTextDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 12, color: AppColors.kHint),
                        const SizedBox(width: 4),
                        Text(
                          '${slot.startTime} - ${slot.endTime}',
                          style: const TextStyle(fontSize: 11.5, color: AppColors.kHint),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.groups_outlined, size: 12, color: AppColors.kHint),
                        const SizedBox(width: 4),
                        Text(
                          '${slot.capacity}',
                          style: const TextStyle(fontSize: 11.5, color: AppColors.kHint),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Switch(
                value: slot.isActive,
                onChanged: onActiveChanged,
                activeColor: const Color(0xFF22C55E),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: OutlinedButton.icon(
                    onPressed: onActionTap,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.kWhite,
                      side: const BorderSide(color: AppColors.kRed, width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 14, color: AppColors.kRed),
                    label: Text(
                      slot.actionLabel,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.kRed,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _squareIconButton(icon: Icons.edit_outlined, onTap: onEditTap),
              const SizedBox(width: 8),
              _squareIconButton(icon: Icons.delete_outline, onTap: onDeleteTap, isDelete: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _squareIconButton({required IconData icon, VoidCallback? onTap, bool isDelete = false}) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDelete ? AppColors.kRed.withOpacity(0.6) : AppColors.kBorder,
            width: 1.2,
          ),
        ),
        child: Icon(icon, size: 16, color: isDelete ? AppColors.kRed : AppColors.kTextDark.withOpacity(0.6)),
      ),
    );
  }
}